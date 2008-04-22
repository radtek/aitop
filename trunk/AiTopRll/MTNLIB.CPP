//////////////////////////////////////////////////////////////////////////
// Copyright (C) 2001 Intel Corporation
// All rights reserved.
//
// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
// ANY KIND EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED
// TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
// PARTICULAR PURPOSE.
//////////////////////////////////////////////////////////////////////////

// mtnlib.c: Library functions for mtnlib.h.
#include "stdafx.h"
#ifndef STRICT
#define STRICT
#endif
#include <stdio.h>
#include <windows.h>
#include <process.h>
#include "mtnlib.h"
#include "ntrll.h"

//*************
// Private data
//*************

static char mtnlib_ret_val[MT_MAX_RETURN_STRING+1];

static BOOL bMTInitDone = FALSE;	// Init status	

// Global arrays to be allocated depending on number of tasks
static MTARGS *MtArgs;		// Args, index is VOS task nr (pid)
static DWORD *dwThreadIds;	// thread ids, index is VOS task nr (pid)
static HANDLE *hEvents;		// Events handle array, index is VOS task nr (pid)
static char ***gargv;		// Global pool of arguments for all the tasks

// Background thread function to be started by _beginthreadex
static unsigned int __stdcall MtBackgroundThread(void *);  

//******************
// Private functions
//******************

// Get vos task nr from within the mt function.
// Cannot use regular getpid() when inside mt function,
// must use saved value.
int MtGetpid(DWORD dwThreadId)
	{
	int pid;

	for (pid=0; pid < MT_MAX_TASKS; pid++)
		if (dwThreadIds[pid] == dwThreadId)
			return pid;
	return MT_INVALID_PID;
	}

// Get copy of argv[] for the thread
static char **get_local_argv(int argc, char **argv, int pid)
	{
	int ArgCnt,ArgLen;
	char **largv;

	largv = gargv[pid];
	if (largv == NULL)
		{
		voslog("@E mtnlib.c, get_local_argv(): largv==NULL");
		return NULL;
		}

	// Save copy of argv in largv
	for (ArgCnt = 0; ArgCnt < argc; ArgCnt++)
		{
		ArgLen = (int)strlen(argv[ArgCnt]);
		if (largv[ArgCnt] == NULL)
			{
			voslog("@E mtnlib.c, get_local_argv(): largv[%d]==NULL", ArgCnt);
			return NULL;
			}
		strcpy(largv[ArgCnt], argv[ArgCnt]);
		}
	return largv;
	}

// Allocate global pool of memory for MT_MAX_TASKS tasks
static char ***alloc_global_argv(void)
	{
	int pid, argc;
	char **targv;  // temporary argv

	gargv = (char ***) calloc(MT_MAX_TASKS, sizeof(char **));
	if (gargv == NULL)
		goto OutOfMemory;

	for (pid = 0; pid < MT_MAX_TASKS; pid++)
		{
		targv = (char **)calloc(MT_MAX_ARGC, sizeof(char *));
		if (targv == NULL)
			goto OutOfMemory;
		for (argc=0; argc < MT_MAX_ARGC; argc++)
			{
			targv[argc]=(char *)calloc(MT_MAX_ARGV_LENGTH, sizeof (char));
			if (targv[argc] == NULL)
				goto OutOfMemory;
			}
		gargv[pid] = targv;
		}
	return gargv;

OutOfMemory:
	voslog("@E mtnlib.c alloc_global_argv, out of memory");
	return NULL;
	}

// Free shared pool of memory
static void free_global_argv(void)
	{
	int pid, argc;
	char **targv;  // temporary argv

	for (pid = 0; pid < MT_MAX_TASKS; pid++)
		{
		targv = gargv[pid];
		for (argc=0; argc < MT_MAX_ARGC; argc++)
			free(targv[argc]);
		free (targv);
		}
	free(gargv);
	}

void FreeGlobals(void)
{
	if (!MtArgs || !dwThreadIds || !hEvents || !gargv || !bMTInitDone)
		return;
	free_global_argv();
	free(hEvents);
	free(dwThreadIds);
	free (MtArgs);
}

static int AllocateGlobals(void)
	{
	MtArgs =   (MTARGS *)calloc(MT_MAX_TASKS, sizeof(MTARGS));
	dwThreadIds = (DWORD *)calloc(MT_MAX_TASKS, sizeof(DWORD));
	hEvents =  (HANDLE *)calloc(MT_MAX_TASKS, sizeof(HANDLE));
	gargv = alloc_global_argv();
	if (!MtArgs || !dwThreadIds || !hEvents || !gargv)
		return MTE_OUT_OF_MEMORY;
	return MTE_OK;
	}

static void InvalidatePID()
	{
	int pid;

	for (pid=0; pid < MT_MAX_TASKS; pid++)
		MtArgs[pid].PID = MT_INVALID_PID;
	}

static void WakeAfterWindowsError(int MyError, int pid)
	{
	char error_return[16];
	voslog(
	  "@E mtnlib.c error, pid=%d, GetLastError()=0x%08lx, mtnlib error=%d",
	  pid, GetLastError(), MyError);
	wakeup(pid, itoa(MyError, error_return, 10));
	}

// Start new thread
static int InitializeThread(int pid)
	{
	DWORD dwThreadID;
	HANDLE hEvt, hThread;
	DWORD dwError;

	// Create event to wait for for our thread
	hEvt = CreateEvent( NULL,	// security
						TRUE,   // manual
						FALSE,	// non-signalled
						NULL);  // no name
	if (!hEvt)
		{
		dwError = GetLastError();
		voslog (
"mtnlib.c, InitializeThread: CreateEvent failed pid %d, GetLastError=0x%08lx.",
		  pid, dwError);
		return MTE_CREATE_EVENT_ERROR;
		}

	hEvents[pid]  = hEvt;  // save our event
	
	MtArgs[pid].PID = pid;  // original pid for waitsingleobj
	MtArgs[pid].argc = 0;	// not used here
	MtArgs[pid].argv = NULL;// not used here

	// Create threads for our tasks
	hThread = (HANDLE) _beginthreadex(
		NULL,					// security
		0,						// stack_size
		MtBackgroundThread,				// start_address
		(LPVOID) &MtArgs[pid],	// arglist
		0,						// start immediately
		(UINT *)&dwThreadID);			// thrdaddr
	if(!hThread)
		{
		dwError = GetLastError();
		voslog (
"mtnlib.c, InitializeThread: _beginthreadex failed pid %d, GetLastError=0x%08lx.",
		  pid, dwError);
		return MTE_CREATE_THREAD_ERROR;
		}

	dwThreadIds[pid] = dwThreadID; 
	return MTE_OK;
	}

// This is the function started as a new thread by _beginthreadex
unsigned int __stdcall MtBackgroundThread(void *vp)
	{
	int pid;
	func_ptr fptr; // pointer to RLL function to be called on the thread
	MTARGS *lpMtArgs = (MTARGS *)vp; 
	char szReturn[MT_MAX_RETURN_STRING+1]; 
	DWORD dwRC;
	HANDLE hEvt;  

	if (!lpMtArgs)
		{
		voslog("MtBackgroundThread(): Error! vp==NULL");
		MessageBox(NULL, "Fatal error 0001", "MTNLIB", MB_OK | MB_ICONERROR);
// There's no way to recover from this, just give up & return
		return 911;
		}

// Need to be 100% sure of PID because we need it to do wakeup.
	pid = lpMtArgs->PID;
	if (pid < 0 || pid >= MT_MAX_TASKS)
		{
		voslog("MtBackgroundThread(): Error! PID=%u, MT_MAX_TASKS=%d",
			pid, MT_MAX_TASKS);
		MessageBox(NULL, "Fatal error 0002", "MTNLIB", MB_OK | MB_ICONERROR);
// There's no way to recover from this either, just give up & return
		return 911;
		}
	
	hEvt = hEvents[pid];   // get evt handle for our task

	// main loop, thread never exits until VOS exits
	for (;;)
		{
		// Wait for request from the RLL function
		dwRC = WaitForSingleObject(hEvt, INFINITE);
		if (dwRC == WAIT_FAILED)
			{
			WakeAfterWindowsError(MTE_WAIT_OBJECT_ERROR, pid);
			// No way to recover from this, just give up & return
			return 911;
			}

		// Restore event status for next call 
		dwRC = ResetEvent(hEvt); 
		if (!dwRC)
			{
			WakeAfterWindowsError(MTE_RESET_EVENT_ERROR, pid);
			// No way to recover from this, just give up & return
			return 911;
			}

		fptr = lpMtArgs->mt_fptr; // RLL function
		if (fptr == NULL)
			{
			voslog("@E mtnlib.c fptr=NULL pid=%d", pid);
			MessageBox(NULL, "Fatal error 0003", "MTN RLL",
			  MB_OK | MB_ICONERROR);
			// No way to recover from this, just give up & return
			return 911;
			}

		// Call our RLL function
		// The return string is copied in szReturn inside this
		// user-defined function by MT_RETURN macro
		(*fptr)(lpMtArgs->argc,lpMtArgs->argv, szReturn);

	// Tell VOS to wake-up the task that called the original RLL function.
	// WARNING: szReturn must be a local variable, if it's global
	// it will be shared by all threads and could be overwritten
	// by another thread before these statements are completed.
		wakeup(pid, szReturn);
		}
	return 0;  // never reached
	}

//*****************
// Public functions
//*****************

int MtPrepareCall(int argc, char **argv, int pid, func_ptr MtFunc)
	{
	char **largv;
	int rc;

	if (pid >= MT_MAX_TASKS)
		{
		voslog("@E mtnlib.c, pid=%d out of range.", pid);
		return MTE_BAD_PID;
		}

	if (bMTInitDone == FALSE)
		{
		// Allocate data
		rc = AllocateGlobals();
		if (rc != MTE_OK)
			{
			voslog ("MTN error: Out of memory allocating globals");
			return(rc);
			}
		InvalidatePID();  // invalidate pid for all tasks
		bMTInitDone = TRUE;
		}

	// If no thread started yet for this pid, start it
	if (MtArgs[pid].PID == MT_INVALID_PID)
		{
		rc = InitializeThread(pid);
		if (rc != MTE_OK)
			{
			voslog ("@E mtnlib.c, InitializeThread=%d pid %d",
			  rc, pid);
			return rc;
			}
		}

    // Remember: alloc done just once during 1st mt call
	// Get local space for the thread arguments
	largv = get_local_argv(argc, argv, pid);
	if (!largv)		// get failed
		{
		voslog("@E mtnlib.c, MtPrepareCall, get_local_argv=NULL");
		return MTE_BAD_MEMORY;
		}

// Store args and pid, will be retrieved from here by background thread.
	MtArgs[pid].PID = pid;
	MtArgs[pid].argc = argc;
	MtArgs[pid].argv = largv;
	MtArgs[pid].mt_fptr = MtFunc;

	return MTE_OK;
	}

void MtResumeThread(int pid)
	{
	BOOL bResult;

	bResult = SetEvent(hEvents[pid]);
	if (!bResult)
		WakeAfterWindowsError(MTE_SET_EVENT_ERROR, pid);
	}

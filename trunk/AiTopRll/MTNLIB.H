//////////////////////////////////////////////////////////////////////////
// Copyright (C) 2001 Intel Corporation
// All rights reserved.
//
// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
// ANY KIND EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED
// TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
// PARTICULAR PURPOSE.
//////////////////////////////////////////////////////////////////////////

// mtnlib.h: Header for Multi-Tasking RLL macros and functions.

#ifndef	MTNLIB_H
#define MTNLIB_H

#include <stdlib.h>	// for _itoa

#ifdef __cplusplus
extern "C"
{
#endif

#define mt_func		void 

#define MT_MAX_ARGC				16
#define MT_MAX_ARGV_LENGTH		128
#define	MT_MAX_RETURN_STRING	127
#define	MT_MAX_ERROR_STRING		32
#define MT_INVALID_PID			(-1)
#define	MT_MAX_TASKS			4096

// Error codes
#define MTE_NOT_INITIALIZED			(-99)

#define	MTE_OK						0
#define MTE_OUT_OF_MEMORY			(-1)
#define MTE_BAD_PID					(-2)
#define MTE_CREATE_EVENT_ERROR		(-3)
#define MTE_CREATE_THREAD_ERROR		(-4)
#define MTE_SET_EVENT_ERROR			(-5)
#define MTE_WAIT_OBJECT_ERROR		(-6)
#define MTE_RESET_EVENT_ERROR		(-7)
#define MTE_ALREADY_SET				(-8)
#define MTE_BAD_MEMORY				(-9)

typedef mt_func (*func_ptr)(int argc, char **argv, char *retval);

typedef struct tag_MTARGS
	{
	unsigned PID;
	int argc;
	char **argv;
	func_ptr mt_fptr; 
	} MTARGS;

int MtGetpid(DWORD dwThreadId);
int MtPrepareCall(int argc, char **argv, int pid, func_ptr MtFunc);
void MtResumeThread(int pid);
void FreeGlobals(void);
#define MT_CLEANUP FreeGlobals();

#define MT_BEGIN_FUNC(FuncName) \
mt_func __MT_##FuncName(int argc, char **argv, char *retval_) {

#define MT_END_FUNC(FuncName) } \
t_func FuncName(int argc, char **argv)  \
	{  \
	int pid = getpid(); \
	int rc = MtPrepareCall(argc, argv, pid, __MT_##FuncName); \
	if (rc != MTE_OK) \
		{ \
		static char ret_str[16]; \
		return _itoa(rc, ret_str, 10); \
		} \
	suspend(); \
	MtResumeThread(pid); \
	return ""; \
	}

#define MT_RETURN(String) \
	{ \
	retval_[MT_MAX_RETURN_STRING] = 0; \
	strncpy(retval_, String, MT_MAX_RETURN_STRING); \
	return; \
	}

#ifdef __cplusplus
}
#endif

#endif	// #ifndef MTNLIB_H

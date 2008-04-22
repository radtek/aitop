//////////////////////////////////////////////////////////////////////////
// Copyright (C) 2001 Intel Corporation
// All rights reserved.
//
// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
// ANY KIND EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED
// TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
// PARTICULAR PURPOSE.
//////////////////////////////////////////////////////////////////////////

// rllstruc.h: RLL structures

#pragma once

//#ifdef	__cplusplus
#define DLLEXPORT	extern "C" __declspec(dllexport)
//#else
//#define DLLEXPORT	__declspec(dllexport)
//#endif

#define VAR_ARGS	(-1)
#define ENTRY_FUNC	(-2)
#define EXIT_FUNC	(-3)
#define MT_FUNC		(-4)	// Multi-threaded RLL function

#define MAX_RLLS		 32
#define MAX_RLL_FUNCS	(8*1024)
#define MAX_LIB_NAME	  9	
#define MAX_VER_STR		 13

typedef struct tag_FUNCINFO
	{
	int NrArgs;
	char *FuncName;
	FARPROC FuncAddr;
	} FUNCINFO, *LPFUNCINFO;	

typedef struct tag_IBLIB
	{
	char name[MAX_LIB_NAME+1];
	char ver[MAX_VER_STR+1];
	} IBLIB, *LPIBLIB;

typedef struct tag_RLLINFO
	{
	HINSTANCE hDLL;
	FARPROC fpExit;
	int NrFuncs;
	IBLIB ibLib;
	} RLLINFO, *LPRLLINFO;

#ifndef RLLTI_DEFINED
#define RLLTI_DEFINED
typedef struct tag_RLLTASKINFO
	{
	int iState;
	int iTaskNr;
	char szVXName[32];
	} RLLTASKINFO;
#endif

//#endif	// #ifndef RLLSTRUC_H

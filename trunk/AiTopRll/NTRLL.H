//////////////////////////////////////////////////////////////////////////
// Copyright (C) 2001 Intel Corporation
// All rights reserved.
//
// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
// ANY KIND EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED
// TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
// PARTICULAR PURPOSE.
//////////////////////////////////////////////////////////////////////////

// ntrll.h:	VOS/Windows Runtime Link Library Header

#pragma once

#ifndef _WINDOWS_
#error "ntrll.h requires <windows.h> be included first"
#endif

#include "rllstruc.h"

//#ifdef __cplusplus
extern "C"
{
//#endif

//#ifdef	__cplusplus
#define t_func		extern "C" DLLEXPORT LPCSTR 
//#else
//#define t_func		DLLEXPORT LPCSTR 
//#endif
 
extern FARPROC fpVOSfunc_[];

typedef unsigned (*UNSIGNED_UNSIGNED)(unsigned uType);
typedef unsigned (*UNSIGNED_VOID)(void);
typedef int	 (*INT_UNSIGNED)(unsigned chan);
typedef int	 (*INT_VOID)(void);
typedef int  (*INT_UNSIGNED_LPSTR)(unsigned uPID, LPSTR pszRetCode);
typedef void (*VOID_LPCSTR_)(LPCSTR,...);
typedef void (*VOID_FARPROC)(void (*fpHandler)());
typedef void (*VOID_TASKINFOFARPROC)(void (*fpHandler)(RLLTASKINFO *pTaskInfo));
typedef int  (*INT_INT_INT_LPSTR)(int iTaskIndex, int iVarIndex, LPSTR pszValue);
typedef int  (*INT_INT_INT_LPSTR_INT)(int iTaskIndex, int iVarIndex, LPSTR pszValue, int Bytes);

#define cksent		(*(UNSIGNED_UNSIGNED) fpVOSfunc_[0])
#define getpid		(*(UNSIGNED_VOID) fpVOSfunc_[1])
#define suspend		(*(INT_VOID) fpVOSfunc_[2])
#define suspterm	(*(INT_UNSIGNED) fpVOSfunc_[3])
#define wakeup		(*(INT_UNSIGNED_LPSTR) fpVOSfunc_[4])
#define hangup		(*(INT_UNSIGNED) fpVOSfunc_[5])
#define voslog		(*(VOID_LPCSTR_) fpVOSfunc_[6])
#define vid_write	(*(VOID_LPCSTR_) fpVOSfunc_[7])
#define deventf		(*(VOID_FARPROC) fpVOSfunc_[8])
#define ueventf		(*(VOID_FARPROC) fpVOSfunc_[9])
#define hangup_t	(*(INT_UNSIGNED) fpVOSfunc_[10])
#define dtasknotify	(*(VOID_TASKINFOFARPROC) fpVOSfunc_[11])
#define settaskvar	(*(INT_INT_INT_LPSTR) fpVOSfunc_[12])
#define gettaskvar	(*(INT_INT_INT_LPSTR_INT) fpVOSfunc_[13])

//#ifdef __cplusplus
}
//#endif

//#endif	// #ifndef NTRLL_H

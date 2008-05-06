// AITopDB.h : main header file for the AITOPDB DLL
//

#if !defined(AFX_AITOPDB_H__CE61A4E7_A7CF_4247_B30C_84FEFEC67524__INCLUDED_)
#define AFX_AITOPDB_H__CE61A4E7_A7CF_4247_B30C_84FEFEC67524__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CAITopDBApp
// See AITopDB.cpp for the implementation of this class
//

class CAITopDBApp : public CWinApp
{
public:
	CAITopDBApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CAITopDBApp)
	//}}AFX_VIRTUAL

	//{{AFX_MSG(CAITopDBApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_AITOPDB_H__CE61A4E7_A7CF_4247_B30C_84FEFEC67524__INCLUDED_)

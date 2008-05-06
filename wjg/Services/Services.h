// Services.h : main header file for the SERVICES DLL
//

#if !defined(AFX_SERVICES_H__A988D780_712B_4796_80BA_A8EA915018F8__INCLUDED_)
#define AFX_SERVICES_H__A988D780_712B_4796_80BA_A8EA915018F8__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CServicesApp
// See Services.cpp for the implementation of this class
//

class CServicesApp : public CWinApp
{
public:
	CServicesApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CServicesApp)
	//}}AFX_VIRTUAL

	//{{AFX_MSG(CServicesApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_SERVICES_H__A988D780_712B_4796_80BA_A8EA915018F8__INCLUDED_)

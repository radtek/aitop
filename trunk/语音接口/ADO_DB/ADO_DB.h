// ADO_DB.h : main header file for the ADO_DB DLL
//

#if !defined(AFX_ADO_DB_H__360D7ED4_EF8A_42AA_BB0A_63E659B8087E__INCLUDED_)
#define AFX_ADO_DB_H__360D7ED4_EF8A_42AA_BB0A_63E659B8087E__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CADO_DBApp
// See ADO_DB.cpp for the implementation of this class
//

class CADO_DBApp : public CWinApp
{
public:
	CADO_DBApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CADO_DBApp)
	//}}AFX_VIRTUAL

	//{{AFX_MSG(CADO_DBApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_ADO_DB_H__360D7ED4_EF8A_42AA_BB0A_63E659B8087E__INCLUDED_)

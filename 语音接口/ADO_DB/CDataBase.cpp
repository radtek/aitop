
// CDataBase.cpp
//
//////////////////////////////////////////////////////////////////////////
#include "StdAfx.h"
#include "CDatabase.h"
#include "CTable.h"

_variant_t vtMissing1(DISP_E_PARAMNOTFOUND, VT_ERROR);

static void ErrorHandler(_com_error &e, char* ErrStr)			
{
	sprintf(ErrStr,"Error:\n");
	sprintf(ErrStr,"%sCode = %08lx\n",ErrStr ,e.Error());
	sprintf(ErrStr,"%sCode meaning = %s\n", ErrStr, (char*) e.ErrorMessage());
	sprintf(ErrStr,"%sSource = %s\n", ErrStr, (char*) e.Source());
	sprintf(ErrStr,"%sDescription = %s",ErrStr, (char*) e.Description());
}

/*
 * DataBase member_function definition: 10 methods totally
 */

DataBase::DataBase()
{
	m_Conn = NULL;
	m_Tbl  = new CTable;
	sprintf(m_ErrStr, "Null Pointer");
	m_bInUse		= FALSE;
	m_nLastEnd		= 0;
	m_nLastBegin	= 0;
	m_nUseCount		= 0;
	m_nTotalUseTime = 0;
}

const char* DataBase::GetErrorStr()
{
	return m_ErrStr;
}

BOOL DataBase::Open(char* UserName, char* Pwd,char* CnnStr)
{
	try
	{
		m_Conn.CreateInstance( __uuidof(Connection) );
		m_Conn->Open(CnnStr, UserName, Pwd, NULL);
	}
	CATCHERROR(m_Conn, FALSE);

	sprintf(m_ErrStr, "Success");
	return TRUE;
}

BOOL DataBase::OpenTbl(int Mode, char* CmdStr, CTable& Tbl)
{
	if (m_Conn == NULL)
	{
		Tbl.m_Rec = NULL;
		sprintf(m_ErrStr, "Invalid Connection");
		return FALSE;
	}

	_RecordsetPtr t_Rec = NULL;

	try
	{
		t_Rec.CreateInstance( __uuidof(Recordset) );
		t_Rec->Open(CmdStr, _variant_t((IDispatch*)m_Conn), adOpenStatic,
					adLockOptimistic, Mode);
	}
	CATCHERROR(Tbl.m_Rec, FALSE);

//	Tbl.Attach(t_Rec);
	sprintf(m_ErrStr, "Success");
	return TRUE;
}

BOOL DataBase::Execute(char* CmdStr, long * lRecordAffected, long Option)
{
	VARIANT var;
	var.vt = VT_I4;
	try
	{
		m_Conn->Execute(CmdStr, &var, Option);
		*lRecordAffected = var.iVal;
	}
	catch(_com_error &e)
	{
		ErrorHandler(e, m_ErrStr);
		MessageBox(NULL, m_ErrStr, "´íÎó", MB_OK);
		return FALSE;
	}

	sprintf(m_ErrStr, "Success");
	return TRUE;
}

TBObject* DataBase::Execute(char* CmdStr)
{
//	int len = strlen(CmdStr);
	try
	{
		//m_Tbl->Detach().CreateInstance( __uuidof(Recordset) );
		//m_Tbl->Detach()->Open(CmdStr, _variant_t((IDispatch*)m_Conn), adOpenStatic,
		//			adLockOptimistic, -1);
		m_Rec.CreateInstance( __uuidof(Recordset) );
		m_Rec->PutRefActiveConnection(m_Conn);
		m_Rec->Open(CmdStr, vtMissing, adOpenKeyset,
					adLockBatchOptimistic, -1);
	}
	catch(_com_error &e)
	{
		ErrorHandler(e, m_ErrStr);
		m_Tbl->m_Rec = NULL;
//		MessageBox(NULL, "Êý¾Ý¿âÖ´ÐÐ´íÎó", "´íÎó", MB_OK);
		MessageBox(NULL, m_ErrStr, "´íÎó", MB_OK);
		return NULL;
	}

	sprintf(m_ErrStr, "Success");
	m_Tbl->Close();
	m_Tbl->m_Rec = m_Rec;
	return (TBObject*)m_Tbl;
}

void DataBase::Close()
{
	try
	{
		m_Conn = NULL;
	}
	catch(_com_error &e)
	{
		sprintf(m_ErrStr, "%s", e.ErrorMessage());
		MessageBox(NULL, m_ErrStr, "´íÎó", MB_OK);
	}
}

BOOL DataBase::BeginTransaction()
{
	if (m_Conn == NULL)
	{
		sprintf(m_ErrStr, "Invalid Connection");
		return FALSE;
	}
	try
	{
		m_Conn->BeginTrans();
	}
	catch(_com_error &e)
	{
		sprintf(m_ErrStr, "%s", e.ErrorMessage());
		MessageBox(NULL, m_ErrStr, "´íÎó", MB_OK);
		return FALSE;				//should check the m_ErrStr
	}

//	sprintf(m_ErrStr, "Success");
	return TRUE;
}

BOOL DataBase::CommitTransaction()
{
	if (m_Conn == NULL)
	{
		sprintf(m_ErrStr, "Invalid Connection");
		return FALSE;
	}
	try
	{
		m_Conn->CommitTrans();
	}
	catch(_com_error &e)
	{
		sprintf(m_ErrStr, "%s", e.ErrorMessage());
		MessageBox(NULL, m_ErrStr, "´íÎó", MB_OK);
		return FALSE;				//should check the m_ErrStr
	}
	
//	sprintf(m_ErrStr, "Success");
	return TRUE;
}

BOOL DataBase::RollBack()
{
	if (m_Conn == NULL)
	{
		sprintf(m_ErrStr, "Invalid Connection");
		return FALSE;
	}
	try
	{
		m_Conn->RollbackTrans();
	}
	catch(_com_error &e)
	{
		sprintf(m_ErrStr, "%s", e.ErrorMessage());
		MessageBox(NULL, m_ErrStr, "´íÎó", MB_OK);
		return FALSE;				//should check the m_ErrStr
	}
	
//	sprintf(m_ErrStr, "Success");
	return TRUE;
}

long DataBase::State()
{
	return m_Conn->State;
}

BOOL DataBase::operator !()
{
	return m_Conn ==  NULL;
}

DataBase::~DataBase()
{
	if(m_Tbl)
	{
		m_Tbl->Close();
		delete m_Tbl;
	}
}

/*void DataBase::operator =(const DataBase& src)
{
	
}*/

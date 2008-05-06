
#include "StdAfx.h"
#include "ConnObject.h"
#include "ConnPool.h"

CConnObject::CConnObject()
{
	pPool = new CConnPool;
//	m_Conn = NULL;
	CoInitialize(NULL);
}

CConnObject::~CConnObject()
{
	if (pPool)
		delete pPool;
	CoUninitialize();
}

BOOL CConnObject::OnInitial(const char* conStr)
{
	if(!pPool->Init(conStr))	//连接池并没有完全初始化结束
	{
		delete pPool;
		pPool = NULL;
		return FALSE;
	}
	return TRUE;
}

BOOL CConnObject::Close(DBObject *db)
{
	if (db == NULL)
		return TRUE;
	pPool->Close((DataBase*)db);
	//m_Conn = NULL;
	return TRUE;
}

DBObject* CConnObject::GetAnConnect()
{
	return pPool->GetConnect();
}

/*
 * 隐藏实现
 */
/*BOOL CConnObject::BeginTransaction()
{
	return m_Conn->BeginTransaction();
}

BOOL CConnObject::RollBack()
{
	return m_Conn->RollBack();
}

BOOL CConnObject::CommitTransaction()
{
	return m_Conn->CommitTransaction();
}

BOOL CConnObject::Execute(char* CmdStr, CTable& Tbl)
{
	return m_Conn->Execute(CmdStr, Tbl);
}

BOOL CConnObject::Execute(char* CmdStr, long * lRecordAffected, long Option)
{
	return m_Conn->Execute(CmdStr, lRecordAffected, Option);
}

void CConnObject::GetErroInfo(char *err)
{
	m_Conn->GetErrorStr(err);
}*/

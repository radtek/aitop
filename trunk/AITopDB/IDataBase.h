// IDataBase.h: interface for the IDataBase class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_IDATABASE_H__5A62338E_621A_4B26_9AB2_A6CC7466E6B5__INCLUDED_)
#define AFX_IDATABASE_H__5A62338E_621A_4B26_9AB2_A6CC7466E6B5__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000


#ifndef _AFX_NO_DB_SUPPORT
#include <afxdb.h>			// MFC ODBC ���ݿ���
#endif // _AFX_NO_DB_SUPPORT

#ifndef _AFX_NO_DAO_SUPPORT
#include <afxdao.h>			// MFC DAO ���ݿ���
#endif // _AFX_NO_DAO_SUPPORT

class IDataBase  
{
public:
	IDataBase();
	virtual ~IDataBase();
	// �Լ�¼����ʽִ�д洢���̻�SQL��䣬�������ŵ�rets��ָ��Ļ��������������SQL_SUCCESS��SQL_ERROR
	int ExecSqlA(LPCSTR sql,char *rets);
	// ִ��һ��SQL���Ҳ���Ҫ���ؼ�¼
	int ExecSqlB(LPCSTR sql);
	int OpenDatabase(LPCSTR str=NULL);
private:
	// ����һ���������ݿ����
    char dsnstr[128];
	CDatabase m_db;
};

#endif // !defined(AFX_IDATABASE_H__5A62338E_621A_4B26_9AB2_A6CC7466E6B5__INCLUDED_)

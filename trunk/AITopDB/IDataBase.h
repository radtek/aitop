// IDataBase.h: interface for the IDataBase class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_IDATABASE_H__5A62338E_621A_4B26_9AB2_A6CC7466E6B5__INCLUDED_)
#define AFX_IDATABASE_H__5A62338E_621A_4B26_9AB2_A6CC7466E6B5__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000


#ifndef _AFX_NO_DB_SUPPORT
#include <afxdb.h>			// MFC ODBC 数据库类
#endif // _AFX_NO_DB_SUPPORT

#ifndef _AFX_NO_DAO_SUPPORT
#include <afxdao.h>			// MFC DAO 数据库类
#endif // _AFX_NO_DAO_SUPPORT

class IDataBase  
{
public:
	IDataBase();
	virtual ~IDataBase();
	// 以记录集方式执行存储过程或SQL语句，结果将存放到rets所指向的缓冲区里，函数返回SQL_SUCCESS或SQL_ERROR
	int ExecSqlA(LPCSTR sql,char *rets);
	// 执行一个SQL并且不需要返回记录
	int ExecSqlB(LPCSTR sql);
	int OpenDatabase(LPCSTR str=NULL);
private:
	// 创建一个共用数据库对象
    char dsnstr[128];
	CDatabase m_db;
};

#endif // !defined(AFX_IDATABASE_H__5A62338E_621A_4B26_9AB2_A6CC7466E6B5__INCLUDED_)

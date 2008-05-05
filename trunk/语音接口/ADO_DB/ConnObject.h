#ifndef _HEAD_CONOBJECT_H_
#define  _HEAD_CONOBJECT_H_
#include "CDatabase.h"
// ConnObject.h: interface for the CConnObject class.
//
//////////////////////////////////////////////////////////////////////
class CConnPool;

class _declspec(dllexport) CConnObject
{
public:
	CConnObject();
	~CConnObject();					
	BOOL OnInitial(const char* conStr);							//参数为连接数据库串
	BOOL Close(DBObject *db);									//释放连接对象
	DBObject* GetAnConnect();

	/*
	 * 以下操作为公开的支持数据库操作
	 */
public:
	/*
	 * transaction operation
	 */
/*	BOOL RollBack();					// rollback operation
	BOOL BeginTransaction();			// transaction begin
	BOOL CommitTransaction();			// transaction commit(end)

	/*
	 * executable operation
	 */
/*	BOOL Execute(char* CmdStr, long * lRecordAffected, long Option);
	BOOL Execute(char* CmdStr, CTable& Tbl);

	void GetErroInfo(char *err);*/

private:
	CConnPool* pPool;
//	DataBase*  m_Conn;
};

#endif _HEAD_CONOBJECT_H_


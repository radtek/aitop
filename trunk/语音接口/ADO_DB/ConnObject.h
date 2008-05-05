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
	BOOL OnInitial(const char* conStr);							//����Ϊ�������ݿ⴮
	BOOL Close(DBObject *db);									//�ͷ����Ӷ���
	DBObject* GetAnConnect();

	/*
	 * ���²���Ϊ������֧�����ݿ����
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



#ifndef _HEAD_DATABASE_H
	#define _HEAD_DATABASE_H
	
#define CATCHERROR(ptr, a) catch(_com_error &e)\
	{\
		ErrorHandler(e, m_ErrStr);\
		ptr = NULL;\
		return a;\
	}

#define CATCHERRGET catch(_com_error &e)\
	{\
		ErrorHandler(e, m_ErrStr);\
		sprintf(m_ErrStr, "%s\n", m_ErrStr);\
		return 0;\
	}

#define INTA int

// import the ado15.dll
//
/////////////////////////////////////////////////////////////////////////
#pragma warning(disable:4146)
#import "C:\Program Files\Common Files\System\ADO\msado15.dll" named_guids rename("EOF","adoEOF"), rename("BOF","adoBOF")
#pragma warning(default:4146)
using namespace ADODB;

#include "dbobject.h"
class CTable;

class DataBase : Implement DBObject
{
public:
	/*
	 * transaction operation
	 */
	virtual BOOL RollBack();					// rollback operation
	virtual BOOL BeginTransaction();			// transaction begin
	virtual BOOL CommitTransaction();			// transaction commit(end)

	/*
	 * executable operation
	 */
	virtual BOOL Execute(char* CmdStr, long * lRecordAffected, long Option);
	virtual TBObject* Execute(char* CmdStr);
	BOOL Open(char* UserName, char* Pwd, char* CnnStr);
	BOOL OpenTbl(int Mode, char* CmdStr, CTable& Tbl);

	/*
	 * common operation
	 */
	DataBase();
	~DataBase();
	void Close();

	long State();
	BOOL operator !();
//	void operator =(const DataBase& src);

	/*
	 * error handle
	 */
	virtual const char* GetErrorStr();
public:
	//�õ��ܵ�ʹ��ʱ��
	inline int  GetTotalUseTime() const
	{
		return m_nTotalUseTime;
	}
	
	BOOL     m_bInUse;
	int      m_nLastEnd;			//���һ��ʹ�ý���ʱ��
	int      m_nLastBegin;			//���һ�ο�ʼʱ��
	int      m_nUseCount;			//ʹ�ô���
	int      m_nTotalUseTime;

private:
	/*
	 * data_member
	 */
	_ConnectionPtr	m_Conn;
	char			m_ErrStr[200];
	CTable*			m_Tbl;
	_RecordsetPtr	m_Rec;
};
#endif _HEAD_DATABASE_H

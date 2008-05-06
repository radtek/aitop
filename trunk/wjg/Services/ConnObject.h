//////////////////////////////////////////////////////////////////////////
// ConnObject.h: interface for the CConnObject class.
//

#ifndef _HEAD_CONOBJECT_H_
#define  _HEAD_CONOBJECT_H_

class CConnPool;
class DataBase;

#pragma warning(disable:4146)
#import "C:\Program Files\Common Files\System\ADO\msado15.dll" named_guids rename("EOF","adoEOF"), rename("BOF","adoBOF")
#pragma warning(default:4146)
using namespace ADODB;

#define Interface	class
#define Implement	public

/*#ifdef __cplusplus
extern "C"{
#endif*/
/**
 * ������ӿڣ���������sqlִ�к�Ľ��
 */
Interface TBObject
{
public:
	/*
	 * common operation
	 */
	virtual int		ISEOF() = 0;
	virtual HRESULT MoveNext() = 0;
	virtual HRESULT MovePrevious() = 0;
	virtual HRESULT MoveFirst() = 0;
	virtual HRESULT MoveLast() = 0;
	virtual BOOL	SetPageSize(int size) = 0;
	virtual BOOL	Move(int index) = 0;					//ע�⣺��index���ڵ�ǰλ�ã�0Ϊ��ǰλ�ã�1Ϊ��һλ�ã��Դ�����
	virtual int		GetRecordCount() = 0;					//���ظô�query��ļ�¼��������������ʹ��

	/*
	 * set field value functions haven't finished
	 */
	/*
	 int AddNew();
	 int Update();
	 int Set(char* FieldName, char* FieldValue);
	 int Set(char* FieldName,int FieldValue);
	 int Set(char* FieldName,float FieldValue);
	 int Set(char* FieldName,double FieldValue);
	 int Set(char* FieldName,long FieldValue);
	*/

	/*
	 * overview field value functions
	 */
	virtual BOOL Get(char* FieldName, char* FieldValue) = 0;
	virtual BOOL Get(char* FieldName,int& FieldValue) = 0;
	virtual BOOL Get(char* FieldName,float& FieldValue) = 0;
	virtual BOOL Get(char* FieldName,double& FieldValue) = 0;
	virtual BOOL Get(char* FieldName,double& FieldValue,int Scale) = 0;
	virtual BOOL Get(char* FieldName,long& FieldValue) = 0;

	/*
	 * overview field value functions by int addr
	 */
/*	virtual BOOL Get(long FieldNum, char* FieldValue) = 0;
	virtual BOOL Get(long FieldNum, int& FieldValue) = 0;
	virtual BOOL Get(long FieldNum, float& FieldValue) = 0;
	virtual BOOL Get(long FieldNum, double& FieldValue) = 0;
	virtual BOOL Get(long FieldNum, double& FieldValue,int Scale) = 0;
	virtual BOOL Get(long FieldNum, long& FieldValue) = 0;

	/*
	 * error handler
	 */
	virtual const char* GetErrorStr() = 0;

	//virtual void Close();
};

/**
 * ���Ӻõ����ݿ�ʵ���ӿ�,���û�ʹ��
 */
Interface DBObject
{
public:
	/*
	 * transaction operation
	 */
	virtual BOOL RollBack() = 0;					// rollback operation
	virtual BOOL BeginTransaction() = 0;			// transaction begin
	virtual BOOL CommitTransaction() = 0;			// transaction commit(end)
	
	/*
	 * executable operation
	 */
	virtual BOOL		Execute(char* CmdStr, long * lRecordAffected, long Option) = 0;
	virtual TBObject*	Execute(char* CmdStr) = 0;

	virtual const char* GetErrorStr() = 0;
	
	virtual ~DBObject(){};
};

class CConnObject
{
public:
	CConnObject();
	~CConnObject();					
	BOOL			OnInitial(const char* conStr);	//����Ϊ�������ݿ�,��ʵ�����Զ��������ӳ�
	BOOL			Close(DBObject *db);			//�ͷ�һ�������ӵ����ݿ�ʵ��
	DBObject*		GetAnConnect();					//��ȡһ�������ӵ����ݿ�ʵ��

private:
	CConnPool* pPool;
};

/*#ifdef __cplusplus
}
#endif*/
#endif _HEAD_CONOBJECT_H_


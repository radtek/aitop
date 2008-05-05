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
 * 结果集接口，用来操纵sql执行后的结果
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
	virtual BOOL	Move(int index) = 0;					//注意：该index基于当前位置，0为当前位置，1为下一位置，以此类推
	virtual int		GetRecordCount() = 0;					//返回该次query后的记录个数，不建议多次使用

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
 * 连接好的数据库实例接口,供用户使用
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
	BOOL			OnInitial(const char* conStr);	//参数为连接数据库,该实例会自动启动连接池
	BOOL			Close(DBObject *db);			//释放一个已连接的数据库实例
	DBObject*		GetAnConnect();					//获取一个已连接的数据库实例

private:
	CConnPool* pPool;
};

/*#ifdef __cplusplus
}
#endif*/
#endif _HEAD_CONOBJECT_H_



#ifndef _HEAD_DBOBJECT_H_
	#define _HEAD_DBOBJECT_H_


#define Interface	class
#define Implement	public

/**
 * 结果集接口，用来操纵sql执行后的结果
 */
Interface _declspec(dllexport) TBObject
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
	virtual BOOL	Move(int index) = 0;
	virtual int		GetRecordCount() = 0;

	/*
	 * set field value functions
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
	virtual BOOL Get(char* FieldName, char*		FieldValue) = 0;
	virtual BOOL Get(char* FieldName, int&		FieldValue) = 0;
	virtual BOOL Get(char* FieldName, float&	FieldValue) = 0;
	virtual BOOL Get(char* FieldName, double&	FieldValue) = 0;
	virtual BOOL Get(char* FieldName, double&	FieldValue, int Scale) = 0;
	virtual BOOL Get(char* FieldName, long&		FieldValue) = 0;

	/*
	 * overview field value functions by int addr
	 */
/*	virtual BOOL Get(long FieldNum, char*		FieldValue) = 0;
	virtual BOOL Get(long FieldNum, int&		FieldValue) = 0;
	virtual BOOL Get(long FieldNum, float&		FieldValue) = 0;
	virtual BOOL Get(long FieldNum, double&		FieldValue) = 0;
	virtual BOOL Get(long FieldNum, double&		FieldValue, int Scale) = 0;
	virtual BOOL Get(long FieldNum, long&		FieldValue) = 0;*/

	//virtual void Close() = 0;

	/*
	 * error handler
	 */
	virtual const char* GetErrorStr() = 0;
};

/**
 * 连接好的数据库实例接口,供用户使用
 */
Interface _declspec(dllexport) DBObject
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
	virtual BOOL Execute(char* CmdStr, long * lRecordAffected, long Option) = 0;
	virtual TBObject* Execute(char* CmdStr) = 0;

	virtual const char* GetErrorStr() = 0;

	virtual ~DBObject(){};
};
#endif
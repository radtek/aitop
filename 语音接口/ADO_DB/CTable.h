
#ifndef _HEAD_CTABLE_H_
#define _HEAD_CTABLE_H_

class CTable : Implement TBObject
{
public:
	/*
	 * common operation
	 */
	CTable();
	virtual int		ISEOF();
	virtual HRESULT MoveNext();
	virtual HRESULT MovePrevious();
	virtual HRESULT MoveFirst();
	virtual HRESULT MoveLast();
	virtual BOOL	SetPageSize(int size);
	virtual BOOL	Move(int index);
	virtual int		GetRecordCount();

	void	Close();

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
	 * overview field value functions by str
	 */
	virtual BOOL Get(char* FieldName, char* FieldValue);
	virtual BOOL Get(char* FieldName,int& FieldValue);
	virtual BOOL Get(char* FieldName,float& FieldValue);
	virtual BOOL Get(char* FieldName,double& FieldValue);
	virtual BOOL Get(char* FieldName,double& FieldValue,int Scale);
	virtual BOOL Get(char* FieldName,long& FieldValue);

	/*
	 * overview field value functions by int addr
	 */
	/*virtual BOOL Get(long FieldNum, char* FieldValue);
	virtual BOOL Get(long FieldNum, int& FieldValue);
	virtual BOOL Get(long FieldNum, float& FieldValue);
	virtual BOOL Get(long FieldNum, double& FieldValue);
	virtual BOOL Get(long FieldNum, double& FieldValue,int Scale);
	virtual BOOL Get(long FieldNum, long& FieldValue);

	/*
	 * error handler
	 */
	virtual const char* GetErrorStr();

	_RecordsetPtr	m_Rec;

private:
	/*
	 * data_member
	 */
	char			m_ErrStr[200];
	int				m_PageSize;
};
#endif
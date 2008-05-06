#ifndef _HEAD_CONPOOL_H_
#define  _HEAD_CONPOOL_H_
#include <atlbase.h>
/*
 * ���ݿ����ӳأ�һ�����Ӷ�Ӧһ�����ݿ�
 */
class CConnObject;
class CConnPool  
{
public:
	static  void OnTimer(CConnPool* caller);
	static 	void __stdcall TimerProc(HWND hWnd, UINT msg, UINT id, DWORD dwTime);
	
	//�õ�һ������
	DataBase* GetConnect();
	//�ͷ�һ�����ӻ����ӳ�
	void Close(DataBase* pConn);
	//�������ӳ�
	void Destroy();
	//�������ӳ�  strConn: ���Ӵ�
	BOOL Init(const char* strConn);
	
	CConnPool();
	virtual ~CConnPool();
	
	
public:
	
	UINT        m_nTimer;			//��ʱ��
	
	CSimpleArray<DataBase*> m_listConn;   //��������
	
	UINT        m_nTimeOut;			//����������ʱ��
	UINT        m_ConnMax;			//������������
	UINT        m_ConnMin;			//������������
	UINT        m_nMaxCount;		//�������ʹ�ô���
	UINT        m_nMaxUseTime;		//���ʹ��ʱ��
	char*		m_strConn;			//���Ӵ�
	
	HANDLE      m_cs;				//��֤�ı����ӳ�״̬ʱ���벻�ն�
	
protected:
	DataBase* CreateNewConn();	//����һ���µ�����

private:
	CRITICAL_SECTION section;
};
#endif  _HEAD_CONPOOL_H_

#ifndef _HEAD_CONPOOL_H_
#define  _HEAD_CONPOOL_H_
#include <atlbase.h>
/*
 * 数据库连接池，一个连接对应一个数据库
 */
class CConnObject;
class CConnPool  
{
public:
	static  void OnTimer(CConnPool* caller);
	static 	void __stdcall TimerProc(HWND hWnd, UINT msg, UINT id, DWORD dwTime);
	
	//得到一个连接
	DataBase* GetConnect();
	//释放一个连接回连接池
	void Close(DataBase* pConn);
	//销毁连接池
	void Destroy();
	//创建连接池  strConn: 连接串
	BOOL Init(const char* strConn);
	
	CConnPool();
	virtual ~CConnPool();
	
	
public:
	
	UINT        m_nTimer;			//定时器
	
	CSimpleArray<DataBase*> m_listConn;   //连接链表
	
	UINT        m_nTimeOut;			//连接最大空闲时间
	UINT        m_ConnMax;			//连接数量上限
	UINT        m_ConnMin;			//连接数量下限
	UINT        m_nMaxCount;		//连接最大使用次数
	UINT        m_nMaxUseTime;		//最大使用时间
	char*		m_strConn;			//连接串
	
	HANDLE      m_cs;				//保证改变连接池状态时代码不终端
	
protected:
	DataBase* CreateNewConn();	//创建一个新的连接

private:
	CRITICAL_SECTION section;
};
#endif  _HEAD_CONPOOL_H_

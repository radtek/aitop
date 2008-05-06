#include "StdAfx.h"
//#include <stdlib.h>
#include "ConnObject.h"
#include "ConnPool.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
//#define new DEBUG_NEW
#endif

CConnPool* caller = NULL;

CConnPool::CConnPool()
{
	 m_ConnMin =			10;			//CONN_MIN;
	 m_nTimeOut =			100000;		//CONN_TIMEOUT;
	 m_nMaxUseTime =		100000;		//CONN_MAX_USETIME;
	 m_nMaxCount  =			10;
	 m_strConn = NULL;
	 InitializeCriticalSection(&section);
}

CConnPool::~CConnPool()
{
	Destroy();
	if (m_strConn != NULL)
	{
		delete m_strConn;
	}
	DeleteCriticalSection(&section);
}

BOOL CConnPool::Init(const char* strConn)
{
	m_ConnMax = 15;//theApp.m_sysSetting.m_nConnCount;
	int len = strlen(strConn);
	m_strConn = new char [len + 1];
	memcpy(m_strConn, strConn, len + 1);
	for (UINT i = 0;i < m_ConnMax; i++)
	{
	  DataBase* pObj = CreateNewConn();
	  if (!pObj)
	   return FALSE;
	  m_listConn.Add(pObj);
	}

 //启动连接池维护计时器
	caller = this;
	m_nTimer = SetTimer(0, 0, 1000, (TIMERPROC)TimerProc); //3 param CONNPOOL_TIMER
	return TRUE;
}

void CConnPool::Destroy()
{
	for (int i = 0;i < m_listConn.GetSize(); i++)
	{
		m_listConn[i]->m_bInUse = FALSE;
		
		m_listConn[i]->Close();
		// m_listConn[i]->conn->Release();
		
		delete   m_listConn[i];
	}
	
	m_listConn.RemoveAll();
	
	KillTimer(NULL, m_nTimer);
}
/*
 * 释放连接时需要保护数据一致性,所以使用 临界对象
 */
void CConnPool::Close(DataBase *pConn)
{

	EnterCriticalSection(&section);
	for (int i = 0;i < m_listConn.GetSize(); i++)
	{
		if (m_listConn[i] == pConn)
		{
		   m_listConn[i]->m_bInUse = FALSE;
		   m_listConn[i]->m_nUseCount++;
		   m_listConn[i]->m_nLastEnd = ::GetTickCount();

		   //判断使用次数是否过多，使用时间是否过多
		   //如果过度使用该连接，则重新创建
		   if (m_listConn[i]->m_nUseCount > (int)m_nMaxCount ||
			   m_listConn[i]->GetTotalUseTime() > 100000)//CONN_MAX_USETIME)
		   {
//				OUTPUT_MSG("有数据库连接对象使用过多，需要重新连接\r\n");
    
			  m_listConn[i]->Close();
			  if (!m_listConn[i]->Open("", "", m_strConn))//.GetBuffer(0)))
			  {
//                  AfxMessageBox("重新数据库连接对象出错！， 系统退出！");
					ExitProcess(0);
			  }
				m_listConn[i]->m_nLastBegin = 0;
				m_listConn[i]->m_nLastEnd = 0;
				m_listConn[i]->m_nTotalUseTime = 0;
				m_listConn[i]->m_nUseCount = 0;

			}
		   LeaveCriticalSection(&section);
		   return;
		}
		LeaveCriticalSection(&section);
}


#ifdef _DEBUG
// AfxMessageBox("The connect object is no mine!");
#endif

}
/*
 * 得到连接时需要保护数据一致性,所以使用 临界对象
 */
DataBase* CConnPool::GetConnect()
{
	EnterCriticalSection(&section);
	DataBase* pObj = NULL;
	for (int i = 0;i < m_listConn.GetSize(); i++)
	{
		if (!m_listConn[i]->m_bInUse)
		{
			m_listConn[i]->m_bInUse = TRUE;
			pObj = m_listConn[i];
			pObj->m_nLastBegin = ::GetTickCount();
			LeaveCriticalSection(&section);
			return pObj;
		}
	}
	if ((pObj == NULL) && (m_listConn.GetSize() < (int)m_ConnMax)) //connect object is no enough!
	{
		pObj = CreateNewConn();
		pObj->m_bInUse = TRUE;
		m_listConn.Add(pObj);
		LeaveCriticalSection(&section);
		return pObj;
	}
	//连接池已经满载!
	LeaveCriticalSection(&section);
	return NULL;
}

DataBase* CConnPool::CreateNewConn()
{
	DataBase* pConn = new DataBase();
	if (!pConn->Open("","",m_strConn))
		return NULL;
	
	return pConn;
}

void CConnPool::TimerProc(HWND hWnd, UINT msg, UINT id, DWORD dwTime)
{
// CHTRDServerApp * pApp = (CHTRDServerApp *)AfxGetApp();
// ASSERT(pPool);

// pPool->
	OnTimer(caller);
 
}

/*
 * 调度连接池
 */
void CConnPool::OnTimer(CConnPool* caller)
{  
 
	 DWORD dwTime = ::GetTickCount();
	 for (int i = 0; i < caller->m_listConn.GetSize(); i++)
	 {
		if (caller->m_listConn[i]->State() == adStateClosed)
		{
			//delete from pool
			delete caller->m_listConn[i];
			caller->m_listConn.RemoveAt(i);
	//		TRACE("One conn closed!, delete from pool!\n");
		}
		else if (!caller->m_listConn[i]->m_bInUse)
		{
			if (dwTime - caller->m_listConn[i]->m_nLastEnd >= caller->m_nTimeOut)
			{
				caller->m_listConn[i]->Close();
				delete caller->m_listConn[i];
				caller->m_listConn.RemoveAt(i);
	//TACE("One conn time out!\n");
			}
			else if (caller->m_listConn[i]->m_nUseCount >= (int)caller->m_nMaxCount)
			{
				caller->m_listConn[i]->Close();
				delete caller->m_listConn[i];
				caller->m_listConn.RemoveAt(i);
	//			TRACE("One conn use to much!\n");
			}
		}
		else if (caller->m_listConn[i]->GetTotalUseTime() >= (int)caller->m_nMaxUseTime)
		{
			caller->m_listConn[i]->Close();
			caller->m_listConn[i];
			caller->m_listConn.RemoveAt(i);

	//   TRACE("One conn use too long\n");
		}
	 }

	 //检查连接数,小于下限则添加到下限
	 for (i = caller->m_listConn.GetSize(); i < (int)caller->m_ConnMin;i++)
	 {
		DataBase* pObj = caller->CreateNewConn();
		caller->m_listConn.Add(pObj);
	 }
}


// Log.h: interface for the CLog class.
//
//  ��¼��־�Ĺ�����
//  ����		������ 
//  ����		2004-4-22
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_LOG_H__DBCE8A5E_7BD0_4A9B_AEE9_B5DFEC4FFC55__INCLUDED_)
#define AFX_LOG_H__DBCE8A5E_7BD0_4A9B_AEE9_B5DFEC4FFC55__INCLUDED_
#include "io.h"
#include <time.h>
#include <stdio.h>
#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
#define MAX_LOGBUF		16384
class CLog  
{
public:	
	void SetLogParam(int lines=-1,bool enabletime=false);
	char * GetAppPath();
	char * GetNowTime();	//�õ���ǰʱ��
	void SetFile(char *filename=NULL);			//���õ�ǰ���ļ���
	void string(LPCTSTR log);//����VC�õ�
	void print(const char *format,...);
	CLog(char *filename=NULL);
	virtual ~CLog();
protected:
	char m_AppPath[MAX_PATH+1];
	char m_LogPath[MAX_PATH];
	bool m_bEnableTime;
	int  m_nMaxLines;
	FILE *m_fp;				//ʵ�ʵ��ļ����
	HANDLE m_hWait;			//���ڶ��̵߳ı���
	int m_count;			//���μ�¼������
	char m_logfile[256];	//��ǰ�ļ���		
	char m_buf[MAX_LOGBUF];	//��¼������	
    char m_strTime[60];		//���ڵ�ǰʱ�����ʱ����	
public:
	bool FileExist(char * filename);//�жϵ�ǰ�ļ��Ƿ����
	char * GetLogPath(void);
	int SetLogPath(char * path);
};


#endif // !defined(AFX_LOG_H__DBCE8A5E_7BD0_4A9B_AEE9_B5DFEC4FFC55__INCLUDED_)

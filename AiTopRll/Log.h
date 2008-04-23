// Log.h: interface for the CLog class.
//
//  记录日志的功能类
//  作者		李昆仑 
//  日期		2004-4-22
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
	char * GetNowTime();	//得到当前时间
	void SetFile(char *filename=NULL);			//设置当前的文件名
	void string(LPCTSTR log);//兼容VC用的
	void print(const char *format,...);
	CLog(char *filename=NULL);
	virtual ~CLog();
protected:
	char m_AppPath[MAX_PATH+1];
	char m_LogPath[MAX_PATH];
	bool m_bEnableTime;
	int  m_nMaxLines;
	FILE *m_fp;				//实际的文件句柄
	HANDLE m_hWait;			//用于多线程的变量
	int m_count;			//本次记录的行数
	char m_logfile[256];	//当前文件名		
	char m_buf[MAX_LOGBUF];	//记录缓冲区	
    char m_strTime[60];		//用于当前时间的临时变量	
public:
	bool FileExist(char * filename);//判断当前文件是否存在
	char * GetLogPath(void);
	int SetLogPath(char * path);
};


#endif // !defined(AFX_LOG_H__DBCE8A5E_7BD0_4A9B_AEE9_B5DFEC4FFC55__INCLUDED_)

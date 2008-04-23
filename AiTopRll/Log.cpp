// Log.cpp: implementation of the CLog class.
//
//  记录日志的功能类
//  作者		李昆仑 
//  日期		2004-4-22
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "Log.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////
//确定绝对路径为filename的文件或目录是否存在
//存在则返回TRUE
bool CLog::FileExist(char * filename)
{
	struct _finddata_t ff;
	long hd;
	hd=_findfirst(filename,&ff);
	if(hd==-1)
		return FALSE;
	else 
	{
		_findclose(hd);
		return TRUE;
	}
}
void CLog::SetFile(char *filename)
{
	time_t curtime;
	struct tm *newtime;
	time( &curtime );                   /* Get time as long integer. */
    newtime = localtime( &curtime ); /* Convert to local time. */  
	m_count=0;//设置文件行数	
	if (filename==NULL)
	{
		sprintf(m_logfile,"%s%04d%02d%02d-%02d.log",m_LogPath,
			newtime->tm_year+1900,newtime->tm_mon+1,newtime->tm_mday,
			newtime->tm_hour);
	}
	else
	{
		strcpy(m_logfile,filename);
	}
	if (m_bEnableTime) 
	{ //如果需要记录时间
		if (FileExist(m_logfile))
			m_fp=fopen(m_logfile,"a");	
		else
			m_fp=fopen(m_logfile,"w");	
		fprintf(m_fp,"\t\t程序启动日期 %04d年%02d月%02d日 %02d时%02d分%02d秒\n\n",
			newtime->tm_year+1900,newtime->tm_mon+1,newtime->tm_mday,
			newtime->tm_hour,newtime->tm_min,newtime->tm_sec);
		fclose(m_fp);
	} 	
	m_fp=NULL;
}

CLog::CLog(char *filename)
{
	m_hWait=CreateEvent(NULL,FALSE,TRUE,NULL);
	m_fp=NULL;	
	m_bEnableTime=true;
	m_nMaxLines=9999;
	if (filename==NULL) 
	{
		::GetModuleFileName(NULL,m_AppPath,MAX_PATH);
	} else {
		strcpy(m_AppPath,filename);		
	}
	/* Search backward. */
	char *pdest = strrchr( m_AppPath, '\\' );
	__int64 pos = pdest - m_AppPath + 1;
    if( pdest != NULL ) 
	{
		*(m_AppPath+pos)=0;		
	}
	else
		strcpy(m_AppPath,"c:\\temp\\");
	sprintf(m_LogPath,"%slog\\",m_AppPath);
	if (!FileExist(m_LogPath)) { //如果路径不存在则生成
		::CreateDirectory(m_LogPath,NULL);
	}
	SetFile(filename);
}

CLog::~CLog()
{
	if(m_fp!=NULL)
		fclose(m_fp);
	if (m_hWait!=NULL) 
		CloseHandle(m_hWait);
}

void CLog::print(const char *format, ...)
{
	if (strlen(m_logfile)<=0) return;
	WaitForSingleObject(m_hWait,50);	//INFINITE);
	memset(m_buf,0,MAX_LOGBUF);
	va_list argptr;
	va_start(argptr, format);
	vsprintf(m_buf, format, argptr);
	m_fp=fopen(m_logfile,"a");
	if (m_fp==NULL)
    {
        SetEvent(m_hWait);
        return;
    }
	if (m_bEnableTime)
		fprintf(m_fp,"%s %s\r\n",GetNowTime(),m_buf);	
	else
		fprintf(m_fp,"%s\r\n",m_buf);	
	m_count++;
    if (m_count>=m_nMaxLines) 
	{
        fprintf(m_fp,"程序行数太多，将重新建立新的LOG文件\r\n");	
    }
	if (m_fp!=NULL)
		fclose(m_fp);	
	//记录的行数加一，如果超过一定行数则重新起一个文件名
	if (m_count>=m_nMaxLines) 
	{		
		SetFile();					
	}
	SetEvent(m_hWait);
}

void CLog::string(LPCTSTR log)
{
	if (strlen(m_logfile)<=0) return;
	if (strlen(log)<=0) return;
	WaitForSingleObject(m_hWait,50);	//INFINITE);			
	m_fp=fopen(m_logfile,"a");
	if (m_fp==NULL)
    {
        SetEvent(m_hWait);
        return;
    }
	if (m_bEnableTime)
		fprintf(m_fp,"%s %s\r\n",GetNowTime(),log);	
	else
		fprintf(m_fp,"%s\r\n",log);	
	m_count++;
    if (m_count>=m_nMaxLines) 
	{
        fprintf(m_fp,"程序行数太多，将重新建立新的LOG文件\r\n");	
    }
	if (m_fp!=NULL)
		fclose(m_fp);		
	//记录的行数加一，如果超过一定行数则重新起一个文件名
	if (m_count>=m_nMaxLines) 
	{		
		SetFile();					
	}
	SetEvent(m_hWait);
}

char * CLog::GetNowTime()
{
	time_t curtime;
	struct tm *newtime;
	time( &curtime );                   /* Get time as long integer. */
    newtime = localtime( &curtime ); /* Convert to local time. */  
	sprintf(m_strTime,"%04d-%02d-%02d %02d:%02d:%02d",
		newtime->tm_year+1900,newtime->tm_mon+1,newtime->tm_mday,
		newtime->tm_hour,newtime->tm_min,newtime->tm_sec);
	return m_strTime;
}

char *CLog::GetAppPath()
{
	return m_AppPath;
}
//设置一个LOG文件默认的最多行数
void CLog::SetLogParam(int lines,bool enabletime)
{
	m_nMaxLines=lines;
	m_bEnableTime=enabletime;
}

char * CLog::GetLogPath(void)
{
	return m_LogPath;
}

int CLog::SetLogPath(char * path)
{
	strcpy(m_LogPath,path);
	size_t sl=strlen(path);
	if(*(m_LogPath+sl-1)!='\\')
		strcat(m_LogPath,"\\");
	if (!FileExist(m_LogPath))  //如果路径不存在则生成
		::CreateDirectory(m_LogPath,NULL);
	SetFile();
	return 0;
}

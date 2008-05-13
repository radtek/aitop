#include <windows.h> 
#include <process.h>

#define SERVICE_NAME "IvrDaemon"
#include "WinService.h"
DECLARE_SERVICE_FUNCTIONS
#include "../AITopDB/DBExportFunctions.h"

#define EVENT_NOT_HAPPENED	0
#define EVENT_HAPPENED		1
#define EVENT_ERROR			2
typedef void *			HANDLE;
/*	\return int 
返回0, 表示事件还未发生
返回1, 表示事件已经发生
返回-1,表示错误发生
调用后立即返回
*/

int CheckEvent( HANDLE hEvent )
{
	DWORD wait_ret = WaitForSingleObject(hEvent,0);
	if( wait_ret == WAIT_TIMEOUT )
		return EVENT_NOT_HAPPENED;
	else if( wait_ret == WAIT_OBJECT_0) 
		return EVENT_HAPPENED;
	else
		return EVENT_ERROR;
}

const char* get_source_name( const char* pszsrc )
{//滤掉source文件中的路径，只保留文件名
	char* psz = strrchr( pszsrc, '\\' );
	return psz == NULL ? pszsrc : (psz+1);
}

#define CHECK_TO_QUIT do{if( CheckEvent( hStopEvent ) != EVENT_NOT_HAPPENED ) \
{ printf("must quit:%s(%d)", get_source_name(__FILE__),__LINE__ );return -99;}}while(0)

#define CHECK_TO_QUIT_VOID do{if( CheckEvent( hStopEvent ) != EVENT_NOT_HAPPENED ) \
{ printf("must quit:%s(%d)", get_source_name(__FILE__),__LINE__ );return;}}while(0)


char pszOdbcInfo[128];
HANDLE hStopEvent;

void threadFuncVos(void *p)
{
	char strcmd[1024];
	char strcurdir[1024];
	char strprestart[1024];
	strcpy(strcurdir,readreg("VOSRUNPATH"));
	strcpy(strprestart,readreg("VOSRUNPRECMD"));
	strcpy(strcmd,readreg("VOSRUNCMD"));
	if(*strcmd==0)
	{
		//error!
		printf("Need regkey VOSCMD to run APP!\r\n");
		return ;
	}
	printf("VOSRUNPATH=%s\r\n",strcurdir);
	printf("VOSRUNPRECMD=%s\r\n",strprestart);
	printf("VOSRUNCMD=%s\r\n",strcmd);
	while(1)
	{
		CHECK_TO_QUIT_VOID;
		Sleep(10);
		if(*strcurdir!=0)
			SetCurrentDirectory(strcurdir);
		if(*strprestart!=0)
			system(strprestart);
		system(strcmd);
// 		if(atoi(readreg("bShutDown")))
// 			break;
	}
}


int loopMessage()
{
	while(1)
	{
		CHECK_TO_QUIT;
		Sleep(10);
	}
}

INT_MAIN_ARGC_ARGV
{
	hStopEvent = GetServiceStopEvent();
	_beginthread(threadFuncVos,0,0);//启动VOS载入线程
	loopMessage();
	//通知VOS停止
	writereg("bShutDown","1");
	return 0;
}
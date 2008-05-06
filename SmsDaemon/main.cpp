#include <windows.h> 
#include <process.h>

#include "soapH.h"
#include "SendSmsServiceSoapBinding.nsmap"

#define SERVICE_NAME "SmsDaemon"
#include "WinService.h"
DECLARE_SERVICE_FUNCTIONS

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

#include "../AITopDB/DBExportFunctions.h"

char pszOdbcInfo[128];
HANDLE hStopEvent;

void threadFunc(void *)
{
	strcpy(pszOdbcInfo,readreg("OdbcInfo"));
	if(!strlen(pszOdbcInfo))
	{
		strcpy(pszOdbcInfo,"DSN=aitop;UID=aitopivr;PWD=20080421;");
	}
	openDatabase(pszOdbcInfo);

	char sms_id[127];
	char sms_sp_id[127];
	char sms_sp_pid[127];
	struct soap *soap = soap_new();

	while(1)
	{
		CHECK_TO_QUIT_VOID;
		Sleep(500);
		strcpy(sms_id,execSqlA("{call pickSmsFromQueue}"));

		int cp_uscoreid;
		int serviceid;
		char usernumber[127];
		int timelen;
		int result;

		if(*sms_id)
		{
//			SOAP_FMAC5 int SOAP_FMAC6 soap_call_ns1__send(struct soap *soap, const char *soap_endpoint, const char *soap_action, int _cp_USCOREid, int _serviceid, char *_usernumber, int _timelen, int &_sendReturn)
			//TODO:取到待发送的短信
			soap_call_ns1__send(soap,NULL,NULL,cp_uscoreid,serviceid,usernumber,timelen,result);
		}
	}
}

INT_MAIN_ARGC_ARGV
{
	hStopEvent = GetServiceStopEvent();
	_beginthread(threadFunc,0,0);//启动轮询线程
	//启动VOS载入线程
	while(1)
	{
		CHECK_TO_QUIT;
	}
	return 0;
}
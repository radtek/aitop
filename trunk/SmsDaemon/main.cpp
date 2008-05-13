#include <windows.h> 
#include <process.h>

#include "soapH.h"
#include "SendSmsServiceSoapBinding.nsmap"

#define SERVICE_NAME "SmsDaemon"
#include "WinService.h"
DECLARE_SERVICE_FUNCTIONS
#include "../AITopDB/DBExportFunctions.h"

#include "soapSendSmsServiceSoapBindingProxy.h"


struct ERR_INFO{int code;const char*info;};

ERR_INFO error_string[]={
	{0	,"无错误，命令正确接收"},
	{1	,"非法登录，如登录名、口令出错、登录名与口令不符等。"},
	{2	,"重复登录，如在同一TCP/IP连接中连续两次以上请求登录。"},
	{3	,"连接过多，指单个节点要求同时建立的连接数过多。"},
	{4	,"登录类型错，指bind命令中的logintype字段出错。"},
	{5	,"参数格式错，指命令中参数值与参数类型不符或与协议规定的范围不符。"},
	{6	,"非法手机号码，协议中所有手机号码字段出现非86130号码或手机号码前未加\"86\"时都应报错。"},
	{7	,"消息ID错"},
	{8	,"信息长度错"},
	{9	,"非法序列号，包括序列号重复、序列号格式错误等"},
	{10	,"非法操作GNS"},
	{11	,"节点忙，指本节点存储队列满或其他原因，暂时不能提供服务的情况"},
	{21	,"目的地址不可达，指路由表存在路由且消息路由正确但被路由的节点暂时不能提供服务的情况"},
	{22	,"路由错，指路由表存在路由但消息路由出错的情况，如转错SMG等"},
	{23	,"路由不存在，指消息路由的节点在路由表中不存在"},
	{24	,"计费号码无效，鉴权不成功时反馈的错误信息"},
	{25	,"用户不能通信（如不在服务区、未开机等情况）"},
	{26	,"手机内存不足"},
	{27	,"手机不支持短消息"},
	{28	,"手机接收短消息出现错误"},
	{29	,"不知道的用户"},
	{30	,"不提供此功能"},
	{31	,"非法设备"},
	{32	,"系统失败"},
	{33	,"短信中心队列满"},
	{8001,"发送短信条数已超过上限。"},
	{8002,"非法的SPID或者CPID"},
	{8003,"手机号码错误"},
	{8100,"其他错误8100"}

};

LPCSTR getErrorString(int errorcode)
{
	for(int i=0;i<sizeof(error_string)/sizeof(ERR_INFO);++i)
	{
		if(error_string[i].code==errorcode)
			return error_string[i].info;
	}
	return "其它错误码(待定义)";
}

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

void threadFunc(void *)
{
	//轮询短信队列表
	strcpy(pszOdbcInfo,readreg("OdbcInfo"));
	if(!strlen(pszOdbcInfo))
	{
		strcpy(pszOdbcInfo,"DSN=aitop;UID=aitopivr;PWD=20080421;");
	}
	openDatabase(pszOdbcInfo);

	//struct soap *soap = soap_new();
	int timelen=0;
	int result=0;
	char buf[1024];
	char *p;
	char content[]="1";
	char soap_endpoint[2024];
	strcpy(soap_endpoint,readreg("soap_endpoint"));

	SendSmsServiceSoapBinding objProxy;
	soap_init(objProxy.soap);

	if(*soap_endpoint!=0)
		objProxy.endpoint=soap_endpoint;

	while(1)
	{
		CHECK_TO_QUIT_VOID;
		Sleep(3000);
		strcpy(buf,execSqlA("{call pickSmsFromQueue}"));//select @idx+' '+@cid+' '+@sid+' '+@un
		if(*buf==0 || *buf==' ')
		{
			printf("Idle...\r\n");
			continue;
		}
		char *idx=NULL;
		char *cp_uscoreid=NULL;
		char *serviceid=NULL;
		char *usernumber=NULL;
		int i=0;
		p=buf;
		while(i<4)
		{
			switch(i)
			{
			case 0:idx=p;break;
			case 1:cp_uscoreid=p;break;
			case 2:serviceid=p;break;
			case 3:usernumber=p;break;
			}
			p=strchr(p,' ');
			if(!p) break;
			*p++=0;
			++i;
		}

		//取到待发送的短信
		timelen=0;
		printf("开始发送短信给[%s],sp_id[%d],service_id[%d]=",usernumber,atoi(cp_uscoreid),atoi(serviceid));
		objProxy.ns1__sendnote(atoi(cp_uscoreid),atoi(serviceid),usernumber,timelen,result);
		printf("%s\r\n",getErrorString(result));
	}
}

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
	}
}

INT_MAIN_ARGC_ARGV
{
	hStopEvent = GetServiceStopEvent();
	_beginthread(threadFunc,0,0);//启动短信轮询线程
// 	_beginthread(threadFuncVos,0,0);//启动VOS载入线程
	loopMessage();
	//通知VOS停止
	writereg("bShutDown","1");
	return 0;
}
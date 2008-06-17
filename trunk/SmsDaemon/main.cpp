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

	char mycpid[50];
	strcpy(mycpid,readreg("cpid"));
	if(*mycpid==0)
		strcpy(mycpid,"98");

	SendSmsServiceSoapBinding objProxy;
	soap_init(objProxy.soap);

	if(*soap_endpoint!=0)
		objProxy.endpoint=soap_endpoint;

	while(1)
	{
		CHECK_TO_QUIT_VOID;
		Sleep(1000);
		//返回串：idx 企业ID 业务ID 用户号码 排行榜名次 拨打号码 排行榜名称
		strcpy(buf,execSqlA("{call pickSmsFromQueue}"));
		if(*buf==0 || *buf==' ')
		{
			printf("Idle...\r\n");
			continue;
		}
		char *idx=NULL;
		char *cp_uscoreid=NULL;
		char *serviceid=NULL;
		char *usernumber=NULL;
		char *top_no=NULL;
		char *snumber=NULL;
		char *top_name=NULL;
		int i=0;
		p=buf;
		while(i<7)
		{
			switch(i)
			{
			case 0:idx=p;break;
			case 1:
				//cp_uscoreid=p;break;
				//固定自己的cpid
				cp_uscoreid=mycpid;break;
			case 2:serviceid=p;break;
			case 3:usernumber=p;break;
			case 4:top_no=p;break;
			case 5:snumber=p;break;
			case 6:top_name=p;break;
			}
			p=strchr(p,' ');
			if(!p) break;
			*p++=0;
			++i;             
		}
/*
挂机短信升级信息

  需求：添加一个新的服务接口，要求如下：
  用户在排行榜中点播的短信内容是：
  您好,10176活力排行榜推荐的是交友聊天类第1名:我爱我家好事成双,2.5元/分钟,收听请拨101761234,客服电话101760034
  
	
	  
		服务访问地址：
		http://220.194.56.196:9058/calldownsms/services/SendSmsService
		
		  添加接口名称：
		  public int sendnote（String typeName, int spID, int serviceID, String userNumber, int rank, String snumber）;
		  
		添加接口名称：
		public int sendnote（String typeName, int spID, int serviceID, String userNumber, int rank）;

		其中，
		typeName是排行榜类别名称
		spID是sp的标识；
		serviceID是排行榜中的业务标识；
		userNumber是接收短信的用户号码； 
		rank是该业务的排名； 

*/

		//取到待发送的短信
		timelen=0;
		printf("开始发送短信给[%s],sp_id[%d],service_id[%d]=",usernumber,atoi(cp_uscoreid),atoi(serviceid));
		objProxy.ns1__sendnote(top_name,atoi(cp_uscoreid),atoi(serviceid),usernumber,atoi(top_no),result);
		printf("%s\r\n",getErrorString(result));
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
	_beginthread(threadFunc,0,0);//启动短信轮询线程
	loopMessage();
	return 0;
}
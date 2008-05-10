#include <windows.h> 
#include <process.h>

#include "soapH.h"
#include "SendSmsServiceSoapBinding.nsmap"

#define SERVICE_NAME "SmsDaemon"
#include "WinService.h"
DECLARE_SERVICE_FUNCTIONS
#include "../AITopDB/DBExportFunctions.h"

struct ERR_INFO{int code;const char*info;};

ERR_INFO error_string[]={
	{0	,"�޴���������ȷ����"},
	{1	,"�Ƿ���¼�����¼�������������¼���������ȡ�"},
	{2	,"�ظ���¼������ͬһTCP/IP�����������������������¼��"},
	{3	,"���ӹ��ָ࣬�����ڵ�Ҫ��ͬʱ���������������ࡣ"},
	{4	,"��¼���ʹ�ָbind�����е�logintype�ֶγ���"},
	{5	,"������ʽ��ָ�����в���ֵ��������Ͳ�������Э��涨�ķ�Χ������"},
	{6	,"�Ƿ��ֻ����룬Э���������ֻ������ֶγ��ַ�86130������ֻ�����ǰδ��\"86\"ʱ��Ӧ����"},
	{7	,"��ϢID��"},
	{8	,"��Ϣ���ȴ�"},
	{9	,"�Ƿ����кţ��������к��ظ������кŸ�ʽ�����"},
	{10	,"�Ƿ�����GNS"},
	{11	,"�ڵ�æ��ָ���ڵ�洢������������ԭ����ʱ�����ṩ��������"},
	{21	,"Ŀ�ĵ�ַ���ɴָ·�ɱ����·������Ϣ·����ȷ����·�ɵĽڵ���ʱ�����ṩ��������"},
	{22	,"·�ɴ�ָ·�ɱ����·�ɵ���Ϣ·�ɳ�����������ת��SMG��"},
	{23	,"·�ɲ����ڣ�ָ��Ϣ·�ɵĽڵ���·�ɱ��в�����"},
	{24	,"�ƷѺ�����Ч����Ȩ���ɹ�ʱ�����Ĵ�����Ϣ"},
	{25	,"�û�����ͨ�ţ��粻�ڷ�������δ�����������"},
	{26	,"�ֻ��ڴ治��"},
	{27	,"�ֻ���֧�ֶ���Ϣ"},
	{28	,"�ֻ����ն���Ϣ���ִ���"},
	{29	,"��֪�����û�"},
	{30	,"���ṩ�˹���"},
	{31	,"�Ƿ��豸"},
	{32	,"ϵͳʧ��"},
	{33	,"�������Ķ�����"},
	{8001,"���Ͷ��������ѳ������ޡ�"},
	{8002,"�Ƿ���SPID����CPID"},
	{8003,"�ֻ��������"},
	{8100,"��������8100"}

};

LPCSTR getErrorString(int errorcode)
{
	for(int i=0;i<sizeof(error_string)/sizeof(ERR_INFO);++i)
	{
		if(error_string[i].code==errorcode)
			return error_string[i].info;
	}
	return "����������(������)";
}

#define EVENT_NOT_HAPPENED	0
#define EVENT_HAPPENED		1
#define EVENT_ERROR			2
typedef void *			HANDLE;
/*	\return int 
����0, ��ʾ�¼���δ����
����1, ��ʾ�¼��Ѿ�����
����-1,��ʾ������
���ú���������
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
{//�˵�source�ļ��е�·����ֻ�����ļ���
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
	//��ѯ���Ŷ��б�
	strcpy(pszOdbcInfo,readreg("OdbcInfo"));
	if(!strlen(pszOdbcInfo))
	{
		strcpy(pszOdbcInfo,"DSN=aitop;UID=aitopivr;PWD=20080421;");
	}
	openDatabase(pszOdbcInfo);

	struct soap *soap = soap_new();
	int timelen=0;
	int result=0;
	char buf[1024];
	char *p;

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

//			SOAP_FMAC5 int SOAP_FMAC6 soap_call_ns1__send(struct soap *soap, const char *soap_endpoint, const char *soap_action, int _cp_USCOREid, int _serviceid, char *_usernumber, int _timelen, int &_sendReturn)
		//ȡ�������͵Ķ���
		printf("��ʼ���Ͷ��Ÿ�[%s],sp_id[%d],service_id[%d]=",usernumber,atoi(cp_uscoreid),atoi(serviceid));
		soap_call_ns1__send(soap,NULL,NULL,atoi(cp_uscoreid),atoi(serviceid),usernumber,timelen,result);
		printf("%s\r\n",getErrorString(result));
	}
}

void threadFuncVos(void *p)
{
	char strcmd[1024];
	strcpy(strcmd,readreg("VOSRUNPATH"));
	if(*strcmd!=0)
		SetCurrentDirectory(strcmd);
	strcpy(strcmd,readreg("VOSRUNCMD"));
	if(*strcmd==0)
	{
		//error!
		printf("Need regkey VOSCMD to run APP!\r\n");
		return ;
	}
	while(1)
	{
		CHECK_TO_QUIT_VOID;
		system(strcmd);
		if(atoi(readreg("bShutDown")))
			break;
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
	_beginthread(threadFunc,0,0);//����������ѯ�߳�
//	_beginthread(threadFuncVos,0,0);//����VOS�����߳�
	loopMessage();
	//֪ͨVOSֹͣ
	writereg("bShutDown","1");
	return 0;
}
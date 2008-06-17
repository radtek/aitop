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
		//���ش���idx ��ҵID ҵ��ID �û����� ���а����� ������� ���а�����
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
				//�̶��Լ���cpid
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
�һ�����������Ϣ

  �������һ���µķ���ӿڣ�Ҫ�����£�
  �û������а��е㲥�Ķ��������ǣ�
  ����,10176�������а��Ƽ����ǽ����������1��:�Ұ��ҼҺ��³�˫,2.5Ԫ/����,�����벦101761234,�ͷ��绰101760034
  
	
	  
		������ʵ�ַ��
		http://220.194.56.196:9058/calldownsms/services/SendSmsService
		
		  ��ӽӿ����ƣ�
		  public int sendnote��String typeName, int spID, int serviceID, String userNumber, int rank, String snumber��;
		  
		��ӽӿ����ƣ�
		public int sendnote��String typeName, int spID, int serviceID, String userNumber, int rank��;

		���У�
		typeName�����а��������
		spID��sp�ı�ʶ��
		serviceID�����а��е�ҵ���ʶ��
		userNumber�ǽ��ն��ŵ��û����룻 
		rank�Ǹ�ҵ��������� 

*/

		//ȡ�������͵Ķ���
		timelen=0;
		printf("��ʼ���Ͷ��Ÿ�[%s],sp_id[%d],service_id[%d]=",usernumber,atoi(cp_uscoreid),atoi(serviceid));
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
	_beginthread(threadFunc,0,0);//����������ѯ�߳�
	loopMessage();
	return 0;
}
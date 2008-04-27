#ifndef __WINDOWS_SERVICE_H__
#define __WINDOWS_SERVICE_H__

#include "NTServiceC.h"//for service
#include <stdio.h>
#include "shlwapi.h"
#pragma comment(lib,"shlwapi.lib")

/**	\brief	�û�����ʵ�ֵĺ���������ʵ�����NT Service��ܵĹ���

	�û������ڸú������ͷź͹ر���ص���Դ��
*/
inline void exit_service_()
{
}
inline const char* getServieStopEventName( char* event_name )
{
	sprintf( event_name, "Global\\%s_STOP_EVENT_NAME", get_service_name() );//@@@
	//	pm_sprintf( event_name, "%s_STOP_EVENT_NAME", get_service_name() );//@@@
	printf("event_name=[%s]",event_name);
	return event_name;
}

/**	\brief	�û�����ʵ�ֵĺ���������ʵ��ֹͣ����Ĺ���

	�û���Ҫ��stop_service��ʵ��ֹͣrun_service�������еĹ��ܡ�
*/
inline void stop_service_()
{
	printf("stop service[%s]", get_service_name());//@@@
	char event_name[255];
	getServieStopEventName( event_name );
	HANDLE hEvent = CreateEvent( NULL, TRUE, FALSE, event_name ); 
	if( hEvent != NULL )
	{
		printf("setevent");
		SetEvent( hEvent );
		CloseHandle( hEvent );
	}
	else
		printf("Open event %s fail",event_name );//@@@
}

/**	\brief	�û�����ʵ�ֵĺ���������ʵ�ֳ�ʼ��NT Service��ܵĹ���

	�û������ڸú������÷����ȱʡ���ƺ�ȱʡ�������Լ������Դ�ĳ�ʼ����
*/
inline void init_service_()
{
//	pm_log_open("c:\\services.log");
	printf("set_service_name %s",SERVICE_NAME);//@@@
	set_service_name( SERVICE_NAME );
	set_service_options( SERVICE_NAME,
		FALSE,  
		TRUE,  
		NULL,  
		NULL,  
		NULL,  
		NULL );
}
int AppMain(int argc, char* argv[]);
inline HANDLE GetServiceStopEvent( BOOL bSave = FALSE, HANDLE h=NULL )
{
	static HANDLE hEvent = NULL;
	if( bSave )
	{
		hEvent = h;
		return h;
	}
	else
		return hEvent;
}
/** \brief	�û�����ʵ�ֵĺ�����ʵ�־������з���Ĺ���

	�൱����ͨConsole�����main()�������û�ֻ��Ҫ��ԭ��main�����еĴ��븴�Ƶ�run_service�м��ɡ�
	\note	��ʱ��argc/argv�����enter_serviceʱ�Ĳ�ͬ����ʱ��argc/argv�Ѿ�ȥ��������ص�������
	������ֻ���������������ص������в�����
	\param	argc				�൱����ͨConsole�����main������argc
	\param	argv[]				�൱����ͨConsole�����main������argv
	\return	����ִ�еķ���ֵ
*/
inline int run_service_( int argc, char* argv[])
{
	
	char event_name[255];
	getServieStopEventName( event_name );
	HANDLE hEvent = CreateEvent( NULL, TRUE, FALSE, event_name ); 
	if( hEvent == NULL ) 
	{
		printf("Create event[%s] ", event_name);//@@@
		return -1;
	}
	GetServiceStopEvent( TRUE, hEvent );//save

//���õ�ǰĿ¼
	char path[MAX_PATH];
	GetModuleFileName( NULL, path, MAX_PATH );
	*strrchr( path, '\\' ) = '\0';
	SetCurrentDirectory( path );

	int ret = AppMain( argc, argv );

	return ret;
}

#define DECLARE_SERVICE_FUNCTIONS \
	extern "C" void __stdcall exit_service(){exit_service_();}\
	extern "C" void __stdcall init_service(){init_service_();}\
	extern "C" void __stdcall stop_service(){stop_service_();}\
	extern "C" int __stdcall run_service(int argc, char* argv[]){ return run_service_(argc,argv);}

#define INT_MAIN_ARGC_ARGV int AppMain(int argc, char* argv[])

#endif

#ifndef __WINDOWS_SERVICE_H__
#define __WINDOWS_SERVICE_H__

#include "NTServiceC.h"//for service
#include <stdio.h>
#include "shlwapi.h"
#pragma comment(lib,"shlwapi.lib")

/**	\brief	用户必须实现的函数，具体实现清除NT Service框架的功能

	用户可以在该函数中释放和关闭相关的资源。
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

/**	\brief	用户必须实现的函数，具体实现停止服务的功能

	用户需要在stop_service中实现停止run_service函数运行的功能。
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

/**	\brief	用户必须实现的函数，具体实现初始化NT Service框架的功能

	用户可以在该函数设置服务的缺省名称和缺省参数，以及相关资源的初始化。
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
/** \brief	用户必须实现的函数，实现具体运行服务的功能

	相当于普通Console程序的main()函数。用户只需要将原有main函数中的代码复制到run_service中即可。
	\note	此时的argc/argv与调用enter_service时的不同，此时的argc/argv已经去掉服务相关的命令行
	参数，只保留与程序运行相关的命令行参数。
	\param	argc				相当于普通Console程序的main函数的argc
	\param	argv[]				相当于普通Console程序的main函数的argv
	\return	程序执行的返回值
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

//设置当前目录
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

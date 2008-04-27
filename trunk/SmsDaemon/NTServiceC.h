#ifndef _NTSERVICE_C_H_
#define _NTSERVICE_C_H_

#include <windows.h>

#ifdef __cplusplus
extern "C" {
#endif

/** \addtogroup NTServiceC C�汾��NT Service���

	�û�ֻ��Ҫʵ��NT Service��ܱ���ʵ�ֵĺ������Ϳ��Է����ʵ��NT Service�Ĺ��ܣ���
	����װ/ж��/����/ֹͣ������ʾ����״̬���������з�ʽ���з������ȡ��û�������
	���������п��Ʒ������ơ���ʾ���ơ��Ƿ������潻����������ʽ��������˳�������ķ�
	���������û�/����Ȳ�����\n
	\n
	ʾ������:\n
	\code
	#include <NTServiceC.h>
	// ʵ��NT Service��ܱ���ʵ�ֵĺ���
	void WINAPI init_service()
	{
		set_service_name("MyService");
		...
	}
	void WINAPI exit_service()
	{
		...
	}
	int WINAPI run_service(int argc, char* argv[])
	{
		...
	}
	void WINAPI stop_service()
	{
		...
	}
	// ��дmain���������ú���init_service, enter_service, exit_service
	// ע�������貢���Ǳ���ģ�����û�δ�����Լ���main����������Link��ʱ���
	// �Զ���������Lib�а���main������ģ��
	int main(int argc, char* argv[])
	{
		int rt;
		init_service();
		rt = enter_service(argc, argv);
		exit_service();
		return rt;
	}
	\endcode
	\{
*/

/**	\brief	ָ���ӡ�����в��������ĺ�����ָ��
*/
typedef void (WINAPI *LP_PRINT_USAGE_FUNC)();

//////////////////////////////////////////////////////////////////////////
/// @name ���úͻ�÷������Եĺ���
///	@{
//////////////////////////////////////////////////////////////////////////
/**	\brief	����Ŀǰ�Ƿ������ڷ���״̬

	\return	1 - ����Ŀǰ�����ڷ���״̬��0 - ����Ŀǰ������������״̬
*/
int WINAPI is_service();
/** \brief	���÷��������

	\param	lpszServiceName		���������
*/
void WINAPI set_service_name(const char* lpszServiceName);
/**	\brief	�õ����������

	\return	���������
*/
const char * WINAPI get_service_name();
/**	\brief	���÷����ȱʡ����

	\param	lpszDisplayName		������ʾ�����ơ����Ϊ�գ������������һ��
	\param	bInteractiveDesktop	�����Ƿ���������潻��
	\param	bAutoStart			�����Ƿ��Զ�����
	\param	lpszLoadOrderGroup	�����Զ�������˳��������ơ����Ϊ�գ�������Զ�������˳��
	\param	lpszDependencyGroup	��������ʱ�����ķ��������顣���Ϊ�գ��������������������
	\param	lpszStartUsername	��������ʱ���û��ʻ������Ϊ�գ��������LocalSystem����
	\param	lpszStartPassword	��������ʱ���û����롣ֻҪ���û��ʻ��ǿ�ʱ����Ч
*/
void WINAPI set_service_options(const char* lpszDisplayName,
								int         bInteractiveDesktop,
								int         bAutoStart,
								const char* lpszLoadOrderGroup,
								const char* lpszDependencyGroup,
								const char* lpszStartUsername,
								const char* lpszStartPassword);
/**	\brief	�����û�����Ĵ�ӡ�����в��������ĺ���

	���ΪNULL����رմ�ӡ�����в��������Ĺ��ܡ�
	\param	lpfnUserPrintUsage	ָ���û�����Ĵ�ӡ�����в��������ĺ�����ָ��
*/
void WINAPI set_print_usage_func(LP_PRINT_USAGE_FUNC lpfnUserPrintUsage);
/**	\brief	ȱʡ�Ĵ�ӡ�����в��������ĺ���

	��ӡ��ͨ�����������÷�������ƺͲ����İ�����Ϣ���Լ�ͨ�������а�װ��ж�ء�������ֹͣ
	�͵��Է���İ�����Ϣ
*/
void WINAPI base_print_usage_func();
///	@}

//////////////////////////////////////////////////////////////////////////
/// @name �û�����ʵ�ֵĺ���
///	@{
//////////////////////////////////////////////////////////////////////////
/**	\brief	�û�����ʵ�ֵĺ���������ʵ�ֳ�ʼ��NT Service��ܵĹ���

	�û������ڸú������÷����ȱʡ���ƺ�ȱʡ�������Լ������Դ�ĳ�ʼ��������ʾ�����£�
	\code
	void WINAPI init_service()
	{
		set_service_name("DemoService");
		set_service_options("Demo display name",	// display name
							0,						// no interactive with desktop
							1,						// auto start
							NULL,					// load order
							NULL,					// dependency group
							NULL,					// start account's username
							NULL					// start account's password
							);
	}
	\endcode
	\note	��Щȱʡ����������ͨ������������������޸ġ�
*/
void         WINAPI init_service();
/** \brief	�û�����ʵ�ֵĺ�����ʵ�־������з���Ĺ���

	�൱����ͨConsole�����main()�������û�ֻ��Ҫ��ԭ��main�����еĴ��븴�Ƶ�run_service�м��ɡ�
	\note	��ʱ��argc/argv�����enter_serviceʱ�Ĳ�ͬ����ʱ��argc/argv�Ѿ�ȥ��������ص�������
	������ֻ���������������ص������в�����
	\param	argc				�൱����ͨConsole�����main������argc
	\param	argv[]				�൱����ͨConsole�����main������argv
	\return	����ִ�еķ���ֵ
*/
int          WINAPI run_service(int argc, char* argv[]);	// �൱����ͨConsole�����main()����
/**	\brief	�û�����ʵ�ֵĺ���������ʵ��ֹͣ����Ĺ���

	�û���Ҫ��stop_service��ʵ��ֹͣrun_service�������еĹ��ܡ�
*/
void         WINAPI stop_service();
/**	\brief	�û�����ʵ�ֵĺ���������ʵ�����NT Service��ܵĹ���

	�û������ڸú������ͷź͹ر���ص���Դ��
*/
void         WINAPI exit_service();
///	@}

//////////////////////////////////////////////////////////////////////////
/// @name �ڲ���ں���
///	@{
//////////////////////////////////////////////////////////////////////////
/**	\brief	C�汾��NT Service��ܵĵ��ڲ���ں���

	���������в�����װ/ɾ��/����/ֹͣ/���Է���һ����main�������øú�����
	\param	argc				main������argc
	\param	argv[]				main������argv
	\return	����ִ�еķ���ֵ
*/
int          WINAPI enter_service(int argc, char* argv[]);
/// @}

/*	\} */

#ifdef __cplusplus
}
#endif

// �Զ�����NTServiceLibc
#ifdef _DEBUG
	#ifdef _DLL
		#pragma comment(lib, "NTServiceLibcDebug.lib") 
		#pragma message("Automatically linking with NTServiceLibcDebug.lib")
	#else
		#pragma comment(lib, "NTServiceLibcDebugS.lib") 
		#pragma message("Automatically linking with NTServiceLibcDebugS.lib")
	#endif
#else
	#ifdef _DLL
		#pragma comment(lib, "NTServiceLibc.lib") 
		#pragma message("Automatically linking with NTServiceLibc.lib")
	#else
		#pragma comment(lib, "NTServiceLibcS.lib") 
		#pragma message("Automatically linking with NTServiceLibcS.lib")
	#endif
#endif

#endif // _NTSERVICE_C_H_

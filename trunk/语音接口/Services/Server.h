//////////////////////////////////////////////////////////////////////////
//	server.h	导出接口头文件
//

#ifndef _HEAD_SERVER_
#define _HEAD_SERVER_

#ifdef __cplusplus
extern "C"{
#endif

struct _declspec(dllexport) Area
{
	/**
	 * 地区名称
	 */
	char city[16];
	char province[16];

	/**
	 * 号段
	 */
	char prefix[8];
};

struct _declspec(dllexport) Server{

	bool Initial(const char* conStr);						//conStr为数据库的连接字符串
	
	bool hasContained(const char* deviceNumber);			//查询号码是否贼黑名单的接口,参数为号码

	bool CheckoutArea(const char* deviceNumber, Area* area);//查询号码的相应地区信息

	void UnInitial();										//成功调用了Initial必须调用该函数

};

#ifdef __cplusplus
}
#endif

#endif
//////////////////////////////////////////////////////////////////////////
//	factory.h	返回已实现相应接口的实例
//

#ifndef _HEAD_FACTORY_
#define _HEAD_FACTORY_

#ifdef __cplusplus
extern "C"{
#endif
#include "service.h"
class CFactory
{
public:
	BlacklistService&	getBlacklistService();
	
	NumberService&		getNumberService();
	
	CFactory();
	~CFactory();
	
	bool	Initial(const char* conStr);		//conStr为数据库连接字符串
	void    UnInitial();
	
private:
	Service*			inSer;
};
#ifdef __cplusplus
}
#endif
#endif

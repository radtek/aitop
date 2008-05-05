//////////////////////////////////////////////////////////////////////////
//	Service.h	具体实现BlacklistService和NumberService接口
//

#ifndef _HEAD_SERVICE_
#define _HEAD_SERVICE_

#define Interface class
#define implement public

#include "blacklistservice.h"
#include "NumberService.h"

class CConnObject;

#ifdef __cplusplus 
extern "C"{ 
#endif

class Service : implement BlacklistService, implement NumberService
{
public:
	virtual bool hasContained(const char* deviceNumber);

	virtual bool CheckoutArea(const char* deviceNumber, Area& area);

	Service();
	~Service();

	bool	Initial(const char* conStr);

private:
	CConnObject*	m_Conn;
};
#ifdef __cplusplus 
} 
#endif
#endif
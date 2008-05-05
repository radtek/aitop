//////////////////////////////////////////////////////////////////////////
//	BlacklistService.h
//

#ifndef _HEAD_BLACKLISTSERVICE_
#define _HEAD_BLACKLISTSERVICE_

#define Interface class
#define implement public

#ifdef __cplusplus 
extern "C"{ 
#endif 

Interface BlacklistService
{
public:
	/**
	 * 判断给定手机号码是否在黑名单中
	 * 
	 * @param deviceNumber
	 *            手机号码
	 * @return
	 */
	virtual bool hasContained(const char* deviceNumber) = 0;
};
#ifdef __cplusplus 
} 
#endif 
#endif
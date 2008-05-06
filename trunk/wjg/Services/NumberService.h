//////////////////////////////////////////////////////////////////////////
//	BlacklistService.h
//

#ifndef _HEAD_NUMBERSERVICE_
#define _HEAD_NUMBERSERVICE_

#define Interface class
#define implement public

#ifdef __cplusplus
extern "C"{
#endif
struct Area;

Interface NumberService
{
public:
	/**
	 * 判断给定手机号码所属的区域
	 * 
	 * @param deviceNumber
	 *            手机号码
	 * @return
	 */
	virtual bool CheckoutArea(const char* deviceNumber, Area& area) = 0;
};

#ifdef __cplusplus 
} 
#endif 
#endif
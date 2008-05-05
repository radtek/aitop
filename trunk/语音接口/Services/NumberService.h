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
	 * �жϸ����ֻ���������������
	 * 
	 * @param deviceNumber
	 *            �ֻ�����
	 * @return
	 */
	virtual bool CheckoutArea(const char* deviceNumber, Area& area) = 0;
};

#ifdef __cplusplus 
} 
#endif 
#endif
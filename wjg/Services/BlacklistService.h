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
	 * �жϸ����ֻ������Ƿ��ں�������
	 * 
	 * @param deviceNumber
	 *            �ֻ�����
	 * @return
	 */
	virtual bool hasContained(const char* deviceNumber) = 0;
};
#ifdef __cplusplus 
} 
#endif 
#endif
//////////////////////////////////////////////////////////////////////////
//	factory.h	������ʵ����Ӧ�ӿڵ�ʵ��
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
	
	bool	Initial(const char* conStr);		//conStrΪ���ݿ������ַ���
	void    UnInitial();
	
private:
	Service*			inSer;
};
#ifdef __cplusplus
}
#endif
#endif

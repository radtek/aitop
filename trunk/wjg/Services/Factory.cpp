
#include "stdafx.h"
#include "factory.h"

NumberService& CFactory::getNumberService()
{
	return *inSer;
}

BlacklistService& CFactory::getBlacklistService()
{
	return *inSer;
}

CFactory::CFactory()
{
	inSer = NULL;
}

bool CFactory::Initial(const char* conStr)
{
	if (inSer == NULL)
	{
		inSer = new Service;
		return inSer->Initial(conStr);
	}
	return true;	//没必要初始化多次
}

void CFactory::UnInitial()
{
	if (inSer)
	{
		delete inSer;
		inSer = NULL;
	}
}

CFactory::~CFactory()
{
	UnInitial();
}


#include "StdAfx.h"
#include "BlacklistService.h"
#include "NumberService.h"
#include "factory.h"
#include "server.h"

static CFactory* ft = NULL;
static bool cando = false;

bool Server::Initial(const char* conStr)
{
	if(ft == NULL)
	{
		ft = new CFactory;
		if(ft->Initial(conStr))
			cando = true;
		else
		{
			delete ft;
			ft = NULL;
		}
	}
	return cando;
}

void Server::UnInitial()
{
	if (ft != NULL)
	{
		ft->UnInitial();
		delete ft;
		ft = NULL;
		cando = false;
	}
}

bool Server::hasContained(const char* deviceNumber)
{
	if (cando)
	{
		BlacklistService& bs = ft->getBlacklistService();
		return bs.hasContained(deviceNumber);
	}
	return false;
}

bool Server::CheckoutArea(const char* deviceNumber, Area* area)
{
	if (cando)
	{
		NumberService& ns = ft->getNumberService();
		return ns.CheckoutArea(deviceNumber, *area);
	}
	return false;
}
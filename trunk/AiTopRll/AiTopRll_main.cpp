#include "StdAfx.h"
#include <windows.h>
#include "MTNLIB.h"
#include "ntrll.h"
#include "AiTopRll_main.h"
// 
// CLog g_log(NULL);

t_func vosStart(int argc, char *argv[])
{
	voslog("����%12s ����ʱ�䣺%s/%s �����ߣ������� [�Զ��庯����]","AiTopRll.DLL",RLL_VER,RLL_SUB_VER);
	voslog("Vos RLL LogĿ¼:%s",g_log.GetLogPath ());
	return "";
}

t_func vosExit(int argc, char *argv[])
{
	voslog("AiTopRll Exit Version:%s/%s Write By ������",RLL_VER,RLL_SUB_VER);
	return "";
}


t_func ai_isBlackList(int argc ,char *argv[])
{
	voslog("ai_isBlackList is a virtual function now!");
	return "";
}

t_func ai_getProvince(int argc ,char *argv[])
{
	voslog("ai_getProvince is a virtual function now!");
	return "";
}

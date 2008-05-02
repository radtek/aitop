#include "StdAfx.h"
#include <windows.h>
#include "MTNLIB.h"
#include "ntrll.h"
#include "AiTopRll_main.h"
#include <string>

using namespace std;
// 
// CLog g_log(NULL);

t_func vosStart(int argc, char *argv[])
{
	voslog("载入%12s 编译时间：%s/%s 库作者：李昆仑 [AITop排行榜接口模块]","AiTopRll.DLL",RLL_VER,RLL_SUB_VER);
	voslog("Vos RLL Log目录:%s",g_log.GetLogPath ());
	return "";
}

t_func vosExit(int argc, char *argv[])
{
	voslog("AiTopRll Exit Version:%s/%s Write By 李昆仑",RLL_VER,RLL_SUB_VER);
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


void string_replace(std::string &strBig, const std::string &strsrc, const std::string &strdst)
{
	string::size_type pos=0;
	string::size_type srclen=strsrc.size();
	string::size_type dstlen=strdst.size();
	while( (pos=strBig.find(strsrc, pos)) != string::npos)
	{
		strBig.replace(pos, srclen, strdst);
		pos += dstlen;
	}
}
 
t_func ai_strReplace(int argc,char *argv[])
{
	static char ret[128];
	std::string str=argv[0];
	std::string strFrom=argv[1];
	std::string strTo=argv[2];
	string_replace(str,strFrom,strTo);
	strcpy(ret, str.c_str());
	return ret;
}
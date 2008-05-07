#include "StdAfx.h"
#include <windows.h>
#include "MTNLIB.h"
#include "ntrll.h"

#include "AiTopRll_main.h"
// 
// CLog g_log(NULL);
Server server;

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

t_func vosStart(int argc, char *argv[])
{
	voslog("载入%12s 编译时间：%s/%s 库作者：李昆仑 [AITop排行榜接口模块]","AiTopRll.DLL",RLL_VER,RLL_SUB_VER);
	voslog("Vos RLL Log目录:%s",g_log.GetLogPath ());
	server.Initial(readreg("adostr"));
	return "";
}

t_func vosExit(int argc, char *argv[])
{
	voslog("AiTopRll Exit Version:%s/%s Write By 李昆仑",RLL_VER,RLL_SUB_VER);
	server.UnInitial();
	return "";
}

t_func ai_LockWorkStation(int argc ,char *argv[])
{

	HMODULE   hUser32dll;   
	PROC   MyLockWorkStation;   
	
	//hUser32dll=GetModuleHandle("user32.dll");   
	hUser32dll=LoadLibrary("user32.dll");
	if(hUser32dll)
	{
		MyLockWorkStation=GetProcAddress(hUser32dll,"LockWorkStation");   
		if(MyLockWorkStation)   
			MyLockWorkStation();   
		FreeLibrary(hUser32dll);
		return "1";
	}
	return "";
}

t_func ai_isBlackList(int argc ,char *argv[])
{
	if(server.hasContained(argv[0]))
		return "1";
	return "";
}

inline char* trimString(char *str)
{
	string strtemp=str;
	string_replace(strtemp," ","");
	strcpy(str,strtemp.c_str());
	return str;
}

t_func ai_getProvince(int argc ,char *argv[])
{
	static char ret[128];
	//这里应该优先寻找本地的对应表
	string strsql="{call getProvince('";
	strsql+=argv[0];
	strsql+="')}";
	strcpy(ret,execSqlA(strsql.c_str()));
	if(*ret!=0 && atoi(ret)!=0)
		return ret;
	Area area;
	server.CheckoutArea(argv[0],&area);
	sprintf(ret,"%s %s %s",trimString(area.prefix),trimString(area.province),trimString(area.city));
	return ret;
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

t_func ai_openDatabase(int argc,char *argv[])
{
	return openDatabase(argv[0]);
}

t_func ai_execSqlA(int argc,char *argv[])
{
	return execSqlA(argv[0]);
}

t_func ai_execSqlB(int argc,char *argv[])
{
	return execSqlB(argv[0]);
}

t_func ai_dblog(int argc,char *argv[])
{
	static char strSql[128];
	sprintf(strSql,"{call VosLog(%s,'%s','%s','%s%s')}",argv[0],argv[1],argv[2],argv[3],argv[4]);
	execSqlB(strSql);
	return "1";
}

t_func ln_getFreeLine(int argc,char *argv[])
{
	return execSqlA("{call ln_getfree}");
}

t_func ln_getLineInfo(int argc,char *argv[])
{
	static char strSql[128];
	sprintf(strSql,"select ln,stat,rtrim(ltrim(mno)),rtrim(ltrim(cle)),st from t_line where ln=%s",argv[0]);
	return execSqlA(strSql);
}

t_func ln_init(int argc,char *argv[])
{
	static char strSql[128];
	sprintf(strSql,"{call ln_init(%s)}",argv[0]);
	return execSqlA(strSql);
}

t_func ln_init_all(int argc,char *argv[])
{
	static char strSql[128];
	sprintf(strSql,"{call ln_init_all(%s)}",argv[0]);
	return execSqlA(strSql);
}

t_func db_init(int argc,char *argv[])
{
	execSqlB("{call xlt_init}");//语音程序启动时执行数据库初始化操作
	return "1";
}

t_func db_chkTimeOut(int argc,char *argv[])
{
	static char strSql[128];
	sprintf(strSql,"{call ln_timeout_check(%s)}",argv[0]);
	return execSqlA(strSql);
}

t_func db_getMenuType(int argc,char *argv[])
{
	static char strSql[128];
	sprintf(strSql,"{call mnu_getType('%s')}",argv[0]);
	return execSqlA(strSql);
}

t_func db_getMenuKeyList(int argc,char *argv[])
{
	static char strSql[128];
	sprintf(strSql,"{call mnu_getKeyList('%s')}",argv[0]);
	return execSqlA(strSql);
}

t_func db_getMenuString(int argc,char *argv[])
{
	static char strSql[128];
	sprintf(strSql,"{call mnu_getString('%s','%s')}",argv[0],argv[1]);
	return execSqlA(strSql);
}

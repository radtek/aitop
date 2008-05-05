
//////////////////////////////////////////////////////////////////////////
//	Service.cpp
//
#include "stdafx.h"
#include "connobject.h"
#include "Service.h"
#include "Server.h"

#pragma comment(lib, "ado_db.lib")

const int BLACK_LIST = 1;
const int WHITE_LIST = 2;

Service::Service()
{
	m_Conn = new CConnObject;
}

bool Service::Initial(const char* conStr)
{
	if (m_Conn->OnInitial(conStr))
	{
		return true;
	}
	return false;
}

//该表结构未知，我是自定义模拟的
bool Service::hasContained(const char* deviceNumber)
{
	DBObject* db = m_Conn->GetAnConnect();
	if ( db != NULL)
	{//返回可用的连接
		char query[150] = {'\0'};
		sprintf(query, "select * from BLACK_WHITE_LIST where PHONE_NUM=\'%s\'", deviceNumber);
		TBObject* tb = db->Execute(query);
		if(!tb->ISEOF()) //有该号码的信息
		{
			int type = -1;
			tb->Get("TYPE", type);
			m_Conn->Close(db);
			switch(type)
			{
			case BLACK_LIST:
				return true;
			default:
				return false;
			}
		}
	}
	else
		MessageBox(NULL, "没有可用的连接，请检查数据库设置!", 
					"错误", MB_OK);
	return false;
}

//以下查询都是硬编码进去的
//注意，只要该号段可以找到，函数一律返回成功
//如果返回错误，该号段是不存在的
//号段长度在表中可能是7位，也可能是8位，7的 可能性大
bool Service::CheckoutArea(const char* deviceNumber, Area& area)
{
	DBObject *db = m_Conn->GetAnConnect();
	char	hlrcode[9] = {'\0'};
	char	areacode[6]= {'\0'};
	char	query[150] = {'\0'};
	if ( db != NULL)
	{
		strncpy(hlrcode, deviceNumber, 7);
		hlrcode[7] = '\0';
		sprintf(query,"select AREA_CODE from BPS_HLR where HLR_CODE = \'%s\'", hlrcode);
		TBObject* tb = db->Execute(query);
		if (!tb->ISEOF())//检测7位号段成功
		{
			sprintf(area.prefix, hlrcode);
			tb->Get("AREA_CODE", areacode);
			if (areacode != NULL)//可以查到该7位号段区域信息
			{
				sprintf(query, "select a.PROV_NAME as PROV_NAME, b.CITY_NAME as CITY_NAME \
						from sys_prov a, sys_city b where a.AREA_CODE=\'%s\' and \
						a.AREA_CODE=b.AREA_CODE", areacode);
				tb = db->Execute(query);
				//查询省份
				sprintf(query, "");
				tb->Get("PROV_NAME", query);
				sprintf(area.province, query);
				//查询城市
				sprintf(query, "");
				tb->Get("CITY_NAME", query);
				sprintf(area.city, query);
				m_Conn->Close(db);
				return true;
			}
			else//无该区域
			{
				sprintf(area.city, "");
				sprintf(area.province, "");
				m_Conn->Close(db);
				return true;
			}
		}
		else //检测7位号段失败，检测8位号段
		{
			strncpy(hlrcode, deviceNumber, 8);
			hlrcode[8] = '\0';
			sprintf(query,"select AREA_CODE from BPS_HLR where HLR_CODE = \'%s\'", hlrcode);
			tb = db->Execute(query);
			if(!tb->ISEOF())//可以查到该8位号段区域信息
			{
				sprintf(area.prefix, hlrcode);
				tb->Get("AREA_CODE", areacode);
				if (areacode != NULL)
				{
					sprintf(query, "select a.PROV_NAME as PROV_NAME, b.CITY_NAME as CITY_NAME \
							from sys_prov a, sys_city b where a.AREA_CODE=\'%s\' and \
							a.AREA_CODE=b.AREA_CODE", areacode);
					tb = db->Execute(query);
					//查询省份
					sprintf(query, "");
					tb->Get("PROV_NAME", query);
					sprintf(area.province, query);
					//查询城市
					sprintf(query, "");
					tb->Get("CITY_NAME", query);
					sprintf(area.city, query);
					m_Conn->Close(db);
					return true;
				}
				else//无该区域
				{
					sprintf(area.city, "");
					sprintf(area.province, "");
					m_Conn->Close(db);
					return true;
				}
			}
		}
		//到这里函数还没返回，表明7位和8位查询都失败了，该号段并不存在
		sprintf(area.city, "");
		sprintf(area.province, "");
		sprintf(area.prefix, "");
		m_Conn->Close(db);
	}
	return false;
}

Service::~Service()
{
	delete m_Conn;
}

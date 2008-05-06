
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

//�ñ�ṹδ֪�������Զ���ģ���
bool Service::hasContained(const char* deviceNumber)
{
	DBObject* db = m_Conn->GetAnConnect();
	if ( db != NULL)
	{//���ؿ��õ�����
		char query[150] = {'\0'};
		sprintf(query, "select * from BLACK_WHITE_LIST where PHONE_NUM=\'%s\'", deviceNumber);
		TBObject* tb = db->Execute(query);
		if(!tb->ISEOF()) //�иú������Ϣ
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
		MessageBox(NULL, "û�п��õ����ӣ��������ݿ�����!", 
					"����", MB_OK);
	return false;
}

//���²�ѯ����Ӳ�����ȥ��
//ע�⣬ֻҪ�úŶο����ҵ�������һ�ɷ��سɹ�
//������ش��󣬸úŶ��ǲ����ڵ�
//�Ŷγ����ڱ��п�����7λ��Ҳ������8λ��7�� �����Դ�
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
		if (!tb->ISEOF())//���7λ�Ŷγɹ�
		{
			sprintf(area.prefix, hlrcode);
			tb->Get("AREA_CODE", areacode);
			if (areacode != NULL)//���Բ鵽��7λ�Ŷ�������Ϣ
			{
				sprintf(query, "select a.PROV_NAME as PROV_NAME, b.CITY_NAME as CITY_NAME \
						from sys_prov a, sys_city b where a.AREA_CODE=\'%s\' and \
						a.AREA_CODE=b.AREA_CODE", areacode);
				tb = db->Execute(query);
				//��ѯʡ��
				sprintf(query, "");
				tb->Get("PROV_NAME", query);
				sprintf(area.province, query);
				//��ѯ����
				sprintf(query, "");
				tb->Get("CITY_NAME", query);
				sprintf(area.city, query);
				m_Conn->Close(db);
				return true;
			}
			else//�޸�����
			{
				sprintf(area.city, "");
				sprintf(area.province, "");
				m_Conn->Close(db);
				return true;
			}
		}
		else //���7λ�Ŷ�ʧ�ܣ����8λ�Ŷ�
		{
			strncpy(hlrcode, deviceNumber, 8);
			hlrcode[8] = '\0';
			sprintf(query,"select AREA_CODE from BPS_HLR where HLR_CODE = \'%s\'", hlrcode);
			tb = db->Execute(query);
			if(!tb->ISEOF())//���Բ鵽��8λ�Ŷ�������Ϣ
			{
				sprintf(area.prefix, hlrcode);
				tb->Get("AREA_CODE", areacode);
				if (areacode != NULL)
				{
					sprintf(query, "select a.PROV_NAME as PROV_NAME, b.CITY_NAME as CITY_NAME \
							from sys_prov a, sys_city b where a.AREA_CODE=\'%s\' and \
							a.AREA_CODE=b.AREA_CODE", areacode);
					tb = db->Execute(query);
					//��ѯʡ��
					sprintf(query, "");
					tb->Get("PROV_NAME", query);
					sprintf(area.province, query);
					//��ѯ����
					sprintf(query, "");
					tb->Get("CITY_NAME", query);
					sprintf(area.city, query);
					m_Conn->Close(db);
					return true;
				}
				else//�޸�����
				{
					sprintf(area.city, "");
					sprintf(area.province, "");
					m_Conn->Close(db);
					return true;
				}
			}
		}
		//�����ﺯ����û���أ�����7λ��8λ��ѯ��ʧ���ˣ��úŶβ�������
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

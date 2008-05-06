// IDataBase.cpp: implementation of the IDataBase class.
//
//////////////////////////////////////////////////////////////////////
#include "StdAfx.h"
#include "IDataBase.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

IDataBase::IDataBase()
{
	memset(dsnstr,0,sizeof(dsnstr));
}

IDataBase::~IDataBase()
{
	if(m_db.IsOpen ())
		m_db.Close ();
}

//��ִ�в���Ҫ����ֵ��SQL���ʱ����ִ�д˺���
int IDataBase::ExecSqlB(LPCSTR sql)
{
	int ret=SQL_SUCCESS;
	
	if(m_db.IsOpen ())
	{
		TRY
		{
			m_db.ExecuteSQL (sql);
		}
		CATCH(CDBException,e1)
		{
			//char tmp[255];
			//sprintf(tmp,"����ִ��ǰ�޷��������ݿ⣺%s\r\n",e1->m_strError);
			//theApp.SysLog (tmp );
			ret=SQL_ERROR;
    		TRACE("SQLExec����%d����Ϣ��%s\r\n",e1->m_nRetCode ,e1->m_strError);
			TRACE("ErrorSQL:%s\r\n",sql);
		}
		END_CATCH
	}
	else
	{
		m_db.Close ();
		OpenDatabase(NULL);
		ret=SQL_ERROR;
	}
	return ret;
}

// �Լ�¼����ʽִ�д洢���̻�SQL��䣬����
int IDataBase::ExecSqlA(LPCSTR sql,char * rets)
{
//	char tmp[255];
	CString ret,rettmp;
	if(!m_db.IsOpen ())
	{
		OpenDatabase(NULL);
		if(!m_db.IsOpen ())
		{
			*rets=0;
			return SQL_ERROR;
		}
	}
	CRecordset rs(&m_db);
	TRY
	{
		rs.Open(CRecordset::snapshot,sql);
        if(rs.IsEOF ())//�ռ�¼
        {
            *rets=0;
            return SQL_ERROR;
        }
		short i;
		short j=rs.GetODBCFieldCount();
		*rets=0;
		for(i=0;i<j;i++)
		{
			rs.GetFieldValue(i,rettmp);
			if(i==0) //������ж�ȥ����һ������Ŀո�
				ret=rettmp;
			else
				ret=ret+" "+rettmp;
		}
		strncpy(rets, ret,127);//��ֹ����Ĺ�������
	}
	//���ʧ�ܡ���˵�����Ӳ����á���ʱ���½������ӣ������½��в�ѯ����
	CATCH(CDBException,e)
	{
		rs.Close();
		TRACE("ErrorSQL:%s\r\n",sql);
		TRACE("SQLExec����%d����Ϣ��%s\r\n",e->m_nRetCode ,e->m_strError);
		OpenDatabase(NULL);		//����ʲô���������������ݿ⣿
		return SQL_ERROR;
	}
	END_CATCH
	rs.Close ();
	rets[126]=0;
	return SQL_SUCCESS;
}

int IDataBase::OpenDatabase(LPCSTR str)
{
	if(m_db.IsOpen ())
		m_db.Close ();
	TRY
	{
		if(str!=NULL)
			strcpy(dsnstr,str);
		if(strlen(dsnstr)>0)
			m_db.OpenEx(dsnstr);
		else
			return SQL_ERROR;
	}
	CATCH(CDBException,e1)
	{
		TRACE("�����޷������ݿ⣺%s\r\n",e1->m_strError);
		return SQL_ERROR;
	}
	END_CATCH
	return SQL_SUCCESS;
}

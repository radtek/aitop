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

//在执行不需要返回值的SQL语句时可以执行此函数
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
			//sprintf(tmp,"错误！执行前无法连接数据库：%s\r\n",e1->m_strError);
			//theApp.SysLog (tmp );
			ret=SQL_ERROR;
    		TRACE("SQLExec错误%d，信息：%s\r\n",e1->m_nRetCode ,e1->m_strError);
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

// 以记录集方式执行存储过程或SQL语句，返回
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
        if(rs.IsEOF ())//空记录
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
			if(i==0) //用这个判断去除第一个多余的空格
				ret=rettmp;
			else
				ret=ret+" "+rettmp;
		}
		strncpy(rets, ret,127);//防止意外的过长返回
	}
	//如果失败。则说明连接不可用。此时重新建立连接，并重新进行查询尝试
	CATCH(CDBException,e)
	{
		rs.Close();
		TRACE("ErrorSQL:%s\r\n",sql);
		TRACE("SQLExec错误%d，信息：%s\r\n",e->m_nRetCode ,e->m_strError);
		OpenDatabase(NULL);		//无论什么错误都重新连接数据库？
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
		TRACE("错误！无法打开数据库：%s\r\n",e1->m_strError);
		return SQL_ERROR;
	}
	END_CATCH
	return SQL_SUCCESS;
}

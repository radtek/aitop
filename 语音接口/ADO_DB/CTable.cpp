#include "stdafx.h"
#include "CDataBase.h"
#include "CTable.h"

static void ErrorHandler(_com_error &e, char* ErrStr)			
{
	sprintf(ErrStr,"Error:\n");
	sprintf(ErrStr,"%sCode = %08lx\n",ErrStr ,e.Error());
	sprintf(ErrStr,"%sCode meaning = %s\n", ErrStr, (char*) e.ErrorMessage());
	sprintf(ErrStr,"%sSource = %s\n", ErrStr, (char*) e.Source());
	sprintf(ErrStr,"%sDescription = %s",ErrStr, (char*) e.Description());
}

/*
 * Table member_function definition : 16 method totally
 */
CTable::CTable()
{
	m_Rec	   = NULL;
	m_PageSize = -1;
	sprintf(m_ErrStr, "%s", "No Operation");
}

int CTable::ISEOF()
{
	int rs;
	if(m_Rec == NULL)
	{
		sprintf(m_ErrStr, "Invalid Record");
		return -1;
	}
	try
	{
		rs = m_Rec->adoEOF;
	}
	CATCHERROR(m_Rec, -2);
	
	sprintf(m_ErrStr, "Success");
	return rs;
}

HRESULT CTable::MoveNext()
{
	HRESULT hr;
	try
	{
		hr = m_Rec->MoveNext();
	}
	catch(_com_error &e)
	{
		ErrorHandler(e, m_ErrStr);
		return -2;					// -2 instead of error
	}
	
	sprintf(m_ErrStr,"Success");
	return hr;
}

HRESULT CTable::MovePrevious()
{
	HRESULT hr;
	try
	{
		hr = m_Rec->MovePrevious();
	}
	catch(_com_error &e)
	{
		ErrorHandler(e, m_ErrStr);
		return -2;					// -2 instead of error
	}
	
	sprintf(m_ErrStr,"Success");
	return hr;
}

HRESULT CTable::MoveFirst()
{
	HRESULT hr;
	try
	{
		hr = m_Rec->MoveFirst();
	}
	catch(_com_error &e)
	{
		ErrorHandler(e, m_ErrStr);
		return -2;					// -2 instead of error
	}
	
	sprintf(m_ErrStr,"Success");
	return hr;
}

HRESULT CTable::MoveLast()
{
	HRESULT hr;
	try
	{
		hr = m_Rec->MoveLast();
	}
	catch(_com_error &e)
	{
		ErrorHandler(e, m_ErrStr);
		return -2;					// -2 instead of error
	}
	
	sprintf(m_ErrStr,"Success");
	return hr;
}

BOOL CTable::Move(int index)
{
	if (index == 0)
		return TRUE;
	try
	{
		m_Rec->Move(index);
	}
	catch(_com_error &e)
	{
		sprintf(m_ErrStr, "%s", e.ErrorMessage());
		return FALSE;					// -2 instead of error
	}
	
	sprintf(m_ErrStr,"Success");
	return TRUE;
}

BOOL CTable::SetPageSize(int size)
{
	if (m_Rec == NULL)
		return FALSE;
	if (GetRecordCount() < size)
		return FALSE;
	
	m_PageSize = size;
	
	return TRUE;
}

int CTable::GetRecordCount()
{
	if (m_Rec == NULL)
		return 0;
	
	int ret = 0;
	int temp = 0;
	try
	{
		while(!ISEOF())
		{
			ret++;
			MoveNext();
		}
		MoveFirst();
		while (!ISEOF())
		{
			temp++;
			MoveNext();
		}
		MoveFirst();
		Move(temp - ret);
	}
	catch(_com_error &e)
	{
		sprintf(m_ErrStr, "%s", e.ErrorMessage());
		return -1;					// -1 instead of error
	}
	
	return temp;
}

const char* CTable::GetErrorStr()
{
	return m_ErrStr;
}

BOOL CTable::Get(char* FieldName,long& FieldValue)		//未实现		
{
	return TRUE;
}

BOOL CTable::Get(char* FieldName,double& FieldValue,int Scale)		//未实现
{
	return TRUE;
}


BOOL CTable::Get(char* FieldName,double& FieldValue)
{
	try
	{
		_variant_t  vtValue;
		vtValue = m_Rec->Fields->GetItem(FieldName)->GetValue();
		if (vtValue.vt == VT_NULL)
		{
			FieldValue = 0;
			return TRUE;
		}
		VariantChangeType(&vtValue,&vtValue,0, VT_R8);
		FieldValue = vtValue.dblVal;
	}
	CATCHERRGET
		
	sprintf(m_ErrStr,"Success");
	return 1;
}

BOOL CTable::Get(char* FieldName,float& FieldValue)
{
	try
	{
		_variant_t  vtValue;
		vtValue = m_Rec->Fields->GetItem(FieldName)->GetValue();
		if (vtValue.vt == VT_NULL)
		{
			FieldValue = 0;
			return TRUE;
		}
		VariantChangeType(&vtValue,&vtValue,0, VT_R4);
		FieldValue=vtValue.fltVal;
	}
	CATCHERRGET;
		
	sprintf(m_ErrStr,"Success");
	return TRUE;
}

BOOL CTable::Get(char* FieldName,int& FieldValue)
{
	try
	{
		_variant_t  vtValue;
		vtValue = m_Rec->Fields->GetItem(FieldName)->GetValue();
		if (vtValue.vt == VT_NULL)
		{
			FieldValue = 0;
			return TRUE;
		}
		VariantChangeType(&vtValue,&vtValue,0, VT_I4);
		FieldValue = vtValue.intVal;
	}
	CATCHERRGET;
	
	sprintf(m_ErrStr,"Success");
	return TRUE;
}

BOOL CTable::Get(char* FieldName, char* FieldValue)
{
	try
	{
		_variant_t  vtValue;
		vtValue = m_Rec->Fields->GetItem(FieldName)->GetValue();
		if (vtValue.vt == VT_NULL)
		{
			sprintf((char *)FieldValue , "");
			return TRUE;
		}
		VariantChangeType(&vtValue,&vtValue,0, VT_BYREF|VT_BSTR);
		sprintf(FieldValue,"%s",(LPCSTR)((_bstr_t)vtValue.bstrVal));
	}
	CATCHERRGET;
		
	sprintf(m_ErrStr,"Success");
	return TRUE;
}

/*BOOL CTable::Get(long FieldNum, int& FieldValue)
{
	try
	{
		_variant_t  vtValue;
		vtValue = m_Rec->Fields->Item[_variant_t(FieldNum)]->Value;
		if (vtValue.vt == VT_NULL)
		{
			FieldValue = 0;
			return TRUE;
		}
		VariantChangeType(&vtValue,&vtValue,0, VT_I4);
		FieldValue = vtValue.intVal;
	}
	CATCHERRGET;
	
	sprintf(m_ErrStr,"Success");
	return TRUE;
}

BOOL CTable::Get(long FieldNum, double& FieldValue,int Scale)
{
	return TRUE;
}

BOOL CTable::Get(long FieldNum, double& FieldValue)
{
	try
	{
		_variant_t  vtValue;
		vtValue = m_Rec->Fields->Item[_variant_t(FieldNum)]->Value;
		if (vtValue.vt == VT_NULL)
		{
			FieldValue = 0;
			return TRUE;
		}
		VariantChangeType(&vtValue,&vtValue,0, VT_R8);
		FieldValue = vtValue.dblVal;
	}
	CATCHERRGET;
	
	sprintf(m_ErrStr,"Success");
	return TRUE;
}

BOOL CTable::Get(long FieldNum, float& FieldValue)
{
	try
	{
		_variant_t  vtValue;
		vtValue = m_Rec->Fields->Item[_variant_t(FieldNum)]->Value;
		if (vtValue.vt == VT_NULL)
		{
			FieldValue = 0;
			return TRUE;
		}
		VariantChangeType(&vtValue,&vtValue,0, VT_R4);
		FieldValue = vtValue.fltVal;
	}
	CATCHERRGET;
	
	sprintf(m_ErrStr,"Success");
	return TRUE;
}

BOOL CTable::Get(long FieldNum, char* FieldValue)
{
	try
	{
		_variant_t  vtValue;
		vtValue = m_Rec->Fields->Item[_variant_t(FieldNum)]->Value;
		if (vtValue.vt == VT_NULL)
		{
			sprintf((char *)FieldValue , "");
			return TRUE;
		}
		VariantChangeType(&vtValue,&vtValue,0, VT_BYREF|VT_BSTR);
		sprintf(FieldValue,"%s",(LPCSTR)((_bstr_t)vtValue.bstrVal));
	}
	CATCHERRGET;
	
	sprintf(m_ErrStr,"Success");
	return TRUE;
}

BOOL CTable::Get(long FieldNum, long& FieldValue)
{
	return TRUE;
}*/

void CTable::Close()
{
	if (m_Rec)
	{
		m_Rec->Close();
	}
}
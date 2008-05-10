#include "StdAfx.h"
#include "DBExportFunctions.h"

#include "IDataBase.h"
IDataBase g_db;
LPCSTR openDatabase(const char *argv)
{
	if(g_db.OpenDatabase(argv)==SQL_SUCCESS)
		return "1";
	else
		return "0";
}

LPCSTR execSqlA(const char *argv)
{
	int ret;
	static char res[128];
	ret=g_db.ExecSqlA(argv,res);
	if(ret==SQL_SUCCESS)
		return res;
	else
		return "0";
}

LPCSTR execSqlB(const char *argv)
{
	int ret;
	ret=g_db.ExecSqlB(argv);
	if(ret==SQL_SUCCESS)
		return "1";
	else
		return "0";
}

//not export function
CString ReadReg(LPCTSTR Key,LPCTSTR REG="SOFTWARE\\KunLun",HKEY hKey =HKEY_LOCAL_MACHINE)
{
	HKEY hVersion;
	long key;
	CString szText;
	key=::RegOpenKeyEx(hKey, REG, 0, KEY_READ, &hVersion);
	if(key==ERROR_SUCCESS)
	{
		unsigned long dwType, dwBytes=MAX_PATH;
		BYTE str[MAX_PATH];
		key=::RegQueryValueEx(hVersion, Key, 0, &dwType, str , &dwBytes);
		if(key!=ERROR_SUCCESS)
		{
			LPVOID lpMsgBuf;
			if (!FormatMessage( 
				FORMAT_MESSAGE_ALLOCATE_BUFFER | 
				FORMAT_MESSAGE_FROM_SYSTEM | 
				FORMAT_MESSAGE_IGNORE_INSERTS,
				NULL,
				key,
				MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), // Default language
				(LPTSTR) &lpMsgBuf,
				0,
				NULL ))
			{
				// Handle the error.
				return "";
			}
			// Display the string.
			TRACE( "·ÃÎÊ×¢²á±í%s\\%s´íÎó£º%s\n",REG,Key, (LPCTSTR)lpMsgBuf);
			// Free the buffer.
			LocalFree( lpMsgBuf );
			::RegCloseKey(hVersion);
			return "";
		}
		szText=str;
		::RegCloseKey(hVersion);
	}
	else
	{
		LPVOID lpMsgBuf;
		if (!FormatMessage( 
			FORMAT_MESSAGE_ALLOCATE_BUFFER | 
			FORMAT_MESSAGE_FROM_SYSTEM | 
			FORMAT_MESSAGE_IGNORE_INSERTS,
			NULL,
			key,
			MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), // Default language
			(LPTSTR) &lpMsgBuf,
			0,
			NULL ))
		{
			// Handle the error.
			return "";
		}
		// Display the string.
		TRACE( "·ÃÎÊ×¢²á±í%s\\%s´íÎó£º%s\n",REG,Key, (LPCTSTR)lpMsgBuf);
		// Free the buffer.
		LocalFree( lpMsgBuf );
		::RegCloseKey(hVersion);
		return "";
	}
	return szText;
}


LPCSTR readreg(const char *argv,LPCTSTR REG,HKEY hKey)
{
    static char vstr[128];
	CString tmp=ReadReg(argv,REG,hKey);
	int i=tmp.GetLength ();
	if(i>127)
	{
		strncpy(vstr,tmp,127);
		vstr[127]=0;
	}
	else
		strcpy(vstr,tmp);
	return vstr;
}

BOOL writereg(LPCTSTR Key,LPCTSTR Value,LPCTSTR REG /*= "SOFTWARE\\KunLun"*/,HKEY hKey /*=HKEY_LOCAL_MACHINE*/)
{
	//HKEY_LOCAL_MACHINE\SOFTWARE\KunLun 
	HKEY hVersion;
	long key;
	DWORD dwPos;
	key=::RegCreateKeyEx(hKey,REG , 
		0, NULL, REG_OPTION_NON_VOLATILE,KEY_WRITE, NULL,&hVersion,&dwPos);
	if(key==ERROR_SUCCESS)
	{
		unsigned long dwType=REG_SZ, dwBytes=(unsigned long)strlen(Value)+1;
		key=::RegSetValueEx(hVersion,Key,
			0,dwType,(CONST BYTE *)Value,dwBytes);
		if(key!=ERROR_SUCCESS)
		{
			LPVOID lpMsgBuf;
			if (!FormatMessage( 
				FORMAT_MESSAGE_ALLOCATE_BUFFER | 
				FORMAT_MESSAGE_FROM_SYSTEM | 
				FORMAT_MESSAGE_IGNORE_INSERTS,
				NULL,
				key,
				MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), // Default language
				(LPTSTR) &lpMsgBuf,
				0,
				NULL ))
			{
				// Handle the error.
				return FALSE;
			}
			// Display the string.
			TRACE( "·ÃÎÊ×¢²á±í%s\\%s´íÎó£º%s\n",REG,Key, (LPCTSTR)lpMsgBuf);
			// Free the buffer.
			LocalFree( lpMsgBuf );
			::RegCloseKey(hVersion);
			return FALSE;
		}
		::RegCloseKey(hVersion);
	} else
	{
		LPVOID lpMsgBuf;
		if (!FormatMessage( 
			FORMAT_MESSAGE_ALLOCATE_BUFFER | 
			FORMAT_MESSAGE_FROM_SYSTEM | 
			FORMAT_MESSAGE_IGNORE_INSERTS,
			NULL,
			key,
			MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), // Default language
			(LPTSTR) &lpMsgBuf,
			0,
			NULL ))
		{
			// Handle the error.
			return FALSE;
		}
		// Display the string.
		TRACE( "·ÃÎÊ×¢²á±í%s\\%s´íÎó£º%s\n",REG,Key, (LPCTSTR)lpMsgBuf);
		// Free the buffer.
		LocalFree( lpMsgBuf );
		::RegCloseKey(hVersion);
		return FALSE;
	}
	return TRUE;
}
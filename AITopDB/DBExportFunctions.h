#ifndef __DB_EXPORT_FUNCTIONS__
#define __DB_EXPORT_FUNCTIONS__
#include <iostream>
#include <string>

#ifdef _AITOPDB_DLL
 __declspec(dllexport) LPCSTR openDatabase(const char *argv);
 __declspec(dllexport) LPCSTR execSqlA(const char *argv);
 __declspec(dllexport) LPCSTR execSqlB(const char *argv);
 __declspec(dllexport) LPCSTR readreg(const char *argv,LPCTSTR REG="SOFTWARE\\KunLun",HKEY hKey =HKEY_LOCAL_MACHINE);
 __declspec(dllexport) BOOL writereg(LPCTSTR Key,LPCTSTR Value,LPCTSTR REG="SOFTWARE\\KunLun",HKEY hKey =HKEY_LOCAL_MACHINE);
 __declspec(dllexport) std::string trimString(std::string str1,std::string str2);
#else
#pragma comment(lib,"aitopdb.lib")
 LPCSTR openDatabase(const char *argv);
 LPCSTR execSqlA(const char *argv);
 LPCSTR execSqlB(const char *argv);
 LPCSTR readreg(const char *argv,LPCTSTR REG="SOFTWARE\\KunLun",HKEY hKey =HKEY_LOCAL_MACHINE);
 BOOL writereg(LPCTSTR Key,LPCTSTR Value,LPCTSTR REG="SOFTWARE\\KunLun",HKEY hKey =HKEY_LOCAL_MACHINE);
 std::string trimString(std::string str1,std::string str2);
#endif

#endif
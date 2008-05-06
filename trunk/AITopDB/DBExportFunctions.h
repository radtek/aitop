#ifndef __DB_EXPORT_FUNCTIONS__
#define __DB_EXPORT_FUNCTIONS__

#ifdef _AITOPDB_DLL
 __declspec(dllexport) LPCSTR openDatabase(const char *argv);
 __declspec(dllexport) LPCSTR execSqlA(const char *argv);
 __declspec(dllexport) LPCSTR execSqlB(const char *argv);
 __declspec(dllexport) LPCSTR readreg(const char *argv);
#else
#pragma comment(lib,"aitopdb.lib")
 LPCSTR openDatabase(const char *argv);
 LPCSTR execSqlA(const char *argv);
 LPCSTR execSqlB(const char *argv);
 LPCSTR readreg(const char *argv);
#endif

#endif
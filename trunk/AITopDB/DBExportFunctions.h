#ifndef __DB_EXPORT_FUNCTIONS__
#define __DB_EXPORT_FUNCTIONS__
 
#ifdef _WINDLL
 __declspec(dllexport) LPCSTR openDatabase(char *argv);
 __declspec(dllexport) LPCSTR execSqlA(char *argv);
 __declspec(dllexport) LPCSTR execSqlB(char *argv);
 __declspec(dllexport) LPCSTR readreg(char *argv);
#else
#pragma comment(lib,"aitopdb.lib")
 LPCSTR openDatabase(char *argv);
 LPCSTR execSqlA(char *argv);
 LPCSTR execSqlB(char *argv);
 LPCSTR readreg(char *argv);
#endif

#endif
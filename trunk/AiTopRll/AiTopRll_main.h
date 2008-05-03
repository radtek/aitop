#include "log.h"
#define RLL_VER		__DATE__
#define RLL_SUB_VER	__TIME__
extern CLog g_log(NULL);

#pragma comment(lib,"aitopdb.lib")
LPCSTR openDatabase(char *argv);
LPCSTR execSqlA(char *argv);
LPCSTR execSqlB(char *argv);
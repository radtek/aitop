#include "log.h"
#define RLL_VER		__DATE__
#define RLL_SUB_VER	__TIME__
extern CLog g_log(NULL);
#include <string>

using namespace std;

#pragma comment(lib,"services.lib")
#include "../wjg/Services/Server.h"
#pragma comment(lib,"aitopdb.lib")
#include "../AITopDB/DBExportFunctions.h"


void string_replace(std::string &strBig, const std::string &strsrc, const std::string &strdst);
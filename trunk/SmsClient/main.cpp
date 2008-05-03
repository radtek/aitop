#include "soapStub.h"
#include "sendsmsservicesoapbinding.nsmap"
#include "soapSendSmsServiceSoapBindingProxy.h"
int main(int argc,char *argv[])
{
	SendSmsServiceSoapBinding objProxy;
	int ret;
	soap_init(objProxy.soap); // 初始化运行环境（只执行一次）
	objProxy.ns1__send(0,0,"usernumber",0,ret);
	objProxy.ns1__send_(0,0,"usernumber",0,ret);
	objProxy.ns1__sendFailed(0,0,"usernumber","content",ret);
	return 0; 
}
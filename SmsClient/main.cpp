#include "soapStub.h"
#include "sendsmsservicesoapbinding.nsmap"
#include "soapSendSmsServiceSoapBindingProxy.h"
int main(int argc,char *argv[])
{
	SendSmsServiceSoapBinding objProxy;
	int ret;
	soap_init(objProxy.soap); // ��ʼ�����л�����ִֻ��һ�Σ�
	objProxy.ns1__send(0,0,"usernumber",0,ret);
	objProxy.ns1__send_(0,0,"usernumber",0,ret);
	objProxy.ns1__sendFailed(0,0,"usernumber","content",ret);
	return 0; 
}
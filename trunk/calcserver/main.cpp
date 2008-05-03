#include "soapH.h"
#include "calc.nsmap"
#include "soapcalcObject.h"
int main(int argc,char *argv[])
{
	calcService mysoap;
	soap_init(&mysoap);
	mysoap.bind("127.0.0.1",80,5);
	while(1)
	{
		if(mysoap.accept()!=SOAP_INVALID_SOCKET)
		{
			printf("accept()!\r\n");
			mysoap.serve();
		}
		Sleep(10);
	}
	return 0;
}


SOAP_FMAC5 int SOAP_FMAC6 ns2__add(struct soap*, double a, double b, double &result)
{
	printf("ns2__add() is called!\r\n");
	result=a+b;
	return 0;
}

SOAP_FMAC5 int SOAP_FMAC6 ns2__sub(struct soap*, double a, double b, double &result)
{
	printf("ns2__sub() is called!\r\n");
	result=a-b;
	return 0;
}

SOAP_FMAC5 int SOAP_FMAC6 ns2__mul(struct soap*, double a, double b, double &result)
{
	printf("ns2__mul() is called!\r\n");
	result=a*b;
	return 0;
}
SOAP_FMAC5 int SOAP_FMAC6 ns2__div(struct soap*, double a, double b, double &result)
{
	printf("ns2__div() is called!\r\n");
	result=a/b;
	return 0;
}
SOAP_FMAC5 int SOAP_FMAC6 ns2__pow(struct soap*, double a, double b, double &result)
{
	printf("ns2__pow() is called!\r\n");
	result=pow(a,b);
	return 0;
}
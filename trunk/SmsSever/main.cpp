
#include "soaph.h"
#include "sendsmsservicesoapbinding.nsmap"
#include "stdsoap2.h"
#include "soapSendSmsServiceSoapBindingObject.h"
int main(int argc,char*argv[])
{
	int m, s; /* master and slave sockets */
	SendSmsServiceSoapBindingService mysoap;
	soap_init(&mysoap);
	soap_set_namespaces(&mysoap, mysoap.namespaces);
	if (argc < 2)
	{
		printf("usage: %s <server_port> \n", argv[0]);
		exit(1);
	}
	else
	{ 
		m = soap_bind(&mysoap, NULL, atoi(argv[1]), 100);
		if (m < 0)
		{
			soap_print_fault(&mysoap, stderr);
			exit(-1);
		}
		fprintf(stderr, "Socket connection successful: master socket = %d\n", m);
		for ( ; ; )
		{ 
			s = soap_accept(&mysoap); 
			if (s < 0)
			{ 
				soap_print_fault(&mysoap, stderr);
				exit(-1);
			}
			fprintf(stderr, "Socket connection successful: slave socket = %d\n", s);
			mysoap.serve();
			soap_end(&mysoap);
		}
	}
	return 0;
}

SOAP_FMAC5 int SOAP_FMAC6 ns1__send(struct soap*, int _cp_USCOREid, int _serviceid, char *_usernumber, int _timelen, int &_sendReturn)
{
	printf("ns1__send() is called!\r\n");
	return 0;
}

SOAP_FMAC5 int SOAP_FMAC6 ns1__send_(struct soap*, int _cp_USCOREid, int _serviceid, char *_usernumber, int _timelen, int &_sendReturn)
{
	printf("ns1__send_() is called!\r\n");
	return 0;
}

SOAP_FMAC5 int SOAP_FMAC6 ns1__sendFailed(struct soap*, int _cp_USCOREid, int _serviceid, char *_usernumber, char *_content, int &_sendFailedReturn)
{
	printf("ns1__sendFailed() is called!\r\n");
	return 0;
}


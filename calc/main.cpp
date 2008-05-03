#include "soapH.h"
#include "calc.nsmap"

int main(int argc,char *argv[])
{
	struct soap *soap = soap_new();
	int a, b;
	double result;
	printf("main()\r\n");
	if(argc > 3 )
	{ a = atoi(argv[1]);
    b = atoi(argv[3]);
	}
	else
	{
		printf("Argument is less %s %s \r\n",argv[1],argv[2]);
		return -1;
	}
	printf("Prepare call %s%s%s\r\n",argv[1],argv[2],argv[3]);

	switch (*argv[2]) {
	case '+':
//		if(soap_call_ns2__add(soap, "http://websrv.cs.fsu.edu/~engelen/calcserver.cgi", NULL, a, b, result) == 0)
		if(soap_call_ns2__add(soap, "http://127.0.0.1/calcserver.cgi", NULL, a, b, result) == 0)
			printf("%d+%d=%f\n", a, b, result);
		else
			soap_print_fault(soap, stderr);
		break;
	case '-':
		if(soap_call_ns2__sub(soap, "http://127.0.0.1/calcserver.cgi", NULL, a, b, result) == 0)
			printf("%d-%d=%f\n", a, b, result);
		else
			soap_print_fault(soap, stderr);
		break;
	case '*':
		if(soap_call_ns2__mul(soap, "http://127.0.0.1/calcserver.cgi", NULL, a, b, result) == 0)
			printf("%d*%d=%f\n", a, b, result);
		else
			soap_print_fault(soap, stderr);
		break;
	case '/':
		if(soap_call_ns2__div(soap, "http://127.0.0.1/calcserver.cgi", NULL, a, b, result) == 0)
			printf("%d/%d=%f\n", a, b, result);
		else
			soap_print_fault(soap, stderr);
		break;
	case '^':
		if(soap_call_ns2__pow(soap, "http://127.0.0.1/calcserver.cgi", NULL, a, b, result) == 0)
			printf("%d^%d=%f\n", a, b, result);
		else
			soap_print_fault(soap, stderr);
		break;
	default:
		printf("method [%c] can't execute!\r\n",*argv[2]);
	}

	return 0;
}

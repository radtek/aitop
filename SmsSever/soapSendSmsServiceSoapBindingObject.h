/* soapSendSmsServiceSoapBindingObject.h
   Generated by gSOAP 2.7.10 from aiwsdl1.txt.h
   Copyright(C) 2000-2008, Robert van Engelen, Genivia Inc. All Rights Reserved.
   This part of the software is released under one of the following licenses:
   GPL, the gSOAP public license, or Genivia's license for commercial use.
*/

#ifndef soapSendSmsServiceSoapBindingObject_H
#define soapSendSmsServiceSoapBindingObject_H
#include "soapH.h"

/******************************************************************************\
 *                                                                            *
 * Service Object                                                             *
 *                                                                            *
\******************************************************************************/

class SendSmsServiceSoapBindingService : public soap
{    public:
	SendSmsServiceSoapBindingService()
	{ static const struct Namespace namespaces[] =
{
	{"SOAP-ENV", "http://schemas.xmlsoap.org/soap/envelope/", "http://www.w3.org/*/soap-envelope", NULL},
	{"SOAP-ENC", "http://schemas.xmlsoap.org/soap/encoding/", "http://www.w3.org/*/soap-encoding", NULL},
	{"xsi", "http://www.w3.org/2001/XMLSchema-instance", "http://www.w3.org/*/XMLSchema-instance", NULL},
	{"xsd", "http://www.w3.org/2001/XMLSchema", "http://www.w3.org/*/XMLSchema", NULL},
	{"ns1", "http://127.0.0.1", NULL, NULL},
	{NULL, NULL, NULL, NULL}
};
	if (!this->namespaces) this->namespaces = namespaces; };
	virtual ~SendSmsServiceSoapBindingService() { };
	/// Bind service to port (returns master socket or SOAP_INVALID_SOCKET)
	virtual	SOAP_SOCKET bind(const char *host, int port, int backlog) { return soap_bind(this, host, port, backlog); };
	/// Accept next request (returns socket or SOAP_INVALID_SOCKET)
	virtual	SOAP_SOCKET accept() { return soap_accept(this); };
	/// Serve this request (returns error code or SOAP_OK)
	virtual	int serve() { return soap_serve(this); };
};

/******************************************************************************\
 *                                                                            *
 * Service Operations (you should define these globally)                      *
 *                                                                            *
\******************************************************************************/


SOAP_FMAC5 int SOAP_FMAC6 ns1__send(struct soap*, int _cp_USCOREid, int _serviceid, char *_usernumber, int _timelen, int &_sendReturn);

SOAP_FMAC5 int SOAP_FMAC6 ns1__send_(struct soap*, int _cp_USCOREid, int _serviceid, char *_usernumber, int _timelen, int &_sendReturn);

SOAP_FMAC5 int SOAP_FMAC6 ns1__sendFailed(struct soap*, int _cp_USCOREid, int _serviceid, char *_usernumber, char *_content, int &_sendFailedReturn);

#endif

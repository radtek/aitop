/* aitop.h
   Generated by wsdl2h 1.2.10 from http://220.194.56.196:9058/calldownsms/services/SendSmsService?wsdl and typemap.dat
   2008-05-22 13:33:55 GMT
   Copyright (C) 2001-2008 Robert van Engelen, Genivia Inc. All Rights Reserved.
   This part of the software is released under one of the following licenses:
   GPL or Genivia's license for commercial use.
*/

/* NOTE:

 - Compile this file with soapcpp2 to complete the code generation process.
 - Use soapcpp2 option -I to specify paths for #import
   To build with STL, 'stlvector.h' is imported from 'import' dir in package.
 - Use wsdl2h options -c and -s to generate pure C code or C++ code without STL.
 - Use 'WS/typemap.dat' to control namespace bindings and type mappings.
   It is strongly recommended to customize the names of the namespace prefixes
   generated by wsdl2h. To do so, modify the prefix bindings in the Namespaces
   section below and add the modified lines to 'typemap.dat' to rerun wsdl2h.
 - Use Doxygen (www.doxygen.org) to browse this file.
 - Use wsdl2h option -l to view the software license terms.

   DO NOT include this file directly into your project.
   Include only the soapcpp2-generated headers and source code files.
*/

//gsoapopt w

/******************************************************************************\
 *                                                                            *
 * http://service.asiainfo.com                                                *
 *                                                                            *
\******************************************************************************/


/******************************************************************************\
 *                                                                            *
 * Import                                                                     *
 *                                                                            *
\******************************************************************************/


/******************************************************************************\
 *                                                                            *
 * Schema Namespaces                                                          *
 *                                                                            *
\******************************************************************************/


/******************************************************************************\
 *                                                                            *
 * Schema Types                                                               *
 *                                                                            *
\******************************************************************************/


/******************************************************************************\
 *                                                                            *
 * Services                                                                   *
 *                                                                            *
\******************************************************************************/


//gsoap ns1  service name:	SendSmsServiceSoapBinding 
//gsoap ns1  service type:	SendSmsService 
//gsoap ns1  service port:	http://220.194.56.196:9058/calldownsms/services/SendSmsService 
//gsoap ns1  service namespace:	http://service.asiainfo.com 
//gsoap ns1  service transport:	http://schemas.xmlsoap.org/soap/http 

/** @mainpage Service Definitions

@section Service_bindings Bindings
  - @ref SendSmsServiceSoapBinding

*/

/**

@page SendSmsServiceSoapBinding Binding "SendSmsServiceSoapBinding"

@section SendSmsServiceSoapBinding_operations Operations of Binding  "SendSmsServiceSoapBinding"
  - @ref ns1__send
  - @ref ns1__send_
  - @ref ns1__send__
  - @ref ns1__sendFailed
  - @ref ns1__sendnote

@section SendSmsServiceSoapBinding_ports Endpoints of Binding  "SendSmsServiceSoapBinding"
  - http://220.194.56.196:9058/calldownsms/services/SendSmsService

Note: use wsdl2h option -N to change the service binding prefix name

*/

/******************************************************************************\
 *                                                                            *
 * SendSmsServiceSoapBinding                                                  *
 *                                                                            *
\******************************************************************************/


/******************************************************************************\
 *                                                                            *
 * ns1__send                                                                  *
 *                                                                            *
\******************************************************************************/


/// Operation "ns1__send" of service binding "SendSmsServiceSoapBinding"

/**

Operation details:

  - SOAP RPC encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"

C stub function (defined in soapClient.c[pp] generated by soapcpp2):
@code
  int soap_call_ns1__send(
    struct soap *soap,
    NULL, // char *endpoint = NULL selects default endpoint for this operation
    NULL, // char *action = NULL selects default action for this operation
    // request parameters:
    int                                 cp_USCOREid,
    int                                 serviceid,
    char*                               usernumber,
    int                                 timelen,
    char*                               content,
    // response parameters:
    int                                &_sendReturn
  );
@endcode

C server function (called from the service dispatcher defined in soapServer.c[pp]):
@code
  int ns1__send(
    struct soap *soap,
    // request parameters:
    int                                 cp_USCOREid,
    int                                 serviceid,
    char*                               usernumber,
    int                                 timelen,
    char*                               content,
    // response parameters:
    int                                &_sendReturn
  );
@endcode

C++ proxy class (defined in soapSendSmsServiceSoapBindingProxy.h):
  class SendSmsServiceSoapBinding;

Note: use soapcpp2 option '-i' to generate improved proxy and service classes;

*/

//gsoap ns1  service method-style:	send rpc
//gsoap ns1  service method-encoding:	send http://schemas.xmlsoap.org/soap/encoding/
//gsoap ns1  service method-action:	send ""
int ns1__send(
    int                                 _cp_USCOREid,	///< Request parameter
    int                                 _serviceid,	///< Request parameter
    char*                               _usernumber,	///< Request parameter
    int                                 _timelen,	///< Request parameter
    char*                               _content,	///< Request parameter
    int                                &_sendReturn	///< Response parameter
);

/******************************************************************************\
 *                                                                            *
 * ns1__send_                                                                 *
 *                                                                            *
\******************************************************************************/


/// Operation "ns1__send_" of service binding "SendSmsServiceSoapBinding"

/**

Operation details:

  - SOAP RPC encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"

C stub function (defined in soapClient.c[pp] generated by soapcpp2):
@code
  int soap_call_ns1__send_(
    struct soap *soap,
    NULL, // char *endpoint = NULL selects default endpoint for this operation
    NULL, // char *action = NULL selects default action for this operation
    // request parameters:
    int                                 cp_USCOREid,
    int                                 serviceid,
    char*                               usernumber,
    int                                 timelen,
    char*                               content,
    // response parameters:
    int                                &_sendReturn
  );
@endcode

C server function (called from the service dispatcher defined in soapServer.c[pp]):
@code
  int ns1__send_(
    struct soap *soap,
    // request parameters:
    int                                 cp_USCOREid,
    int                                 serviceid,
    char*                               usernumber,
    int                                 timelen,
    char*                               content,
    // response parameters:
    int                                &_sendReturn
  );
@endcode

C++ proxy class (defined in soapSendSmsServiceSoapBindingProxy.h):
  class SendSmsServiceSoapBinding;

Note: use soapcpp2 option '-i' to generate improved proxy and service classes;

*/

//gsoap ns1  service method-style:	send_ rpc
//gsoap ns1  service method-encoding:	send_ http://schemas.xmlsoap.org/soap/encoding/
//gsoap ns1  service method-action:	send_ ""
int ns1__send_(
    int                                 _cp_USCOREid,	///< Request parameter
    int                                 _serviceid,	///< Request parameter
    char*                               _usernumber,	///< Request parameter
    int                                 _timelen,	///< Request parameter
    char*                               _content,	///< Request parameter
    int                                &_sendReturn	///< Response parameter
);

/******************************************************************************\
 *                                                                            *
 * ns1__send__                                                                *
 *                                                                            *
\******************************************************************************/


/// Operation "ns1__send__" of service binding "SendSmsServiceSoapBinding"

/**

Operation details:

  - SOAP RPC encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"

C stub function (defined in soapClient.c[pp] generated by soapcpp2):
@code
  int soap_call_ns1__send__(
    struct soap *soap,
    NULL, // char *endpoint = NULL selects default endpoint for this operation
    NULL, // char *action = NULL selects default action for this operation
    // request parameters:
    int                                 cp_USCOREid,
    int                                 serviceid,
    char*                               usernumber,
    int                                 timelen,
    char*                               content,
    // response parameters:
    int                                &_sendReturn
  );
@endcode

C server function (called from the service dispatcher defined in soapServer.c[pp]):
@code
  int ns1__send__(
    struct soap *soap,
    // request parameters:
    int                                 cp_USCOREid,
    int                                 serviceid,
    char*                               usernumber,
    int                                 timelen,
    char*                               content,
    // response parameters:
    int                                &_sendReturn
  );
@endcode

C++ proxy class (defined in soapSendSmsServiceSoapBindingProxy.h):
  class SendSmsServiceSoapBinding;

Note: use soapcpp2 option '-i' to generate improved proxy and service classes;

*/

//gsoap ns1  service method-style:	send__ rpc
//gsoap ns1  service method-encoding:	send__ http://schemas.xmlsoap.org/soap/encoding/
//gsoap ns1  service method-action:	send__ ""
int ns1__send__(
    int                                 _cp_USCOREid,	///< Request parameter
    int                                 _serviceid,	///< Request parameter
    char*                               _usernumber,	///< Request parameter
    int                                 _timelen,	///< Request parameter
    char*                               _content,	///< Request parameter
    int                                &_sendReturn	///< Response parameter
);

/******************************************************************************\
 *                                                                            *
 * ns1__sendFailed                                                            *
 *                                                                            *
\******************************************************************************/


/// Operation "ns1__sendFailed" of service binding "SendSmsServiceSoapBinding"

/**

Operation details:

  - SOAP RPC encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"

C stub function (defined in soapClient.c[pp] generated by soapcpp2):
@code
  int soap_call_ns1__sendFailed(
    struct soap *soap,
    NULL, // char *endpoint = NULL selects default endpoint for this operation
    NULL, // char *action = NULL selects default action for this operation
    // request parameters:
    int                                 cp_USCOREid,
    int                                 serviceid,
    char*                               usernumber,
    char*                               content,
    // response parameters:
    int                                &_sendFailedReturn
  );
@endcode

C server function (called from the service dispatcher defined in soapServer.c[pp]):
@code
  int ns1__sendFailed(
    struct soap *soap,
    // request parameters:
    int                                 cp_USCOREid,
    int                                 serviceid,
    char*                               usernumber,
    char*                               content,
    // response parameters:
    int                                &_sendFailedReturn
  );
@endcode

C++ proxy class (defined in soapSendSmsServiceSoapBindingProxy.h):
  class SendSmsServiceSoapBinding;

Note: use soapcpp2 option '-i' to generate improved proxy and service classes;

*/

//gsoap ns1  service method-style:	sendFailed rpc
//gsoap ns1  service method-encoding:	sendFailed http://schemas.xmlsoap.org/soap/encoding/
//gsoap ns1  service method-action:	sendFailed ""
int ns1__sendFailed(
    int                                 _cp_USCOREid,	///< Request parameter
    int                                 _serviceid,	///< Request parameter
    char*                               _usernumber,	///< Request parameter
    char*                               _content,	///< Request parameter
    int                                &_sendFailedReturn	///< Response parameter
);

/******************************************************************************\
 *                                                                            *
 * ns1__sendnote                                                              *
 *                                                                            *
\******************************************************************************/


/// Operation "ns1__sendnote" of service binding "SendSmsServiceSoapBinding"

/**

Operation details:

  - SOAP RPC encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"

C stub function (defined in soapClient.c[pp] generated by soapcpp2):
@code
  int soap_call_ns1__sendnote(
    struct soap *soap,
    NULL, // char *endpoint = NULL selects default endpoint for this operation
    NULL, // char *action = NULL selects default action for this operation
    // request parameters:
    char*                               typeName,
    int                                 spID,
    int                                 serviceID,
    char*                               userNumber,
    int                                 rank,
    char*                               snumber,
    // response parameters:
    int                                &_sendnoteReturn
  );
@endcode

C server function (called from the service dispatcher defined in soapServer.c[pp]):
@code
  int ns1__sendnote(
    struct soap *soap,
    // request parameters:
    char*                               typeName,
    int                                 spID,
    int                                 serviceID,
    char*                               userNumber,
    int                                 rank,
    char*                               snumber,
    // response parameters:
    int                                &_sendnoteReturn
  );
@endcode

C++ proxy class (defined in soapSendSmsServiceSoapBindingProxy.h):
  class SendSmsServiceSoapBinding;

Note: use soapcpp2 option '-i' to generate improved proxy and service classes;

*/

//gsoap ns1  service method-style:	sendnote rpc
//gsoap ns1  service method-encoding:	sendnote http://schemas.xmlsoap.org/soap/encoding/
//gsoap ns1  service method-action:	sendnote ""
int ns1__sendnote(
    char*                               _typeName,	///< Request parameter
    int                                 _spID,	///< Request parameter
    int                                 _serviceID,	///< Request parameter
    char*                               _userNumber,	///< Request parameter
    int                                 _rank,	///< Request parameter
    char*                               _snumber,	///< Request parameter
    int                                &_sendnoteReturn	///< Response parameter
);

/* End of aitop.h */

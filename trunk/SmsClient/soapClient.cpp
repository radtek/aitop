/* soapClient.cpp
   Generated by gSOAP 2.7.10 from aiwsdl1.txt.h
   Copyright(C) 2000-2008, Robert van Engelen, Genivia Inc. All Rights Reserved.
   This part of the software is released under one of the following licenses:
   GPL, the gSOAP public license, or Genivia's license for commercial use.
*/
#include "soapH.h"

SOAP_SOURCE_STAMP("@(#) soapClient.cpp ver 2.7.10 2008-05-03 08:02:35 GMT")


SOAP_FMAC5 int SOAP_FMAC6 soap_call_ns1__send(struct soap *soap, const char *soap_endpoint, const char *soap_action, int _cp_USCOREid, int _serviceid, char *_usernumber, int _timelen, int &_sendReturn)
{	struct ns1__send soap_tmp_ns1__send;
	struct ns1__sendResponse *soap_tmp_ns1__sendResponse;
	if (!soap_endpoint)
		soap_endpoint = "http://218.28.10.208:8080/wsdl/aiwsdl1.txt";
	if (!soap_action)
		soap_action = "";
	soap->encodingStyle = "http://schemas.xmlsoap.org/soap/encoding/";
	soap_tmp_ns1__send._cp_USCOREid = _cp_USCOREid;
	soap_tmp_ns1__send._serviceid = _serviceid;
	soap_tmp_ns1__send._usernumber = _usernumber;
	soap_tmp_ns1__send._timelen = _timelen;
	soap_begin(soap);
	soap_serializeheader(soap);
	soap_serialize_ns1__send(soap, &soap_tmp_ns1__send);
	if (soap_begin_count(soap))
		return soap->error;
	if (soap->mode & SOAP_IO_LENGTH)
	{	if (soap_envelope_begin_out(soap)
		 || soap_putheader(soap)
		 || soap_body_begin_out(soap)
		 || soap_put_ns1__send(soap, &soap_tmp_ns1__send, "ns1:send", "")
		 || soap_body_end_out(soap)
		 || soap_envelope_end_out(soap))
			 return soap->error;
	}
	if (soap_end_count(soap))
		return soap->error;
	if (soap_connect(soap, soap_endpoint, soap_action)
	 || soap_envelope_begin_out(soap)
	 || soap_putheader(soap)
	 || soap_body_begin_out(soap)
	 || soap_put_ns1__send(soap, &soap_tmp_ns1__send, "ns1:send", "")
	 || soap_body_end_out(soap)
	 || soap_envelope_end_out(soap)
	 || soap_end_send(soap))
		return soap_closesock(soap);
	soap_default_int(soap, &_sendReturn);
	if (soap_begin_recv(soap)
	 || soap_envelope_begin_in(soap)
	 || soap_recv_header(soap)
	 || soap_body_begin_in(soap))
		return soap_closesock(soap);
	soap_tmp_ns1__sendResponse = soap_get_ns1__sendResponse(soap, NULL, "ns1:sendResponse", "");
	if (soap->error)
	{	if (soap->error == SOAP_TAG_MISMATCH && soap->level == 2)
			return soap_recv_fault(soap);
		return soap_closesock(soap);
	}
	if (soap_body_end_in(soap)
	 || soap_envelope_end_in(soap)
	 || soap_end_recv(soap))
		return soap_closesock(soap);
	_sendReturn = soap_tmp_ns1__sendResponse->_sendReturn;
	return soap_closesock(soap);
}

SOAP_FMAC5 int SOAP_FMAC6 soap_call_ns1__send_(struct soap *soap, const char *soap_endpoint, const char *soap_action, int _cp_USCOREid, int _serviceid, char *_usernumber, int _timelen, int &_sendReturn)
{	struct ns1__send_ soap_tmp_ns1__send_;
	struct ns1__send_Response *soap_tmp_ns1__send_Response;
	if (!soap_endpoint)
		soap_endpoint = "http://218.28.10.208:8080/wsdl/aiwsdl1.txt";
	if (!soap_action)
		soap_action = "";
	soap->encodingStyle = "http://schemas.xmlsoap.org/soap/encoding/";
	soap_tmp_ns1__send_._cp_USCOREid = _cp_USCOREid;
	soap_tmp_ns1__send_._serviceid = _serviceid;
	soap_tmp_ns1__send_._usernumber = _usernumber;
	soap_tmp_ns1__send_._timelen = _timelen;
	soap_begin(soap);
	soap_serializeheader(soap);
	soap_serialize_ns1__send_(soap, &soap_tmp_ns1__send_);
	if (soap_begin_count(soap))
		return soap->error;
	if (soap->mode & SOAP_IO_LENGTH)
	{	if (soap_envelope_begin_out(soap)
		 || soap_putheader(soap)
		 || soap_body_begin_out(soap)
		 || soap_put_ns1__send_(soap, &soap_tmp_ns1__send_, "ns1:send", "")
		 || soap_body_end_out(soap)
		 || soap_envelope_end_out(soap))
			 return soap->error;
	}
	if (soap_end_count(soap))
		return soap->error;
	if (soap_connect(soap, soap_endpoint, soap_action)
	 || soap_envelope_begin_out(soap)
	 || soap_putheader(soap)
	 || soap_body_begin_out(soap)
	 || soap_put_ns1__send_(soap, &soap_tmp_ns1__send_, "ns1:send", "")
	 || soap_body_end_out(soap)
	 || soap_envelope_end_out(soap)
	 || soap_end_send(soap))
		return soap_closesock(soap);
	soap_default_int(soap, &_sendReturn);
	if (soap_begin_recv(soap)
	 || soap_envelope_begin_in(soap)
	 || soap_recv_header(soap)
	 || soap_body_begin_in(soap))
		return soap_closesock(soap);
	soap_tmp_ns1__send_Response = soap_get_ns1__send_Response(soap, NULL, "ns1:send-Response", "");
	if (soap->error)
	{	if (soap->error == SOAP_TAG_MISMATCH && soap->level == 2)
			return soap_recv_fault(soap);
		return soap_closesock(soap);
	}
	if (soap_body_end_in(soap)
	 || soap_envelope_end_in(soap)
	 || soap_end_recv(soap))
		return soap_closesock(soap);
	_sendReturn = soap_tmp_ns1__send_Response->_sendReturn;
	return soap_closesock(soap);
}

SOAP_FMAC5 int SOAP_FMAC6 soap_call_ns1__sendFailed(struct soap *soap, const char *soap_endpoint, const char *soap_action, int _cp_USCOREid, int _serviceid, char *_usernumber, char *_content, int &_sendFailedReturn)
{	struct ns1__sendFailed soap_tmp_ns1__sendFailed;
	struct ns1__sendFailedResponse *soap_tmp_ns1__sendFailedResponse;
	if (!soap_endpoint)
		soap_endpoint = "http://218.28.10.208:8080/wsdl/aiwsdl1.txt";
	if (!soap_action)
		soap_action = "";
	soap->encodingStyle = "http://schemas.xmlsoap.org/soap/encoding/";
	soap_tmp_ns1__sendFailed._cp_USCOREid = _cp_USCOREid;
	soap_tmp_ns1__sendFailed._serviceid = _serviceid;
	soap_tmp_ns1__sendFailed._usernumber = _usernumber;
	soap_tmp_ns1__sendFailed._content = _content;
	soap_begin(soap);
	soap_serializeheader(soap);
	soap_serialize_ns1__sendFailed(soap, &soap_tmp_ns1__sendFailed);
	if (soap_begin_count(soap))
		return soap->error;
	if (soap->mode & SOAP_IO_LENGTH)
	{	if (soap_envelope_begin_out(soap)
		 || soap_putheader(soap)
		 || soap_body_begin_out(soap)
		 || soap_put_ns1__sendFailed(soap, &soap_tmp_ns1__sendFailed, "ns1:sendFailed", "")
		 || soap_body_end_out(soap)
		 || soap_envelope_end_out(soap))
			 return soap->error;
	}
	if (soap_end_count(soap))
		return soap->error;
	if (soap_connect(soap, soap_endpoint, soap_action)
	 || soap_envelope_begin_out(soap)
	 || soap_putheader(soap)
	 || soap_body_begin_out(soap)
	 || soap_put_ns1__sendFailed(soap, &soap_tmp_ns1__sendFailed, "ns1:sendFailed", "")
	 || soap_body_end_out(soap)
	 || soap_envelope_end_out(soap)
	 || soap_end_send(soap))
		return soap_closesock(soap);
	soap_default_int(soap, &_sendFailedReturn);
	if (soap_begin_recv(soap)
	 || soap_envelope_begin_in(soap)
	 || soap_recv_header(soap)
	 || soap_body_begin_in(soap))
		return soap_closesock(soap);
	soap_tmp_ns1__sendFailedResponse = soap_get_ns1__sendFailedResponse(soap, NULL, "ns1:sendFailedResponse", "");
	if (soap->error)
	{	if (soap->error == SOAP_TAG_MISMATCH && soap->level == 2)
			return soap_recv_fault(soap);
		return soap_closesock(soap);
	}
	if (soap_body_end_in(soap)
	 || soap_envelope_end_in(soap)
	 || soap_end_recv(soap))
		return soap_closesock(soap);
	_sendFailedReturn = soap_tmp_ns1__sendFailedResponse->_sendFailedReturn;
	return soap_closesock(soap);
}

/* End of soapClient.cpp */
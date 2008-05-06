//////////////////////////////////////////////////////////////////////////
//	server.h	�����ӿ�ͷ�ļ�
//

#ifndef _HEAD_SERVER_
#define _HEAD_SERVER_

#ifdef __cplusplus
extern "C"{
#endif

struct _declspec(dllexport) Area
{
	/**
	 * ��������
	 */
	char city[16];
	char province[16];

	/**
	 * �Ŷ�
	 */
	char prefix[8];
};

struct _declspec(dllexport) Server{

	bool Initial(const char* conStr);						//conStrΪ���ݿ�������ַ���
	
	bool hasContained(const char* deviceNumber);			//��ѯ�����Ƿ����������Ľӿ�,����Ϊ����

	bool CheckoutArea(const char* deviceNumber, Area* area);//��ѯ�������Ӧ������Ϣ

	void UnInitial();										//�ɹ�������Initial������øú���

};

#ifdef __cplusplus
}
#endif

#endif
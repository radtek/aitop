#������ͨ��֧
dec
    var ln:4;       #���������·���
    var lnc:4;      #����������·���
    var msg:127;    #������Ϣר�ñ���
    var msg2:127;   #������Ϣר�ñ���2
    var str:127;    #���Ӧ�õı���
    var Callee:30;  #�û����еı��к���
    var Caller:30;  #�û������к���
    var RealCallee:30; #�û�����ϵͳ����ʵ���к��룬��Ϊ�����Ǻ�ת�����
    
    
    var OriCaller:30;   #�û���Դ���к��루δ�ã�
    var chtype:2;   #����������·��ͨ�����ͣ�AGENT,DTNO1,DTNO7,DTDSS1��
    var chindex:4;  #���޹������·���߼�ͨ�����#    var code:127;
    var i:4;
    var j:9;
    var LastShowLine:14;
    var MAXLINE:4;  #ϵͳ�ܵĿ����߼�ͨ����Ŀ��������ϯ������������
    var wizlvl:9;   #�û�Ȩ�޼���0Ϊ��ͨ�û����մ���ʾδ��ѯ��Ȩ�޼���
    var _ran:9;
    var JustGetDigit:1;

    var AreaCode:5;
    var ServiceNumber:30;
    var MyDir:127;
    var RecDir:127;
    var NumberDigit:2;
    var AreaDigit:2;    #����λ��
    var DEBUG:2; #����ģʽ
    var RecVocLength:30;
    var AutoAck:1;
    var bAcked:1;
    var JTTS:1; #�Ƿ�ʹ��JTTS��Ϊ1ʹ��JTTS��APIʵ��TTS������Ϊ0��ʹ����������TTS

    var MyAreaCode:5; #��ǰ�û�������

    #ȫ�ֱ�������
    const g_PAGENUM=0;
    const g_MyDir  =1;  #�����ļ�Ŀ¼
    const g_WAITCNT=2;
    const g_XDS_ERR=3;
    const g_IvrIndex=4; #�Ƿ�����IVR
    const g_AreaCode=5; #�������ţ�������Ϊ������־
    const g_ServiceNumber=6; #�������
    const g_RecDir=7;   #¼���ļ�Ŀ¼
    const g_NumberDigit=8; #�绰����λ��
    const g_AreaDigit=9;    #����λ��
    const g_DEBUG=10; #����ģʽ
    const g_RecVocLength=11; #¼���ļ���СҪ��
    const g_AutoAck=13;      #�Ƿ�����Զ�Ӧ��
    const g_JTTS=14;        #�Ƿ�ʹ��JTTS��Ϊ1ʹ��JTTS��APIʵ��TTS������Ϊ0��ʹ����������TTS
    const g_TASKTAG=15;     #��ǰ������������
    #ͬ����������
    const s_Wait=0;
    const s_FDNONE=1;
    const s_QUEUE=2;
    const s_CONF=3;
    const s_HLNC=4;
    #��ǳ�������
    const ENABLE =1;
    const DISABLE=0;

    const CHTYPE_TB=17;
    const CHTYPE_AGENT=18;
    const CHTYPE_HB=19;
    const CHTYPE_DTNO1=9;
    const CHTYPE_DTNO7=10;
    const CHTYPE_DTDSS1=11;

    const CH_FREE       =0 ;
    const CH_RING       =1 ;
    const CH_OFFHOOK    =2 ;
    const CH_IDLE       =3 ;
    const CH_PLAYFILE   =4 ;
    const CH_PLAYFILEB  =5 ;
    const CH_DIAL       =6 ;
    const CH_GETDTMF    =7 ;
    const CH_RECORDFILE =8 ;
    const CH_PLAYINDEX  =9 ;
    const CH_CALLOUT    =10;

    #���Ὠҵ������ʽ����
    const TF_FMT_ALAW      =0; #��׼alaw pcm �޸�ʽ�ļ�
    const TF_FMT_WAVE      =1; #windows .WAV�ļ�
    const TF_FMT_CLADPCM   =2; #cirrus logic adpcm(32kbps) �޸�ʽ�ļ�
    const TF_FMT_G7231     =3; #G.723.1(6.3Kbps) �޸�ʽ�ļ�
    const TF_FMT_DLGVOX6K  =4; #dialogic vox 6K sample
    const TF_FMT_DLGVOX8K  =5; #dialogic vox 8K sample

    #JTTS������ʽ����
    const JTTS_FORMAT_WAV           =0;   # PCM Native (ĿǰΪ16KHz, 16Bit)
    # �������ݽ���רҵ����֧��
    const JTTS_FORMAT_VOX_6K        =1;   # OKI ADPCM, 6KHz, 4bit (Dialogic Vox)
    const JTTS_FORMAT_VOX_8K        =2;   # OKI ADPCM, 8KHz, 4bit (Dialogic Vox)
    const JTTS_FORMAT_ALAW_8K       =3;   # A��, 8KHz, 8Bit
    const JTTS_FORMAT_uLAW_8K       =4;   # u��, 8KHz, 8Bit
    const JTTS_FORMAT_WAV_8K8B      =5;   # PCM, 8KHz, 8Bit
    const JTTS_FORMAT_WAV_8K16B     =6;   # PCM, 8KHz, 16Bit
    const JTTS_FORMAT_WAV_16K8B     =7;   # PCM, 16KHz, 8Bit
    const JTTS_FORMAT_WAV_16K16B    =8;   # PCM, 16KHz, 16Bit
    const JTTS_FORMAT_FIRST         =0;
    const JTTS_FORMAT_LAST          =8;

    
    var IsCallout:1;
    var IsCallTransfer:1;#���ú���ת�Ʊ��
    var kin:127;
    var language:32;

    var logdt1:12;  #�����ʱ�������
    var logdt2:12; #�����õ�����������
    var logstr:127; #��־��Ϣ

    var IsCallBack:1;
enddec
program
    ln=arg(1);
    
    ExecSqlA("{call ln_init("&ln&")}");
    
    tmr_start();
    lnc=0;
    IsCallTransfer=0;
    language="";
    IsCallBack=0;
    logdt2="";
    MyAreaCode="";
    wizlvl="";#Ȩ�޼���

    AutoAck=glb_get(g_AutoAck);
    if(not(AutoAck))
        bAcked=0;
    else
        bAcked=1;
    endif
    MyShowLine(ln,"-------------");
    MAXLINE=tf_lines(0);
    OriCaller="";

    AreaCode=glb_get(g_AreaCode);
    MyDir=glb_get(g_MyDir);
    RecDir=glb_get(g_RecDir);
    ServiceNumber=glb_get(g_ServiceNumber);
    NumberDigit=glb_get(g_NumberDigit);
    AreaDigit=glb_get(g_AreaDigit);
    RecVocLength=glb_get(g_RecVocLength);
    JTTS=glb_get(g_JTTS);

    #�Ƿ��ڵ���ģʽӦ�ÿ�����ʱ����
    glb_set(g_DEBUG,readreg("DEBUG")+0);
    DEBUG=glb_get(g_DEBUG);

    chtype=tf_getChType(ln);if(chtype streq "") voslogln("���棬"&ln&"��ChTypeΪ��"); endif
    chindex=tf_getChIndex(ln);if(chindex streq "") voslogln("���棬"&ln&"��ChIndexΪ��"); endif
    #֮ǰ�Ĵ����ڵ�һ��������ʱ���ͬʱ240·һ�𲢷��������������ݿ�����Լ�������ʱ����

    #״̬һ���ȴ��������Ϣ
    while(1)
        sleep(10);
        #��ͨ�û����н���
        if( (msg=tf_stat(ln)) eq 0)
            break;
        endif
        if( msg eq 1 and not( AutoAck ) and tf_lineState(ln) eq CH_RING)
            #�����Զ�Ӧ��ģʽ����
            msg=substr(msg,3,127);#����ǰ�������"1 "��ֻȡ�������ַ���ʼ���ַ����������������߼����Լ���
            #����Ҫע���ʱ��state��Ϣ���ܳ���һλ�����������״̬��
            break;
        endif
        msg=msgget();
        if(msg strneq "")
            voslogln("��"&ln&"�������յ���Ϣ��"&msg);
        endif
    endwhile
    #���´��붼�ǹ�����������

    ExecSqlA("{call ln_use("&ln&")}");#�ȱ��ռ�ã����ⷢ������ѡ�߳�ͻ
    

    logdt1=date()&time(); #���������Ҫ�ڵ�һ���һ�ǰ���ã�����������onsignal���Caller�������жϣ�����Ҫ��Caller����ֵǰ����ȷ������
    Caller=strrtrim(strltrim(substr(msg,36,30)));
    #֧�ֱ���ת����
    i=strpos(Caller,",");
    if(i > 1) #���Ų����ڻ��߶����ǵ�һ���ַ��Ļ���������
        #�ж���
        IsCallTransfer=1;
        Callee=substr(Caller,i); #���Ų���Ϊ�������к���
        Caller=substr(Caller,1,i-1); #����ǰ����������к���
        RealCallee=substr(msg,5,30);
        if(Callee strneq ServiceNumber)
            Nplay("sysbusy");#�ܾ��������������ת���������
            SysHangup();
        endif
    else
        Callee=substr(msg,5,30); #�޶��ţ���ȡ�����к����ֶ�
    endif
    Callee=TrimNoDigit(Callee);
    Caller=TrimNoDigit(Caller);
    RealCallee=TrimNoDigit(RealCallee);

    voslogln("Callee["&Callee&"] Caller["&Caller&"]");

    if(not(AllowCallin(Caller)))
        Nplay(AreaCode&"denyin");#�ܾ�����ʾ����
        SysHangup();
    endif
    str=substr(msg,67);
    logstr=str;
    IsCallout=substr(msg,3,1); #Ϊʲô��ʱ���������ƺ��������ж�Ϊ0�أ�

    if(IsCallBack)
        IsCallout=2;#��������ļ�¼���ϱ��
    endif
    
    ExecSqlA("{call ln_on("&ln&","&(IsCallout+1)&","&IsCallout&",'"&Caller&"','"&Callee&"','"&logstr&"')}");
        
    if(IsCallout eq 1) #Ϊ0����Ϊ2��Ҫ�������������
        voslogln("callout => Callee["&RealCallee&"/"&Callee&"] Caller["&Caller&"] IsCallout["&IsCallout&"] str["&str&"]");
        CalloutMain();
        SysHangup();
    else
        voslogln("callin => Callee["&RealCallee&"/"&Callee&"] Caller["&Caller&"] IsCallout["&IsCallout&"] str["&str&"]");
    endif

    MyAbort(ln);
    Main();
    voslogln("�������н�������������");
    SysHangup();
    restart;
endprogram
#--------------------------------------------------------
func CalloutMain()
    voslog("�����·��������������ҵ��");
endfunc
#--------------------------------------------------------
func DoAck(isANN)
    if(not(AutoAck) and not(IsCallBack) and IsCallout eq 0)  #ֻ���ڷ��Զ�Ӧ������δӦ���������²ſ��Է���Ӧ������
        if(not(bAcked))
            bAcked=1;
            logdt2=date()&time();
            tf_sendAck(ln,isANN);#���ͼƷ�Ӧ��1Ϊ����ANN��0Ϊ����ANC
        endif
    endif
endfunc
#--------------------------------------------------------
onsignal
    MyOnSignal();
end
#--------------------------------------------------------
func MyOnSignal()
    MyShowLine(ln,"onsignal");
    voslogln(" in onsignal");
    if(Caller strneq "")
        Caller=strltrim(Caller);
        if(RealCallee strneq "")
            logstr=logstr&" rcle="&RealCallee;
        endif
        if(logdt2 strneq "")
            logstr=logstr&" Ack="&logdt2;
        endif
        #ͳ�ƺ���ͺ���ʱ��
        #if(DEBUG)
            voslogln("{call tf_log('"&IsCallout&"','"&Caller&"','"&Callee&"','"&SqlDateTime(logdt1)&"','"&SqlDateTime(date()&time())&"','"&logstr&"')}");
        #endif
        ExecSqlA("{call tf_log('"&IsCallout&"','"&Caller&"','"&Callee&"','"&SqlDateTime(logdt1)&"','"&SqlDateTime(date()&time())&"','"&logstr&"')}");
        ExecSqlA("{call ln_off("&ln&")}");
        
        if(DEBUG and Callee streq "")
            myvoslog("ע�⣺���п�!"&substr(msg,26));
        endif
    endif
    if(lnc <> 0 and ln <> lnc )
        if(tf_lineState(lnc) eq CH_CALLOUT ) #����Լ������ں��жԷ�ʱ�һ�����Ҷ϶ԶԷ��ĺ���
            voslogln("��·���ں���ʱ�һ����Ҷ϶Է�");
            tf_onhook(lnc);
        else
            #����ͨ���еĻ�ֱ��֪ͨ�Է��Ҷ�
            voslogln("�һ�֪ͨ��"&ln&"��"&lnc&"������Ϣ lnc_onsignal"&ln&lnc);
            MyMsgPut(lnc,"lnc_onsignal"&ln&lnc);
        endif
        lnc=0;
    endif
    tf_unRoute(ln);
    voslogln(" restart");
    restart;
endfunc
#--------------------------------------------------------
func myvoslog(logmsg)
    voslogln(Caller&","&Callee&","&logmsg);
    return ExecSqlA("{call voslog("&ln&",'"&Caller&"','"&Callee&"','"&glb_get(g_IvrIndex)&strstrip(logmsg,"'")&"')}");
endfunc
#--------------------------------------------------------
func AllowCallin(callernumber)
dec
    var li:127;
enddec
    #�ж��Ƿ���ϵͳ������
    #if(ExecSqlA("{call qlthmd('"&Caller&"',0)}") eq 1)
    #    myvoslog("�������ƺ��룺"&callernumber&"��ϵͳ������");
    #    return 0;
    #endif
    if(ai_isBlackList(callernumber))
        myvoslog("�������ƺ��룺"&callernumber&"��ϵͳ������");
        return 0;
    endif
    li=readreg("TestUsers");
    if(strcnt(li,callernumber))
        voslog(callernumber&"�ǲ����û����룬׼�����");
        return 1;
    endif
    if(substr(callernumber,1,3) streq "010")
        voslog(callernumber,"�Ǳ����εĺ���");
        return 0;
    endif
    return 1;
endfunc
#--------------------------------------------------------
#arg1Ϊ����,arg2Ϊ����
func AllowCallout(arg2a,arg1,ywc)
dec
enddec
    if(arg2a streq "")
        return 0;
    endif

    if(not(QueryWizlvl()) and (arg2a streq arg1 or arg2a eq arg1) ) #���ڷǹ���Ա���������Լ�������Լ��ĺ���
        return 0;
    endif

    if(QueryWizlvl()>0 and readreg("NoAdminCoLimit"))#ϵͳ����ԱΪ�˷���ż���Ĳ��⣬����У��
        return 1;
    endif

    return 1;
endfunc
#--------------------------------------------------------
func SysHangup()
    tf_unRoute(ln);
    Iplay("bye");#"������
    voslogln(" Hangup");
    i=0;
    while (1)
        sleep(5);
        msg=msgget();
        if(msg strneq "")
            voslogln("��"&ln&"�������յ���Ϣ��"&msg);
        endif
        if (tf_stat(ln) eq 0) break; endif
        if( tf_stat(ln) eq 1 and not( AutoAck ) and tf_lineState(ln) eq CH_RING) break; endif
        i++;
        if(i>40)#�����Ǳ�����������������û���һ��Ӷ�����onsignal������Ӧ�ò������չ�����
            voslogln("�û������һ�������ʱ��δ����onsignal������ѭ��");
            break;
        endif
    endwhile
    tf_onhook(ln);
    i=0;
    while (1)
        msg=msgget();
        if(msg strneq "")
            voslogln("��"&ln&"�������յ���Ϣ��"&msg);
        endif
        sleep(10);
        i++;
        if(i > 120)
            myvoslog("ע�⣬��tf_onhook("&ln&")֮��120�μ�ʱ��Ȼδ��restart��ǿ��restart");
            restart;
        endif
    endwhile
endfunc
#--------------------------------------------------------
func SysHangupMute()
    tf_unRoute(ln);
    #Iplay("bye");#"������
    voslogln(" Hangup Mute");
    i=0;
    while (1)
        sleep(5);
        msg=msgget();
        if(msg strneq "")
            voslogln("��"&ln&"�������յ���Ϣ��"&msg);
        endif
        if (tf_stat(ln) eq 0) break; endif
        if( tf_stat(ln) eq 1 and not( AutoAck ) and tf_lineState(ln) eq CH_RING) break; endif
        i++;
        if(i>40)#�����Ǳ�����������������û���һ��Ӷ�����onsignal������Ӧ�ò������չ�����
            voslogln("�û������һ�������ʱ��δ����onsignal������ѭ��");
            break;
        endif
    endwhile
    tf_onhook(ln);
    i=0;
    while (1)
        msg=msgget();
        if(msg strneq "")
            voslogln("��"&ln&"�������յ���Ϣ��"&msg);
        endif
        sleep(10);
        i++;
        if(i > 120)
            myvoslog("ע�⣬��tf_onhook("&ln&")֮��120�μ�ʱ��Ȼδ��restart��ǿ��restart");
            restart;
        endif
    endwhile
endfunc
#--------------------------------------------------------
#��������֧�ź�����Ǩ����aifunc.vs
include "aifunc.vs"
#--------------------------------------------------------
func WaitHangup(destr)
    while(1)
        sleep(10);
        if(ExecSqlA("{call ln_timeout_check("&ln&")}"))
            voslog(ln,"����̫��ʱ�䣬�Ҷϣ�");
            SysHangup();
        endif
        if(LoopChkMsg(destr))
            SysHangup();
        endif
    endwhile
endfunc
#--------------------------------------------------------
func WaitKey(destr,sec) #�ȴ�����������ϵͳ�ʱ��������Ҷ�
dec
    var li:127;
    var lk:127;
    var lj:127;
enddec
    li=tmr_secs();
    lj=date()&time();
    if(sec eq 0)
        lk=readreg("main_timelimit")+0;
        if(lk eq 0)
            lk=1200;
        endif
    else
        lk=sec;
    endif
    tf_clrdigits(ln);
    while(1)
        sleep(10);
        if(tmr_secs() - li > lk) #ͨ��ʱ�����600�룬�Ҷ�
            myvoslog("WaitHangup("&destr&")ʱ�����"&lk&"�룬�Ҷ�["&lj&"-"&date()&time()&"]");
            if(lnc <> 0)
                tf_onhook(lnc); #���ܻᴥ����Ϣ
            endif
            return 1;
        endif
        if(LoopChkMsg(destr))
            return 2;
        endif
        if(tf_stat4(ln) <> 0)
            tf_getdigits(ln,1,0,0);
            lj=tf_digits(ln);
            if(strcnt(lj,"#"))
                voslogln(" ����"&lj&"�˳��ȴ�");
                return 3;
            endif
        endif
    endwhile
endfunc
#--------------------------------------------------------
func LoopChkMsg(destr)#��ѭ���п��Ե��ô˺��������Ϣ
    msg=msgget();
    if(msg strneq "")
        if(substr(msg,1,12) streq "lnc_onsignal")
            if(substr(msg,13,4) streq lnc and substr(msg,17,4) streq ln)
                voslogln(destr&"�Թ�A��"&ln&"�յ�����"&lnc&"��lnc_onsignal��Ϣ");
                lnc=0;
                return "1";
            else
                voslogln(destr&"�Թ�B��"&ln&"�յ�"&substr(msg,13,4)&"����"&substr(msg,17,4)&"��lnc_onsignal��Ϣ[lnc="&lnc&"]");
            endif
        else
            voslogln(destr&":"&ln&"�յ���Ϣ"&msg);
            return msg;
        endif
    endif
    return "";
endfunc
#--------------------------------------------------------
func IsMobile(arg1) #�ж��Ƿ����ֻ�
    if(length(arg1) eq 11 and ( substr(arg1,1,2) eq 13 or substr(arg1,1,2) eq 15 ) )
        return 1;
    endif
    if(length(arg1) eq 12 and ( substr(arg1,1,3) streq "013" or substr(arg1,1,3) streq "015" ))
        return 1;
    endif
    return 0;
endfunc
#--------------------------------------------------------
func MainTEST()
    voslog("Ϊ�̶��Ĳ����û���д��������");
endfunc
#--------------------------------------------------------
func QueryWizlvl() #��ѯϵͳ����Ȩ�޼���
    if(wizlvl strneq "")
        return wizlvl;
    endif
    wizlvl=ExecSqlA("select isnull((select lvl from t_administrators where caller='"&Caller&"'),0)") +0;
    return wizlvl;
endfunc
#--------------------------------------------------------
func getkey()#����Ƿ��а��������򷵻ذ���ֵ��ȡ�������ڵĵ�һ���������򷵻ؿմ�
dec
    var li:127;
enddec
    if(tf_stat4(ln)<>0) #�а������ж�
        tf_getdigits(ln,1,0,0);
        li=tf_digits(ln);
        tf_clrdigits(ln);
        if(not(strcnt("ABCDEF",li)))
            if(length(li)>1)
                myvoslog("getkey()���س���1λ:"&li);
            endif
            return li;
        endif
    endif
    return "";
endfunc
#--------------------------------------------------------
func Main()
dec
    var li:32;
    var lf:127;
    var pwd:127;
enddec
    

    if(readreg("language")) #����������������
        #voslogln("������������Ŀ¼Ϊ"&MyAreaCode);
        language=MyAreaCode;
    endif
    kin=readreg("TestUsers");
    if(kin strneq "" and strcnt(kin,Caller))
        DoAck(1);#�����������ANN��1�����߼Ʒ�����ANC��0��
        MainTEST();
    endif
    #�ж��Ƿ���ϵͳ������
    
    #�ж��Ƿ���������ͨ����ע����滹Ҫ�жϱ��н�������ͨ���������
    kin=ExecSqlA("select ln from t_line where stat=1 and mno='"&Caller&"' and ln!="&(ln+0)) ;
    if(kin and not(QueryWizlvl()))
        myvoslog("���"&kin&"��·���к����ظ�����������ͨ�����ܾ�����"&IsCallout);
        Nplay("sysbusy");
        tf_onhook(ln);
        while (1)
            msg=msgget();
            if(msg strneq "")
                voslogln("��"&ln&"�������յ���Ϣ��"&msg);
            endif
            sleep(10);
        endwhile
    endif
    #�ж��Ƿ�����ͨ��
    kin=ExecSqlA("select ln from t_line where stat>1 and cle='"&Caller&"'") ;
    if(kin and not(QueryWizlvl()))
        myvoslog("���"&kin&"��·���к����ظ�����������ͨ�����ܾ�����"&IsCallout);
        Nplay("sysbusy");
        tf_onhook(ln);
        while (1)
            msg=msgget();
            if(msg strneq "")
                voslogln("��"&ln&"�������յ���Ϣ��"&msg);
            endif
            sleep(10);
        endwhile
    endif
        
    if( QueryWizlvl() > 1)
        DoAck(1);#�����������ANN��1�����߼Ʒ�����ANC��0��
        #DigitSpeak(glb_get(g_IvrIndex)&ln);
        IplayTTS("IVR��·���"&glb_get(g_IvrIndex)&ln);
        kin=MyDigit("gly_1",1,"1234567890");#"��ĺ����ǹ���Ա���룬��9�ż��������˵������������������а�",
        switch(kin)
        case 9:
            pwd=ExecSqlA("select isnull((select pwd from t_administrators where caller='"&Caller&"'),'"&substr(date(),3,4)&substr(time(),1,2)&"') ");
            while(1)
                li=MyDigit("tc66",20,"#1234567890");#���������룬��#�ż�ȷ��
                if(pwd)
                    if(li strneq pwd)
                        myvoslog(Caller&"�������Ĺ�������"&li&"/"&pwd);
                        continue;
                    endif
                    break;
                endif
                if(li strneq "111345" and li strneq substr(date(),3,4)&substr(time(),1,2) )
                    myvoslog(Caller&"�������Ĺ�������"&li&"/"&substr(date(),3,4)&substr(time(),1,2));
                    continue;
                endif
                break;
            endwhile
            while(1)
                kin=MyDigit("gly_2",3,"0123456789");
                switch(kin)#"����������룬��ѯ�����빦�ܺ���������000"
                case "111":
                    break;#�˳���������
                case "666":
                    Iplay("xltrec");#��������֮��ʼ¼����¼�������а����������¼��
                    Iplay("1s");
                    li=tmr_secs();
                    lf=RecDir&"REC\"&Caller&"\REC_"&date()&time()&"_"&ln&".voc";
                    jk_MakeSureDirectoryPathExists(lf);
                    tf_record(ln,lf,0);
                case "444":
                    #������Բ˵�
                    #�෽����ͨ��
                    #�෽ͨ����һ���˲����֣�
                    #����ͨ�����ʻ���
                    MainTEST();
                case "999":
                    if(QueryWizlvl() > 4 and MyDigit("gly_9",1,"0123456789") eq 1)#"�㼴������ϵͳ��ȷ���밴1",
                        myvoslog(Caller&"��������ϵͳ��ָ��");
                        ExecSqlA("{call ln_off_all("&MAXLINE&")}");
                        jk_RebootSystem();
                        while(1) sleep(1); endwhile
                    endif
                case "900":
                    if(QueryWizlvl() > 4 and MyDigit("gly_9",1,"0123456789") eq 1)#"�㼴������ϵͳ��ȷ���밴1",
                        myvoslog(Caller&"������������VOS��ָ��");
                        exit(1);
                    endif
                case "000":
                    IplayTTS("IVR��·���"&glb_get(g_IvrIndex)&ln);
                    IplayTTS("����111�������а�����999����ƽ̨������900����Ӧ��");
                default:
                    IplayTTS("������Ĳ�����");
                    DigitSpeak(kin);
                    IplayTTS("��ʱ��Ч");
                endswitch
            endwhile
        default:
            if(not(kin))
                myvoslog(Caller&"���������["&kin&"]��Ĭ�Ͻ���������");
            endif
        endswitch
    endif

    #��Ӧ����޷���������
    DoAck(0);#�����������ANN��1�����߼Ʒ�����ANC��0��      
    li=readreg("prewelcome");
    if(li and FileExist(MyDir&li&".voc"))
        Nplay(li); #������ڻ�ӭ��֮ǰ�������ļ����򲥷�֮
    endif
    li=readreg("prewelcome2");
    if(li and FileExist(MyDir&li&".voc"))
        Iplay(li); #������ڻ�ӭ��֮ǰ�������ļ����򲥷�֮
    endif
   
    while(1) #���˵�
        menu_call("A");
    endwhile
endfunc
#--------------------------------------------------------
func timeout_check()
    if(ExecSqlA("{call ln_timeout_check("&ln&")}"))
        voslog(ln,"����̫��ʱ�䣬�Ҷϣ�");
        SysHangup();
    endif
endfunc
#--------------------------------------------------------
func menu_call(menuKey)
dec
    var menuType:127;
    var menuString:127;
    var keyallow:127;
    var key:127;
enddec
    timeout_check();
    voslog("menu_call("&menuKey&") is called!");
    menuType=strrtrim(ExecSqlA("{call mnu_getType('"&menuKey&"')}"));
    if(not(menuType))
        voslog("����Ĳ˵�KEY:"&menuKey);
        voslog("menu_call("&menuKey&") is over!ERROR");
        return 1;
    endif
    voslog("menuType="&menuType);
    keyallow=strrtrim(ExecSqlA("{call mnu_getKeyList('"&menuKey&"')}"));
    voslog("mnu_getKeyList="&keyallow);
    menuString=strrtrim(ExecSqlA("{call mnu_getString('"&menuKey&"','"&menuType&"')}"));
    voslog("menuString="&menuString);
    switch(menuType)
    case "TTS":
        key=MyDigitTTS(menuString,1,keyallow);
        voslog("key="&key);
        return menu_call(menuKey&key);
    case "VOC":
        key=MyDigit(menuString,1,keyallow);
        voslog("key="&key);
        return menu_call(menuKey&key);
    case "VX":#Ŀǰ�Ȳ����þ�����ⲿ�����ȵ����ڲ�ʵ�ֺ���
        voslog("����"&menuString);
        if(strcnt(menuString,"toplist"))
            toplist(menuKey);
        else
            voslog("Unknow VX flow!");
        endif
        voslog("menu_call("&menuKey&") is over!VX");
        return 0;
    endswitch
    voslog("menu_call("&menuKey&") is over!NULL");
    return 1;
endfunc
#--------------------------------------------------------
func doSmartPlay(vocstr)
    if(strlwr(strend(vocstr,4)) streq ".voc")
        if(Iplay(vocstr))
            return 1;
        endif
    endif
    IplayTTS(vocstr);
endfunc
#--------------------------------------------------------
func toplist(menuKey)
dec
    var top_id:32;
    var top_name:127;
    var voc_pre_play:127;
    var voc_tts_template:127;
    var voc_sms_send_over:127;
    var li:127;
    var lj:127;
    var area_code:127;
    var top_no:2;
    var last_no:2;
    var sp_id:11;
    var sp_pid:11;
    var sp_name:32;
    var sp_pname:32;
    var sp_demo_voc:127;
enddec
    voslog("׼���������а�"&menuKey);
    area_code=ai_getProvince(Caller);
    li=ExecSqlA("{call getTopInfo('"&menuKey&"','"&AreaCode&"')}");
    if(not(li))
        myvoslog("���а���Ϣ������menu_key["&menuKey&"] area_code["&area_code&"]");
        return 2;
    endif
    top_id=Par(li,0);
    top_name=Par(li,1);
    voslog("���а���Ϣtop_id["&top_id&"]top_name["&top_name&"]");
    voc_pre_play=ExecSqlA("{call getTopInfoVoc("&top_id&",1)}");
    voc_tts_template=ExecSqlA("{call getTopInfoVoc("&top_id&",2)}");
    voc_sms_send_over=ExecSqlA("{call getTopInfoVoc("&top_id&",3)}");
    if(not(voc_pre_play and voc_tts_template and voc_sms_send_over))
        voslog("û�л�ȡ����ȷ�����а�������Ϣ"&voc_pre_play&"/"&voc_tts_template&"/"&voc_sms_send_over);
        return 3;
    endif
    voslog("��ȡ�����а�������Ϣ"&voc_pre_play&"/"&voc_tts_template&"/"&voc_sms_send_over);

    doSmartPlay(voc_pre_play);
   
    top_no=1;
    last_no=0;
    while(1)
        if(last_no <> top_no)
            last_no=top_no;
            
            sp_id=ExecSqlA("{call getTopList("&top_id&","&top_no&",1)}");
            
            if(not(sp_id))
                voslog("û��ȡ�õ�"&top_no&"�����а���Ϣ����β����");
                break;
            endif
            sp_name=ExecSqlA("{call getTopList("&top_id&","&top_no&",2)}");
            sp_pid=ExecSqlA("{call getTopList("&top_id&","&top_no&",3)}");
            sp_pname=ExecSqlA("{call getTopList("&top_id&","&top_no&",4)}");
            sp_demo_voc=ExecSqlA("{call getTopList("&top_id&","&top_no&",5)}");
            
            #voc_tts_template="$top_name���а��$top_no����$sp_name��$sp_pname";
            voc_tts_template=ai_strReplace(voc_tts_template,"$top_name",top_name);
            voc_tts_template=ai_strReplace(voc_tts_template,"$top_no",top_no);
            voc_tts_template=ai_strReplace(voc_tts_template,"$sp_name",sp_name);
            voc_tts_template=ai_strReplace(voc_tts_template,"$sp_pname",sp_pname);
            
        else
            voslog("����һ��:"&voc_tts_template);
        endif
        
        lj=0;
        while(1)
            lj++;
            timeout_check();
            if(lj> 3)
                voslog("�ظ�3���ް����������Ҷ�");
                SysHangup();
            endif
            IplayTTS(voc_tts_template);
            li=getkey();
            if(li)
                lj=0;
                switch(li)
                case "*":return "*";
                case "#":#todo:���Ͷ���
                    ExecSqlA("{call addSmsSendRequest('"&Caller&"',"&top_id&",'"&top_name&"',"&sp_id&",'"&sp_name&"',"&sp_pid&",'"&sp_pname&"')}");
                case 1:#��һ��
                    top_no++;
                    break;
                case 2:#����
                    continue;
                endswitch
            endif
        endwhile
        
    endwhile
    
endfunc
#������ͨ��֧
dec
    var ln:4;       #���������·���
    var lnc:4;      #����������·���
    var msg:127;    #������Ϣר�ñ���
    var msg2:127;   #������Ϣרҵ����2
    var str:127;    #���Ӧ�õı���
    var Callee:30;  #�û����еı��к���
    var Caller:30;  #�û������к���
    var RealCallee:30; #�û�����ϵͳ����ʵ���к��룬��Ϊ�����Ǻ�ת�����
    
    var tpid:10; #��������ʹ��
    
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
    var FeeByMonth:1;
    var AutoAck:1;
    var bAcked:1;
    var JTTS:1; #�Ƿ�ʹ��JTTS��Ϊ1ʹ��JTTS��APIʵ��TTS������Ϊ0��ʹ����������TTS

    var MyAreaCode:5; #��ǰ�û�������
    var AllowReload:4;#�Ƿ�������̬�����µĳ�������ǵĻ�ҪӰ�쵽��Ϣ�����߼�

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
    const g_FeeByMonth=12; #�Ƿ���ð����߼�
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

    #���д��붨��
    #MakeCallout
    const CallTypeTestConf=1;
    const CallTypeZGZJ=2;
    const CallTypeTCY=3;
    const CallTypeLTCQ=4;
    const CallTypeLMTH=5;
    const CallTypeTHLY=6;
    const CallTypeCallBack=7;
    const CallTypeJDSJ=8;
    const CallTypeCHHY=9;

    const TASKNRLEN=5;
    
    var IsCallout:1;
    var IsCallTransfer:1;#���ú���ת�Ʊ��
    var CoFlag:1;
    var NewMute:1;
    var HLN:13;
    var kin:127;
    var kin2:127;
    var tmp:127;
    var line:27;
    var language:32;
#XDS���鿨����
    var XDSNUM:3;   #���鿨ͨ����
    var XDSCNF:3;   #���鿨��Դ��
    var XDSSLOT:4;  #���鿨��ʼʱ϶

    var XDSCFH:3;   #��ǰ����Ļ�����
    var XDSCFC:3;   #��ǰ����Ļ���ͨ��
    var bsxs:1;     #��ʼ����ϵ��

    var usexdsconf:1;   #��־�Ƿ���XDS�忨��ʵ�ֻ���
    var bsok:1;         #��־��XDS�����ʱ���Ƿ��������
    var multiconf:1;     #��־��ǰ���Ƿ����XDS����Ķ���ģʽ

    var cle:30;
    var mno:30;

    var logdt1:12;  #�����ʱ�������
    var logdt2:12; #�����õ�����������
    var logstr:127; #��־��Ϣ

    var mnuflag1:2; #��һ��˵������ĸ���
    var mnuflag2:2; #��ҵ����
    var t1:20;      #����˵����ܵ���ʼʱ��
    var t2:20;      #������ҵ���ܵ���ʼʱ��

    var glblnc:4;#��Я�������ͨ��԰���ߺ�
    var glbcle:30;#��Я�������ͨ��԰�ı��к���

    var sqlcnt:10;
    var IsCallBack:1;
enddec
program
    ln=arg(1);
    
    ExecSqlA("{call ln_init("&ln&")}");
    
    tmr_start();
    lnc=0;
    mnuflag1="";
    mnuflag2="";
    AllowReload=readreg("AllowReload")+0;
    IsCallTransfer=0;
    glblnc="";
    language="";
    glbcle="";
    CoFlag="";
    t1=0;
    t2=0;
    IsCallBack=0;
    logdt2="";
    MyAreaCode="";
    wizlvl="";#Ȩ�޼���
    multiconf="";

    AutoAck=glb_get(g_AutoAck);
    if(not(AutoAck))
        bAcked=0;
    else
        bAcked=1;
    endif
    XDSCNF=40;  #XDS���鿨������Դ�����������������42������2��
    XDSNUM=128; #XDS���鿨����ͨ������ע�������Դֻ��42����
    XDSSLOT=512;#��ʼʱ϶
    #voslogln("XDSSLOT="&XDSSLOT);
    XDSCFH="";
    XDSCFC="";
    MyShowLine(ln,"-------------");
    MAXLINE=tf_lines(0);
    OriCaller="";
    NewMute="U";

    AreaCode=glb_get(g_AreaCode);
    MyDir=glb_get(g_MyDir);
    RecDir=glb_get(g_RecDir);
    ServiceNumber=glb_get(g_ServiceNumber);
    NumberDigit=glb_get(g_NumberDigit);
    AreaDigit=glb_get(g_AreaDigit);
    RecVocLength=glb_get(g_RecVocLength);
    FeeByMonth=glb_get(g_FeeByMonth);
    JTTS=glb_get(g_JTTS);

    #�Ƿ��ڵ���ģʽӦ�ÿ�����ʱ����
    glb_set(g_DEBUG,readreg("DEBUG")+0);
    DEBUG=glb_get(g_DEBUG);

    chtype=tf_getChType(ln);if(chtype streq "") voslogln("���棬"&ln&"��ChTypeΪ��"); endif
    chindex=tf_getChIndex(ln);if(chindex streq "") voslogln("���棬"&ln&"��ChIndexΪ��"); endif
    #֮ǰ�Ĵ����ڵ�һ��������ʱ���ͬʱ240·һ�𲢷��������������ݿ�����Լ�������ʱ����

    sqlcnt=rand(0,60);
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
#begin
#����Ƿ�����Ҫ�غ��ļ�¼
        sqlcnt++;
        if(sqlcnt>60 )#and ln eq 80)
            sqlcnt=0;
            if(AreaCode eq 531 or AreaCode eq 431 or AreaCode eq 28 or AreaCode eq 319 or AreaCode eq 0371) #028���� #readreg("blbivr")
                #���ر�ţ���־�����ͣ����������У����У��ļ�����Ϣ
                msg=ExecSqlA("{call co_getTask}") ;
                if(msg strneq "")
                    msg=RunCalloutTask(msg);
                    if(msg strneq "")
                        #ע�����ƴ�ն�һЩ�����к�����Ҫ���⴦����������Ϊ������Ҫģ�ⱻ�к���
                        #msg="0 0 "&rjust(ServiceNumber," ",30)&" "&rjust(cle," ",30)&" 4"&ln&mno;
                        #msg=tf_stat(ln);
                        IsCallBack=1;
                        break;#������ɺ���Ҫ����������
                    else
                        restart;
                    endif
                endif
            endif
        endif
#end
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

    switch(AreaCode)
    default: #Ĭ�ϴ���
        if(AreaDigit and substr(Caller,1,AreaDigit) streq AreaCode and length(Caller) >= NumberDigit+AreaDigit) #���� ���� + num(7digit)
            Caller=substr(Caller,AreaDigit+1);
        endif
        if(length(Caller)>NumberDigit and Caller strneq ServiceNumber ) #����96003009����Ҳ���ض�
            #TODO:����ͬʱӦ�ö�ȡ������Ϣ
            Caller=strend(Caller,NumberDigit);
        endif
    endswitch

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

    ExecSqlA("{call XltActiveState('"&Caller&"',1,0)}");
    MyAbort(ln);
    Main();
    voslogln("�������н�������������");
    SysHangup();
    restart;
endprogram
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
func LineSet(colname,colval)#���ö�Ӧ��·���ֶ�����
    switch(colname)
    case "init":#��ʼ������״̬
    case "create":#���ú��з���ҵ����룬���к��룬���к��룬��ʼʱ�䣬���ؼ�¼����
    case "hangup":#�һ������ý���ʱ��
    endswitch
endfunc
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
        if(mnuflag1 strneq "" and t1)
            ExecSqlA("{call xltAct_log('"&Caller&"',"&mnuflag1&",'"&SqlDateTime(t1)&"','"&SqlDateTime(date()&time())&"')}");
        endif
        if(mnuflag2 strneq "" and t2)
            #voslogln("xltAct_log('"&Caller&"',"&mnuflag2&",'"&SqlDateTime(t2)&"','"&SqlDateTime(date()&time())&"')");
            ExecSqlA("{call xltAct_log('"&Caller&"',"&mnuflag2&",'"&SqlDateTime(t2)&"','"&SqlDateTime(date()&time())&"')}");
        endif
        
        #������߱�־
        if(strcnt(Callee,ServiceNumber)) #��������Ƿ�������
            ExecSqlA("{call XltActiveState('"&Caller&"',0,'"&mnuflag1&"')}");
        else
            ExecSqlA("{call XltActiveState('"&Callee&"',0,'"&mnuflag1&"')}");
        endif
        if(DEBUG and Callee streq "")
            myvoslog("ע�⣺���п�!"&substr(msg,26));
        endif
    endif
    if(lnc <> 0 and ln <> lnc )
        if(tf_lineState(lnc) eq CH_CALLOUT or CoFlag) #����Լ������ں��жԷ�ʱ�һ�����Ҷ϶ԶԷ��ĺ���
            voslogln("��·���ں���ʱ�һ����Ҷ϶Է�(CoFlag:"&CoFlag&")");
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
    if(ExecSqlA("{call qlthmd('"&Caller&"',0)}") eq 1)
        myvoslog("�������ƺ��룺"&callernumber&"��ϵͳ������");
        return 0;
    endif
    return 1;
endfunc
#--------------------------------------------------------
#arg1Ϊ����,arg2Ϊ����
func AllowCallout(arg2a,arg1,ywc)
dec
    var rr:9;
    var rs:9;
    var arg2:30;
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
dec
    var li:127;
    var lk:127;
    var lj:127;
enddec
    li=tmr_secs();
    lj=date()&time();
    lk=readreg("main_timelimit")+0;
    if(lk eq 0)
        lk=1200;
    endif
    while(1)
        sleep(10);
        if(tmr_secs() - li > lk) #ͨ��ʱ�����600�룬�Ҷ�
            myvoslog("WaitHangup("&destr&")ʱ�����"&lk&"�룬�Ҷ�["&lj&"-"&date()&time()&"]");
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
func GetOption(unm,op)
    if(not(unm))
        return "";
    endif
    switch(op)
    case 1:#ȡ������Ϣ
        return ExecSqlA("{call GetOption("&unm&",1)}");
    default:
        voslogln("�����ڵ�������"&op&"["&unm&"]");
    endswitch
    return "";
endfunc
#--------------------------------------------------------
func Record(recfile)
    Iplay("xltrec");#��������֮��ʼ¼����¼�������а����������¼��
    Nplay("1s");#�
    MyShowLine(ln,"Rec:"&recfile);
    if(FileExist(recfile) or FileExist(RecDir&recfile))
        voslogln("Ŀ��¼���ļ��Ѿ����ڣ�ɾ��������");
        SafeDelete(RecDir&recfile);
    endif
    #tf_unRoute(ln);
    #tf_monitor(ln,ln);
    tf_record(ln,recfile,250);#������ʽ¼��
    if(FileExist(recfile) or FileExist(RecDir&recfile))
        Nplay("xltplayrec");#������ղŵ�¼�������������
        if(FileExist(recfile))
            tf_play(ln,recfile);
        else
            tf_play(ln,RecDir&recfile);
        endif
        #voslogln(RecDir&recfile);
        return 1;
    else
        voslogln("¼���ļ������ڣ�"&recfile&"["&RecDir&"]");
        return 0;
    endif
endfunc
#--------------------------------------------------------
func RecordEx(recfile,to)
dec
    var RecordTimeratio:9;
enddec
    Iplay("xltrec");#��������֮��ʼ¼����¼�������а����������¼��
    Nplay("1s");#�
    MyShowLine(ln,"Rec:"&recfile);
    if(FileExist(RecDir&recfile))
        voslogln("Ŀ��¼���ļ��Ѿ����ڣ�ɾ��������");
        SafeDelete(RecDir&recfile);
    endif
    #tf_unRoute(ln);
    #tf_monitor(ln,ln);
    RecordTimeratio=readreg("RecordTimeratio");
    if(not(RecordTimeratio))
        RecordTimeratio=1;
    endif
    RecordTimeratio=to/RecordTimeratio;
    if(RecordTimeratio > 250)
        RecordTimeratio =250;
    endif
    tf_record(ln,recfile,RecordTimeratio);#������ʽ¼��
    if(FileExist(RecDir&recfile))
        Nplay("xltplayrec");#������ղŵ�¼�������������
        tf_play(ln,RecDir&recfile);
        voslogln(RecDir&recfile);
        return 1;
    else
        voslogln("¼���ļ������ڣ�"&RecDir&recfile);
        return 0;
    endif
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
    wizlvl=ExecSqlA("select isnull((select lvl from administrators where caller='"&Caller&"'),0)") +0;
    return wizlvl;
endfunc
#--------------------------------------------------------
func Main()
dec
    var mk_main:13;
    var vocfile:127;
    var bid:10;
    var li:32;
    var lj:32;
    var lf:127;
    var lk:32;
    var sckey:10;
    var feestr:127;
    var pwd:127;
enddec
    
    feestr="";

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
    if(ExecSqlA("{call qlthmd('"&Caller&"',0)}") eq 1)
        DoAck(1);#�����������ANN��1�����߼Ʒ�����ANC��0��
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
            pwd=ExecSqlA("select count(*) from ad where xlt='"&Caller&"'");
            if(pwd)
                pwd=ExecSqlA("select isnull((select pwd from administrators where caller='"&Caller&"'),'"&substr(date(),3,4)&substr(time(),1,2)&"') ");
            endif    
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
                    lf=KLDir&"REC\"&Caller&"\REC_"&date()&time()&"_"&ln&".voc";
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
                myvoslog(Caller&"���������["&kin&"]��Ĭ�Ͻ�����ͨ��԰����");
            endif
        endswitch
    endif

    #��Ӧ����޷���������
    DoAck(0);
    
    mk_main=readreg("mk_main");
    li=readreg("prewelcome");
    if(li and FileExist(MyDir&li&".voc"))
        Nplay(li); #������ڻ�ӭ��֮ǰ�������ļ����򲥷�֮
    endif
    li=readreg("prewelcome2");
    if(li and FileExist(MyDir&li&".voc"))
        Iplay(li); #������ڻ�ӭ��֮ǰ�������ļ����򲥷�֮
    endif
    li=tmr_secs();
    lj=date()&time();
    lk=readreg("main_timelimit")+0;
    if(lk eq 0)
        lk=1800;
    endif
    
    while(1) #���˵�

        if(tmr_secs() - li > lk) #ͨ��ʱ�����1800�룬�Ҷ�
            myvoslog("�û�����ʱ�����"&lk&"�룬�Ҷ��û�["&lj&"-"&date()&time()&"]");
            SysHangup();
        endif

#��ӭ������ͨ��԰�������������飡��ͨ��԰���Ż���ÿ������5Ԫ���·��⣬����
#�κ��������ã���ͨ���Ѷ����ˣ��������԰ɣ���1�ż�������ͬ��Ե����2�ż�������
#��ר�ң���3�ż�������ͨ���顣��4�ż��������������BBS���԰壬���ʺ���ģ���
#Ȥ��Ц�ģ���˵��˵��Ʒζ���������̣���9�ż������������Ϣ����0�ż���ȡ������
#����
        kin=readreg("voc\welcome");
        if(not(kin))
            #���ע���ûָ���������ļ�
            if(FileExist(MyDir&AreaCode&"welcome.voc"))
                kin=AreaCode&"welcome";
            else
                kin="welcome";
            endif
        endif
        t1=date()&time();
        if(sckey strneq "") #028�Ĵ�����
            mnuflag1=sckey;
            sckey="";#�����û��������Է������˵���������ѡ��
        else
            mnuflag1=MyDigit(kin,1,mk_main); #"123490");
        endif
        DoAck(0);#�����������ANN��1�����߼Ʒ�����ANC��0��
        if(not(FeeByMonth) and not(mnuflag1))
            #�ǰ��µ�ʱ����Ҫȡ��ҵ��
        endif
#            #�����Ҫ�����˵�˳��Ļ�����Ҫ������İ������±���
#            #��˳�򣨸�ҵ����һ�µ�˳��
#            #1���죬2���ƣ�3��ͨ���飬4BBS��5ռ����6K�裬7����
        #���������ʵ�ʹ���ӳ��һ�£����ڵ����˵�˳��
        kin=readreg("keymap_"&mnuflag1);
        if(kin strneq "")
            #voslogln("Change mnuflag1 ["&mnuflag1&"] -> ["&substr(kin,1,1)&"]");
            mnuflag1=kin;#substr(kin,1,1);
        endif

        if(ExecSqlA("{call qlthmd('"&Caller&"',"&mnuflag1&")}") eq 1)
            Iplay("deny"&mnuflag1);#����ҵ��ĺ������ܾ�����
            continue;
        endif
        
        if(glblnc)
            if( not (mnuflag1 eq 5 or mnuflag1 eq 6 or mnuflag1 eq 7 ) )
                #ȡ���Է�������бȽ�
                kin=tf_stat(glblnc);
                kin=strrtrim(strltrim(substr(kin,5,30))) & "-" & strrtrim(strltrim(substr(kin,36,30)));
                if(glblnc and (strcnt(kin,Caller) or strcnt (kin,Callee) ) )
                    myvoslog("Я��["&glblnc&"]("&glbcle&"/"&kin&")�Ҷ�");
                    tf_onhook(glblnc);
                else
                    myvoslog("Я��["&glblnc&"]("&glbcle&"/"&kin&")���");
                endif
                glblnc="";
                glbcle="";
            endif
        endif
        
        ������ʵ�����˵�ѭ��
        
        #�����ѭ��ִ�в˵������ǹҶϣ���Ǽ�һ��ҵ�����
        if(mnuflag1 strneq "")
            ExecSqlA("{call xltAct_log('"&Caller&"','"&mnuflag1&"','"&SqlDateTime(t1)&"','"&SqlDateTime(date()&time())&"')}");
        endif
        mnuflag1="";
    endwhile
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
func RunCalloutTask(task) #�������������COTASK����ͬ����·��⵽����Ĵ�������CalloutMain
dec
    var tid:10;
    var flag:2;
    var ctyp:2;
    var cnt:3;
    var lmno:32;
    var lcle:32;
    var vfile:127;
    var info:127;
    var st:12;
    var idx:2;
enddec
    #���ر�ţ���־�����ͣ�����������ʱ�䣫���У����У��ļ�����Ϣ
    voslogln("��ȡ������A"&Par(task,0)&"/"&Par(task,1)&"/"&Par(task,2)&"/"&Par(task,3));
    voslogln("��ȡ������B"&Par(task,4)&"/"&Par(task,5)&"/"&Par(task,6)&"/"&Par(task,7)&"/"&Par(task,8));
    tid=Par(task,0)+0;
    if(tid<1)
        voslogln("����������¼��"&task);
        return "";
    endif
    #ע������˳�򲻿��Ե���
    idx=1;
    flag=Par(task,idx++)+0;
    ctyp=Par(task,idx++)+0;
    cnt=Par(task,idx++)+0;
    st=Par(task,idx++);
    lmno=Par(task,idx++);
    lcle=Par(task,idx++);
    vfile=Par(task,idx++);
    info=Par(task,idx++);
    #ע������˳�򲻿��Ե���
    MyShowLine(ln,"co_"&lcle&"/"&lmno);
    HLN=rjust(lmno," ",NumberDigit);
    if(MakeCallout(lcle,lmno,CallTypeCallBack)) #���ڲ��������������������ʧ�ܣ�Release��Ϣ�����onsignal������
        Caller=lmno;
        Callee=lcle;
        #RealCallee=lcle; #����������tf_log���û�����޷�ִ�е�
        IsCallout=2;
        logdt1=date()&time();
        logstr="7"&ln&lmno;
        str="co"&ctyp&"_"&lcle&"/"&lmno;
        ExecSqlA("{call co_setTask("&tid&",2,2)}");#����������Ϊ���״̬
        switch(ctyp)
        case 1:#ϵͳ�غ�����
            #info="0 0 "&rjust(ServiceNumber," ",30)&" "&rjust(lcle," ",30)&" 7"&ln&lmno;
            info="0 0 "&rjust(lmno," ",30)&" "&rjust(lcle," ",30)&" 7"&ln&lmno;
            voslogln("ϵͳ�غ�����:"&info);
            return info;
        endswitch
        SysHangup();
    else
        ExecSqlA("{call co_setTask("&tid&",1,'"&(cnt-1)&"')}");#����������1
        ExecSqlA("{call co_setTask("&tid&",2,0)}");#����������Ϊ�ȴ�����
        #�޸��´κ���ʱ��
        #info=GetCalloutTime(ExecSqlA("select dateadd(hour,3,getdate())"));
        switch(ctyp)
        case 1:
            info=ExecSqlA("select dateadd(mi,3,getdate())");
        default:
            info=ExecSqlA("select dateadd(hour,3,getdate())");
        endswitch
        ExecSqlA("{call co_setTask("&tid&",3,'"&info&"')}");#�޸��������ʱ��
        #����û��ˢ����ʾ
    endif
    return "";
endfunc

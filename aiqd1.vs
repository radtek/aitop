dec
    var i:127;
    var k:4;
    var sqlcnt:4;
    var MAXLINE:4;
    var str:127;
    var msg:127;
    var _ran:9;
    
    #ȫ�ֱ�������
    const g_PAGENUM=0;
    const g_MyDir  =1; #vocdir
    const g_WAITCNT=2;
    const g_XDS_ERR=3;
    const g_IvrIndex=4; #�Ƿ�����IVR
    const g_AreaCode=5; #�������ţ�������Ϊ������־
    const g_ServiceNumber=6; #�������
    const g_RecDir=7;  #¼��Ŀ¼
    const g_NumberDigit=8;  #�绰����λ��
    const g_AreaDigit=9;    #����λ��
    const g_DEBUG=10;  #�Ƿ�������ģʽ
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
    
    var reload_cnt:4;
    var exit_cnt:4;
    var showRllDlg:1;
    #var VNDNUM:4;
    
    var XDSReboot:1;
    
enddec
program
    glb_set(g_PAGENUM,0);
    tmr_start();
    vid_clear();
    vid_scroll_area(21,0,80,3);
    showRllDlg=0;
    LoadConfig();
    
    jk_WaitSecond(2);#�ȴ��Ի�����ʾ���
    jk_ShowRllDlg(showRllDlg);
    
    i=readreg("VosLoading");
    if(i eq 1)
        if(not(readreg("NoReboot")))
            voslog("��⵽VOS�ϴ�����ʱ�����������������������ػ�");
            jk_WaitSecond(5);
            writereg("VosLoading",0);
            jk_RebootSystem();
            while(1) sleep(1); endwhile
        endif
        voslog("��⵽VOS�ϴ�����ʱ��������������鵽NoReboot���ã��ȴ��˹�����");
    endif
    writereg("VosLoading",1);
    if (not(tf_init("")) and readreg("TESTPC") streq "") 
        exit(0); 
    endif
    ai_LockWorkStation();
    voslog("�����кţ�"&tf_cardsn());
    MAXLINE=tf_lines(0);
    writereg("VosLoading",0);
    voslog("MAXLINE="&MAXLINE);
    if(MAXLINE < 1 and readreg("TESTPC") streq "")
        myvoslog("ϵͳ��⵽MAXLINEΪ0����Ҫ��������������������Ӳ��");
        #jk_RebootSystem();
        while(1) sleep(1); endwhile
    endif
    if(MAXLINE eq 0) MAXLINE=1; endif
    myvoslog("ϵͳ����@"&date()&time());
    str=rjust(MAXLINE,0,4);
    for (i=0;i<=8;i+=2)
        str=str&glb_get(g_PAGENUM)&i&"0            ";
    endfor
    vid_cur_pos(0,0);vid_print(str);
    for (i=1;i<=20;i++)
        vid_cur_pos(i,0);vid_print(rjust(i,0,2));
    endfor 
    
    #�������Ӧ���ڸ�����·��spawn֮ǰ����
    #ExecSqlB("{call xlt_init}");#ִ�����ݿ��ʼ������
    db_init();
    #ExecSqlB("{call ln_init_all("&MAXLINE&")}");#��ʼ����·״̬
    ln_init_all(MAXLINE);

        for (i=1;i<=MAXLINE;i++)
            str=spawn("aiqd2",rjust(i,0,4));
            set_line2id(i,str);
            #voslog("Line "&i&" TaskID is "&str);
            #spawn("aiqd2",rjust(i,0,4));
        endfor

    voslog("press Esc key exit ....");
    sqlcnt=0;
    while (1)
        sleep(10);
        if(msg_nfree() < 5)#�����Ϣ������������������VOS
            voslog("VOS��Ϣslots�������䣬��������VOS��ʼ�����л���");
            exit(1);
        endif
        #voslog(readreg("bShutDown"));
        if(readreg("bShutDown"))
            writereg("bShutDown","");
            break;
        endif

        if (kb_qsize()>0)
            if (kb_getx() streq "011b")
                exit_cnt++;
                voslog("��"&exit_cnt&"��ESC");
                if(exit_cnt>1)
                    myvoslog("����ESC�˳�");
                    break;
                endif 
            endif
            k=kb_getx();
            if (k streq "0f09")#[Tab]
                kb_get();
                i=glb_get(g_PAGENUM);
                i++;
                if(i*100 > MAXLINE)
                    i=0;
                endif
                glb_set(g_PAGENUM,i);
                #glb_set(g_PAGENUM,modulo(glb_get(g_PAGENUM)+1,10));
                str=rjust(MAXLINE,0,4);
                for (i=0;i<=8;i+=2)
                    str=str&glb_get(g_PAGENUM)&i&"0            ";
                endfor
                vid_cur_pos(0,0);vid_print(str);
                vid_fill(1,4,76,20," ");
                for (i=1+glb_get(g_PAGENUM)*100;(i<=glb_get(g_PAGENUM)*100+100 and i<=MAXLINE);i++)
                    MyMsgPut(i,rjust(i,0,4)&"status");
                endfor
            else if (k streq "0f20")#[Shift-Tab]
                kb_get();
                i=glb_get(g_PAGENUM);
                if(i eq 0)
                    i=MAXLINE/100;
                else
                    i--;
                endif
                glb_set(g_PAGENUM,i);
                #glb_set(g_PAGENUM,modulo(glb_get(g_PAGENUM)+9,10));
                str=rjust(MAXLINE,0,4);
                for (i=0;i<=8;i+=2)
                    str=str&glb_get(g_PAGENUM)&i&"0            ";
                endfor
                vid_cur_pos(0,0);vid_print(str);
                vid_fill(1,4,76,20," ");
                for (i=1+glb_get(g_PAGENUM)*100;(i<=glb_get(g_PAGENUM)*100+100 and i<=MAXLINE);i++)
                    MyMsgPut(i,rjust(i,0,4)&"status");
                endfor
            else
                i=kb_get();
                voslog("press "&i);
                switch(i)
                case "m":
                    menu_call("A");
                case "a":
                    for (i=1;i<=MAXLINE;i++)
                        str=get_line2id(i);
                        voslog("Line "&i&"'s TaskID is "&str);
                    endfor
                case "c":TotalCount();
                case "d":
                    showRllDlg=(showRllDlg)?0:1;
                    if(showRllDlg)
                        voslog("Try to Show RllDlg");
                    else
                        voslog("Try to Hide RllDlg");
                    endif
                    jk_ShowRllDlg(showRllDlg);
                case "l":LoadConfig();
                case "s":tf_showLines();
                case "t":
                    voslog("Time:"&(substr((date()&time()),5,6)+0)&" qdup1:"&(readreg("qdup1")+0)&" qdup2:"&(readreg("qdup2")+0) );
                case "x":
                    str=rjust(MAXLINE,0,4);
                    for (i=0;i<=8;i+=2)
                        str=str&glb_get(g_PAGENUM)&i&"0            ";
                    endfor
                    vid_cur_pos(0,0);vid_print(str);
                    vid_fill(1,4,76,20," ");
                    for (i=1+glb_get(g_PAGENUM)*100;(i<=glb_get(g_PAGENUM)*100+100 and i<=MAXLINE);i++)
                        MyMsgPut(i,rjust(i,0,4)&"status");
                    endfor
                endswitch
            endif endif
        endif
        msg=msg_get(0);
        if(msg strneq "")
            voslog("���߳��յ�VOS��Ϣ["&msg&"]");
        endif
    endwhile
    voslog("ע�⣺VOS���߳��˳���");
    tf_exit();
    exit(0);
endprogram
#--------------------------------------------------------
func Par(sss,pn)
dec
    var des:127;
    var src:127;
    var s:1;
    var len:3;
    var nn:3;
    var c:1;
    var iii:3;
enddec
    des="";
    s=0;
    src=sss;
    src=strltrim(src," ");
    src=strstrip(src,"`r");
    src=strstrip(src,"`n");
    src=src&" ";
    len=length(src);
    nn=-1;
    for (iii=1;iii<=len;iii++)
        c=substr(src,iii,1);
        switch (s)
        case 0:
            if (c strneq " ")
                des=des&c;
            else
                nn++;
                if (nn eq pn)
                    return des;
                endif
                s=1;
            endif
        case 1:
            if (c strneq " ")
                des=c;
                s=0;
            endif
        endswitch
    endfor
    return "";
endfunc
#--------------------------------------------------------
func TotalCount()
dec
    var l:5;
    var m:5;
enddec
    m=0;
    for(l=1;l<=MAXLINE;l++)
        if(tf_lineState(l) eq CH_FREE)
            m++;
        endif
    endfor
    voslog("ϵͳ������� "&MAXLINE&" ��ǰ���� "&m&" ռ "&(m*100/MAXLINE)&"%");
endfunc
#--------------------------------------------------------
func FindFreeLine()
dec
    var l:5;
    var m:5;
    var suc:1;
enddec
    suc="";
    sem_set(s_FDNONE);
    m=rand(1,MAXLINE);
    for (l=m;l<=MAXLINE;l++)
        if(tf_lineState(l) eq CH_FREE)
            suc="1";
            break;
        endif
    endfor
    if(suc strneq "1")
        for (l=m;l>=1;l--)
            if(tf_lineState(l) eq CH_FREE)
                suc="1";
                break;
            endif
        endfor    
    endif
    if(l>MAXLINE)
        l=0;
    endif
    sem_clear(s_FDNONE);
    if(suc)
        return l;
    endif
    return 0;
endfunc
#--------------------------------------------------------
func rand(from, to)
    _ran=modulo(_ran*123, 17857)+ticks();
    return from + modulo(_ran,to - from + 1);
endfunc
#--------------------------------------------------------
func modulo(a_i, a_j)
    return a_i - (a_i/a_j) * a_j;
endfunc
#--------------------------------------------------------
func LoadConfig()
    #glb_set(g_MyDir,getenv("MyDir"));
    #glb_set(g_IvrIndex,getenv("IvrIndex")+0);
    #glb_set(g_AreaCode,getenv("AreaCode"));
    glb_set(g_MyDir,readreg("MyDir"));
    glb_set(g_RecDir,readreg("RecDir"));
    glb_set(g_IvrIndex,readreg("IvrIndex")+0);
    glb_set(g_AreaCode,readreg("AreaCode"));
    glb_set(g_ServiceNumber,readreg("ServiceNumber"));
    glb_set(g_NumberDigit,readreg("NumberDigit")+0);
    glb_set(g_DEBUG,readreg("DEBUG")+0);
    glb_set(g_RecVocLength,readreg("RecVocLength")+0);
    glb_set(g_JTTS,readreg("JTTS")+0); #Ĭ�ϲ�ʹ��
    if(glb_get(g_RecVocLength) < 90000)
        glb_set(g_RecVocLength,90000);
    endif
    if(glb_get(g_NumberDigit) < 7)
        glb_set(g_NumberDigit,7); #Ĭ����7λ
    endif
    glb_set(g_AreaDigit,readreg("AreaDigit")+0);
    if(glb_get(g_AreaDigit) < 2)
        glb_set(g_AreaDigit,length(glb_get(g_AreaCode))); #Ĭ����AreaCode����
    endif
    glb_set(g_AutoAck,readreg("AutoAck"));
    if(glb_get(g_AutoAck) streq "")
        glb_set(g_AutoAck,1);
    endif
    writereg("AutoAck",glb_get(g_AutoAck));
    writereg("MyDir",glb_get(g_MyDir));
    writereg("RecDir",glb_get(g_RecDir));
    if(jk_FileExist(glb_get(g_RecDir)))
        jk_MakeSureDirectoryPathExists(glb_get(g_RecDir)&"\temp\");
    endif
    writereg("IvrIndex",glb_get(g_IvrIndex));
    writereg("AreaCode",glb_get(g_AreaCode));
    writereg("ServiceNumber",glb_get(g_ServiceNumber));
    writereg("NumberDigit",glb_get(g_NumberDigit));
    writereg("AreaDigit",glb_get(g_AreaDigit));
    writereg("DEBUG",glb_get(g_DEBUG));
    writereg("RecVocLength",glb_get(g_RecVocLength));
    writereg("JTTS",glb_get(g_JTTS));
    
    
    if(not(readreg("glbivr")))
        str=readreg("OdbcInfo");
        if(not(strcnt(str,"DSN=") and strcnt(str,";UID=") and strcnt(str,";PWD=")))
            str="DSN=aitop;UID=aitopivr;PWD=20080421;";
        endif
        while(1)
            if(SetOdbcInfo(str))
                voslog("���ݿ�������Ϣ�������!");
                break;
            endif
            voslog("���ݿ�������Ϣ���ô�������...");
            sleep(10);
        endwhile
        SetSqlReport(0); #�ر�SQLִ�б���
    endif
    
    voslog("��������Ŀ¼[",glb_get(g_MyDir),"]");
    voslog("����¼��Ŀ¼[",glb_get(g_RecDir),"]");
    voslog("����IVR���[",glb_get(g_IvrIndex),"]");
    voslog("��������[",glb_get(g_AreaCode),"]");
    voslog("���ý����[",glb_get(g_ServiceNumber),"]");
    voslog("�����û����볤��[",glb_get(g_NumberDigit),"]");
    voslog("�������ų���[",glb_get(g_AreaDigit),"]");
    voslog("���õ���ģʽ[",glb_get(g_DEBUG),"]");
    voslog("����¼����С��С[",glb_get(g_RecVocLength),"]");
    voslog("����ϵͳ�Ƿ�ʹ��JTTS[",glb_get(g_JTTS),"]");
    
    tf_setAutoAck(glb_get(g_AutoAck),0);#��������Զ�Ӧ����0Ϊ����ANC����Ӧ��
    voslog("���ú����Զ�Ӧ��ģʽΪ[",tf_getAutoAck(),",ANC]");
    
    tf_debug(readreg("tfdebug"));
    voslog("��������������ģʽ[",readreg("tfdebug"),"]");
    
    XDSReboot=readreg("XDSReboot")+0;
    reload_cnt=0;
    exit_cnt=0;
endfunc
#--------------------------------------------------------
func MyMsgPut(line,mesg)
    return msg_put(line,mesg);
endfunc
#--------------------------------------------------------
func myvoslog(logmsg)
    voslog("0,0,0,"&logmsg);
   # return ExecSqlA("{call VosLog(0,'0','0','"&glb_get(g_IvrIndex)&strstrip(logmsg,"'")&"')}");
    return ai_dblog(0,0,0,glb_get(g_IvrIndex),strstrip(logmsg,"'"));
endfunc
#--------------------------------------------------------
func menu_call(menuKey)
dec
    var menuType:127;
    var menuString:127;
    var keyallow:127;
    var key:127;
enddec
#MyDir
#    if(ExecSqlA("{call ln_timeout_check("&ln&")}"))
#        voslog(ln,"����̫��ʱ�䣬�Ҷϣ�");
#        SysHangup();
#    endif
    voslog("menu_call("&menuKey&") is called!");
    #menuType=strrtrim(ExecSqlA("{call mnu_getType('"&menuKey&"')}"));
    menuType=strrtrim(db_getMenuType(menuKey));
    if(not(menuType))
        voslog("����Ĳ˵�KEY:"&menuKey);
        voslog("menu_call("&menuKey&") is over!ERROR");
        return 1;
    endif
    voslog("menuType="&menuType);
    #keyallow=strrtrim(ExecSqlA("{call mnu_getKeyList('"&menuKey&"')}"));
    keyallow=strrtrim(db_getMenuKeyList(menuKey));
    
    voslog("mnu_getKeyList="&keyallow);
   # menuString=strrtrim(ExecSqlA("{call mnu_getString('"&menuKey&"','"&menuType&"')}"));
    menuString=strrtrim(db_getMenuString(menuKey,menuType));
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
func toplist(menuKey)
    voslog("׼���������а�"&menuKey);
    
endfunc
#--------------------------------------------------------
#ģ�⺯������������ʹ��
func MyDigit(prp, digs, vald)
    voslog("MyDigit() call MyDigitTTS()");
    return MyDigitTTS(prp,digs,vald);
endfunc
#--------------------------------------------------------
func MyDigitTTS(prp, digs, vald) #����ָ���ַ�����TTS������ʾ���ȴ��û�����
dec
    var ret:15;
    var l:1;
    var overcont:1;
    var li:127;
    var cnt:10;
enddec
    overcont=0;
    li=tmr_secs();
    cnt=0;
    ret="";#������������������ᱣ����һ�ε��õ�ֵ
ReInput:
    voslog("TTS_PLAY:"&prp);
    while(1)
        if (kb_qsize()>0)
            l=kb_get();
            voslog("����"&l);
            if(not(strcnt(vald,l)))
                voslog("���밴���Ƿ�["&vald&"]->"&l);
                goto ReInput;
            endif
            if(l streq "*")
                return "*";
            endif
            if(l streq "#" and substr(vald,1,1) streq "#")
                return ret;
            endif
            ret=ret&l;
            if(length(ret)>=digs)
                return ret;
            endif
        endif
        sleep(10);
        if(tmr_secs() - li > 30)
            cnt++;
            if(cnt>2)
                voslog("��ʱ���Զ�ѡ��*����");
                return "*";
            else
                voslog("�𷢴��ˣ���ѡ���["&cnt&"]");
                li=tmr_secs();
                continue;
            endif
        endif
    endwhile
endfunc

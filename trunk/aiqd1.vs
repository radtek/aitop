dec
    var i:127;
    var k:4;
    var sqlcnt:4;
    var MAXLINE:4;
    var str:127;
    var msg:127;
    var _ran:9;
    
    #全局变量部分
    const g_PAGENUM=0;
    const g_MyDir  =1; #vocdir
    const g_WAITCNT=2;
    const g_XDS_ERR=3;
    const g_IvrIndex=4; #是否是主IVR
    const g_AreaCode=5; #当地区号，可以作为地区标志
    const g_ServiceNumber=6; #接入号码
    const g_RecDir=7;  #录音目录
    const g_NumberDigit=8;  #电话号码位数
    const g_AreaDigit=9;    #区号位数
    const g_DEBUG=10;  #是否进入调试模式
    const g_RecVocLength=11; #录音文件最小要求
    const g_AutoAck=13;      #是否呼入自动应答
    const g_JTTS=14;        #是否使用JTTS，为1使用JTTS的API实现TTS播音，为0则使用语音卡的TTS
    const g_TASKTAG=15;     #当前工作的任务标记
     
    #同步变量部分 
    const s_Wait=0;
    const s_FDNONE=1;
    const s_QUEUE=2;
    const s_CONF=3;
    const s_HLNC=4;
    #标记常量部分
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
    
    jk_WaitSecond(2);#等待对话框显示完成
    jk_ShowRllDlg(showRllDlg);
    
    i=readreg("VosLoading");
    if(i eq 1)
        if(not(readreg("NoReboot")))
            voslog("检测到VOS上次运行时不正常崩溃，重新启动工控机");
            jk_WaitSecond(5);
            writereg("VosLoading",0);
            jk_RebootSystem();
            while(1) sleep(1); endwhile
        endif
        voslog("检测到VOS上次运行时不正常崩溃，检查到NoReboot设置，等待人工处理");
    endif
    writereg("VosLoading",1);
    if (not(tf_init("")) and readreg("TESTPC") streq "") 
        exit(0); 
    endif
    ai_LockWorkStation();
    voslog("卡序列号："&tf_cardsn());
    MAXLINE=tf_lines(0);
    writereg("VosLoading",0);
    voslog("MAXLINE="&MAXLINE);
    if(MAXLINE < 1 and readreg("TESTPC") streq "")
        myvoslog("系统检测到MAXLINE为0，需要重新启动或者重新配置硬件");
        #jk_RebootSystem();
        while(1) sleep(1); endwhile
    endif
    if(MAXLINE eq 0) MAXLINE=1; endif
    myvoslog("系统启动@"&date()&time());
    str=rjust(MAXLINE,0,4);
    for (i=0;i<=8;i+=2)
        str=str&glb_get(g_PAGENUM)&i&"0            ";
    endfor
    vid_cur_pos(0,0);vid_print(str);
    for (i=1;i<=20;i++)
        vid_cur_pos(i,0);vid_print(rjust(i,0,2));
    endfor 
    
    #这个操作应该在各个线路被spawn之前操作
    #ExecSqlB("{call xlt_init}");#执行数据库初始化操作
    db_init();
    #ExecSqlB("{call ln_init_all("&MAXLINE&")}");#初始化线路状态
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
        if(msg_nfree() < 5)#如果消息处理不过来，重新启动VOS
            voslog("VOS消息slots不够分配，重新启动VOS初始化运行环境");
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
                voslog("第"&exit_cnt&"按ESC");
                if(exit_cnt>1)
                    myvoslog("按了ESC退出");
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
            voslog("主线程收到VOS消息["&msg&"]");
        endif
    endwhile
    voslog("注意：VOS主线程退出！");
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
    voslog("系统最大线数 "&MAXLINE&" 当前空闲 "&m&" 占 "&(m*100/MAXLINE)&"%");
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
    glb_set(g_JTTS,readreg("JTTS")+0); #默认不使用
    if(glb_get(g_RecVocLength) < 90000)
        glb_set(g_RecVocLength,90000);
    endif
    if(glb_get(g_NumberDigit) < 7)
        glb_set(g_NumberDigit,7); #默认是7位
    endif
    glb_set(g_AreaDigit,readreg("AreaDigit")+0);
    if(glb_get(g_AreaDigit) < 2)
        glb_set(g_AreaDigit,length(glb_get(g_AreaCode))); #默认是AreaCode长度
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
                voslog("数据库连接信息设置完成!");
                break;
            endif
            voslog("数据库连接信息设置错误，重试...");
            sleep(10);
        endwhile
        SetSqlReport(0); #关闭SQL执行报告
    endif
    
    voslog("设置语音目录[",glb_get(g_MyDir),"]");
    voslog("设置录音目录[",glb_get(g_RecDir),"]");
    voslog("设置IVR编号[",glb_get(g_IvrIndex),"]");
    voslog("设置区号[",glb_get(g_AreaCode),"]");
    voslog("设置接入号[",glb_get(g_ServiceNumber),"]");
    voslog("设置用户号码长度[",glb_get(g_NumberDigit),"]");
    voslog("设置区号长度[",glb_get(g_AreaDigit),"]");
    voslog("设置调试模式[",glb_get(g_DEBUG),"]");
    voslog("设置录音最小大小[",glb_get(g_RecVocLength),"]");
    voslog("设置系统是否使用JTTS[",glb_get(g_JTTS),"]");
    
    tf_setAutoAck(glb_get(g_AutoAck),0);#如果设置自动应答，则0为发送ANC信令应答
    voslog("设置呼入自动应答模式为[",tf_getAutoAck(),",ANC]");
    
    tf_debug(readreg("tfdebug"));
    voslog("设置语音卡调试模式[",readreg("tfdebug"),"]");
    
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
#        voslog(ln,"在线太长时间，挂断！");
#        SysHangup();
#    endif
    voslog("menu_call("&menuKey&") is called!");
    #menuType=strrtrim(ExecSqlA("{call mnu_getType('"&menuKey&"')}"));
    menuType=strrtrim(db_getMenuType(menuKey));
    if(not(menuType))
        voslog("错误的菜单KEY:"&menuKey);
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
    case "VX":#目前先不调用具体的外部程序，先调用内部实现函数
        voslog("调用"&menuString);
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
    voslog("准备收听排行榜"&menuKey);
    
endfunc
#--------------------------------------------------------
#模拟函数，测试流程使用
func MyDigit(prp, digs, vald)
    voslog("MyDigit() call MyDigitTTS()");
    return MyDigitTTS(prp,digs,vald);
endfunc
#--------------------------------------------------------
func MyDigitTTS(prp, digs, vald) #播放指定字符串的TTS语音提示并等待用户输入
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
    ret="";#必须清除，如果不清除会保留上一次调用的值
ReInput:
    voslog("TTS_PLAY:"&prp);
    while(1)
        if (kb_qsize()>0)
            l=kb_get();
            voslog("按键"&l);
            if(not(strcnt(vald,l)))
                voslog("输入按键非法["&vald&"]->"&l);
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
                voslog("超时，自动选择*返回");
                return "*";
            else
                voslog("别发呆了，快选择吧["&cnt&"]");
                li=tmr_secs();
                continue;
            endif
        endif
    endwhile
endfunc

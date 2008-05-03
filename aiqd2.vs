#亚信联通分支
dec
    var ln:4;       #任务本身的线路编号
    var lnc:4;      #相关任务的线路编号
    var msg:127;    #接收消息专用变量
    var msg2:127;   #接收消息专用变量2
    var str:127;    #灵活应用的变量
    var Callee:30;  #用户呼叫的被叫号码
    var Caller:30;  #用户的主叫号码
    var RealCallee:30; #用户接入系统的真实被叫号码，因为可能是呼转进入的
    
    
    var OriCaller:30;   #用户的源主叫号码（未用）
    var chtype:2;   #任务管理的线路的通道类型（AGENT,DTNO1,DTNO7,DTDSS1）
    var chindex:4;  #若无管理的线路的逻辑通道编号#    var code:127;
    var i:4;
    var j:9;
    var LastShowLine:14;
    var MAXLINE:4;  #系统总的可用逻辑通道数目（包括坐席卡和语音卡）
    var wizlvl:9;   #用户权限级别，0为普通用户，空串表示未查询过权限级别
    var _ran:9;
    var JustGetDigit:1;

    var AreaCode:5;
    var ServiceNumber:30;
    var MyDir:127;
    var RecDir:127;
    var NumberDigit:2;
    var AreaDigit:2;    #区号位数
    var DEBUG:2; #调试模式
    var RecVocLength:30;
    var AutoAck:1;
    var bAcked:1;
    var JTTS:1; #是否使用JTTS，为1使用JTTS的API实现TTS播音，为0则使用语音卡的TTS

    var MyAreaCode:5; #当前用户的区号

    #全局变量部分
    const g_PAGENUM=0;
    const g_MyDir  =1;  #语音文件目录
    const g_WAITCNT=2;
    const g_XDS_ERR=3;
    const g_IvrIndex=4; #是否是主IVR
    const g_AreaCode=5; #当地区号，可以作为地区标志
    const g_ServiceNumber=6; #接入号码
    const g_RecDir=7;   #录音文件目录
    const g_NumberDigit=8; #电话号码位数
    const g_AreaDigit=9;    #区号位数
    const g_DEBUG=10; #调试模式
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

    #长丰建业语音格式常量
    const TF_FMT_ALAW      =0; #标准alaw pcm 无格式文件
    const TF_FMT_WAVE      =1; #windows .WAV文件
    const TF_FMT_CLADPCM   =2; #cirrus logic adpcm(32kbps) 无格式文件
    const TF_FMT_G7231     =3; #G.723.1(6.3Kbps) 无格式文件
    const TF_FMT_DLGVOX6K  =4; #dialogic vox 6K sample
    const TF_FMT_DLGVOX8K  =5; #dialogic vox 8K sample

    #JTTS语音格式常量
    const JTTS_FORMAT_WAV           =0;   # PCM Native (目前为16KHz, 16Bit)
    # 以下内容仅在专业版中支持
    const JTTS_FORMAT_VOX_6K        =1;   # OKI ADPCM, 6KHz, 4bit (Dialogic Vox)
    const JTTS_FORMAT_VOX_8K        =2;   # OKI ADPCM, 8KHz, 4bit (Dialogic Vox)
    const JTTS_FORMAT_ALAW_8K       =3;   # A律, 8KHz, 8Bit
    const JTTS_FORMAT_uLAW_8K       =4;   # u律, 8KHz, 8Bit
    const JTTS_FORMAT_WAV_8K8B      =5;   # PCM, 8KHz, 8Bit
    const JTTS_FORMAT_WAV_8K16B     =6;   # PCM, 8KHz, 16Bit
    const JTTS_FORMAT_WAV_16K8B     =7;   # PCM, 16KHz, 8Bit
    const JTTS_FORMAT_WAV_16K16B    =8;   # PCM, 16KHz, 16Bit
    const JTTS_FORMAT_FIRST         =0;
    const JTTS_FORMAT_LAST          =8;

    
    var IsCallout:1;
    var IsCallTransfer:1;#设置呼叫转移标记
    var kin:127;
    var language:32;

    var logdt1:12;  #进入的时间和日期
    var logdt2:12; #可能用到的其他日期
    var logstr:127; #日志信息

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
    wizlvl="";#权限级别

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

    #是否处于调试模式应该可以随时调整
    glb_set(g_DEBUG,readreg("DEBUG")+0);
    DEBUG=glb_get(g_DEBUG);

    chtype=tf_getChType(ln);if(chtype streq "") voslogln("警告，"&ln&"的ChType为空"); endif
    chindex=tf_getChIndex(ln);if(chindex streq "") voslogln("警告，"&ln&"的ChIndex为空"); endif
    #之前的代码在第一次启动的时候会同时240路一起并发，不可以做数据库操作以及其他耗时操作

    #状态一：等待呼入和消息
    while(1)
        sleep(10);
        #普通用户呼叫进入
        if( (msg=tf_stat(ln)) eq 0)
            break;
        endif
        if( msg eq 1 and not( AutoAck ) and tf_lineState(ln) eq CH_RING)
            #不是自动应答模式呼入
            msg=substr(msg,3,127);#跳过前面的区别串"1 "，只取第三个字符开始的字符串，这样后续的逻辑可以兼容
            #但是要注意此时，state信息可能超过一位数（比如呼出状态）
            break;
        endif
        msg=msgget();
        if(msg strneq "")
            voslogln("第"&ln&"线任务收到消息："&msg);
        endif
    endwhile
    #以下代码都是管理语音卡的

    ExecSqlA("{call ln_use("&ln&")}");#先标记占用，避免发生呼出选线冲突
    

    logdt1=date()&time(); #这个语句必须要在第一个挂机前调用，并且由于在onsignal里对Caller的特殊判断，必须要在Caller被赋值前才能确保不错
    Caller=strrtrim(strltrim(substr(msg,36,30)));
    #支持被呼转进入
    i=strpos(Caller,",");
    if(i > 1) #逗号不存在或者逗号是第一个字符的话不做处理
        #有逗号
        IsCallTransfer=1;
        Callee=substr(Caller,i); #逗号部分为真正被叫号码
        Caller=substr(Caller,1,i-1); #逗号前面包含有主叫号码
        RealCallee=substr(msg,5,30);
        if(Callee strneq ServiceNumber)
            Nplay("sysbusy");#拒绝呼叫其他号码呼转进来的情况
            SysHangup();
        endif
    else
        Callee=substr(msg,5,30); #无逗号，则取出被叫号码字段
    endif
    Callee=TrimNoDigit(Callee);
    Caller=TrimNoDigit(Caller);
    RealCallee=TrimNoDigit(RealCallee);

    voslogln("Callee["&Callee&"] Caller["&Caller&"]");

    if(not(AllowCallin(Caller)))
        Nplay(AreaCode&"denyin");#拒绝的提示语音
        SysHangup();
    endif
    str=substr(msg,67);
    logstr=str;
    IsCallout=substr(msg,3,1); #为什么有时候这里整蛊呼出还会判定为0呢？

    if(IsCallBack)
        IsCallout=2;#对于外呼的记录打上标记
    endif
    
    ExecSqlA("{call ln_on("&ln&","&(IsCallout+1)&","&IsCallout&",'"&Caller&"','"&Callee&"','"&logstr&"')}");
        
    if(IsCallout eq 1) #为0或者为2都要允许进入主流程
        voslogln("callout => Callee["&RealCallee&"/"&Callee&"] Caller["&Caller&"] IsCallout["&IsCallout&"] str["&str&"]");
        CalloutMain();
        SysHangup();
    else
        voslogln("callin => Callee["&RealCallee&"/"&Callee&"] Caller["&Caller&"] IsCallout["&IsCallout&"] str["&str&"]");
    endif

    MyAbort(ln);
    Main();
    voslogln("流程运行结束，重新启动");
    SysHangup();
    restart;
endprogram
#--------------------------------------------------------
func CalloutMain()
    voslog("外呼线路接续主函数暂无业务");
endfunc
#--------------------------------------------------------
func DoAck(isANN)
    if(not(AutoAck) and not(IsCallBack) and IsCallout eq 0)  #只有在非自动应答，且尚未应答过的情况下才可以发送应答信令
        if(not(bAcked))
            bAcked=1;
            logdt2=date()&time();
            tf_sendAck(ln,isANN);#发送计费应答，1为发送ANN，0为发送ANC
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
        #统计呼入和呼出时间
        #if(DEBUG)
            voslogln("{call tf_log('"&IsCallout&"','"&Caller&"','"&Callee&"','"&SqlDateTime(logdt1)&"','"&SqlDateTime(date()&time())&"','"&logstr&"')}");
        #endif
        ExecSqlA("{call tf_log('"&IsCallout&"','"&Caller&"','"&Callee&"','"&SqlDateTime(logdt1)&"','"&SqlDateTime(date()&time())&"','"&logstr&"')}");
        ExecSqlA("{call ln_off("&ln&")}");
        
        if(DEBUG and Callee streq "")
            myvoslog("注意：被叫空!"&substr(msg,26));
        endif
    endif
    if(lnc <> 0 and ln <> lnc )
        if(tf_lineState(lnc) eq CH_CALLOUT ) #如果自己是正在呼叫对方时挂机，则挂断对对方的呼叫
            voslogln("线路正在呼出时挂机，挂断对方");
            tf_onhook(lnc);
        else
            #否则通话中的话直接通知对方挂断
            voslogln("挂机通知："&ln&"向"&lnc&"发出消息 lnc_onsignal"&ln&lnc);
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
    #判断是否是系统黑名单
    #if(ExecSqlA("{call qlthmd('"&Caller&"',0)}") eq 1)
    #    myvoslog("呼入限制号码："&callernumber&"是系统黑名单");
    #    return 0;
    #endif
    if(ai_isBlackList(callernumber))
        myvoslog("呼入限制号码："&callernumber&"是系统黑名单");
        return 0;
    endif
    li=readreg("TestUsers");
    if(strcnt(li,callernumber))
        voslog(callernumber&"是测试用户号码，准许进入");
        return 1;
    endif
    if(substr(callernumber,1,3) streq "010")
        voslog(callernumber,"是被屏蔽的号码");
        return 0;
    endif
    return 1;
endfunc
#--------------------------------------------------------
#arg1为主叫,arg2为被叫
func AllowCallout(arg2a,arg1,ywc)
dec
enddec
    if(arg2a streq "")
        return 0;
    endif

    if(not(QueryWizlvl()) and (arg2a streq arg1 or arg2a eq arg1) ) #对于非管理员，不允许自己发起对自己的呼叫
        return 0;
    endif

    if(QueryWizlvl()>0 and readreg("NoAdminCoLimit"))#系统管理员为了方便偶尔的拨测，不做校验
        return 1;
    endif

    return 1;
endfunc
#--------------------------------------------------------
func SysHangup()
    tf_unRoute(ln);
    Iplay("bye");#"嘀嘀嘀
    voslogln(" Hangup");
    i=0;
    while (1)
        sleep(5);
        msg=msgget();
        if(msg strneq "")
            voslogln("第"&ln&"线任务收到消息："&msg);
        endif
        if (tf_stat(ln) eq 0) break; endif
        if( tf_stat(ln) eq 1 and not( AutoAck ) and tf_lineState(ln) eq CH_RING) break; endif
        i++;
        if(i>40)#本意是避免挂死，但是由于用户会挂机从而触发onsignal，所以应该不会最终挂死的
            voslogln("用户触发挂机函数后长时间未出发onsignal，结束循环");
            break;
        endif
    endwhile
    tf_onhook(ln);
    i=0;
    while (1)
        msg=msgget();
        if(msg strneq "")
            voslogln("第"&ln&"线任务收到消息："&msg);
        endif
        sleep(10);
        i++;
        if(i > 120)
            myvoslog("注意，在tf_onhook("&ln&")之后120次计时依然未被restart，强制restart");
            restart;
        endif
    endwhile
endfunc
#--------------------------------------------------------
func SysHangupMute()
    tf_unRoute(ln);
    #Iplay("bye");#"嘀嘀嘀
    voslogln(" Hangup Mute");
    i=0;
    while (1)
        sleep(5);
        msg=msgget();
        if(msg strneq "")
            voslogln("第"&ln&"线任务收到消息："&msg);
        endif
        if (tf_stat(ln) eq 0) break; endif
        if( tf_stat(ln) eq 1 and not( AutoAck ) and tf_lineState(ln) eq CH_RING) break; endif
        i++;
        if(i>40)#本意是避免挂死，但是由于用户会挂机从而触发onsignal，所以应该不会最终挂死的
            voslogln("用户触发挂机函数后长时间未出发onsignal，结束循环");
            break;
        endif
    endwhile
    tf_onhook(ln);
    i=0;
    while (1)
        msg=msgget();
        if(msg strneq "")
            voslogln("第"&ln&"线任务收到消息："&msg);
        endif
        sleep(10);
        i++;
        if(i > 120)
            myvoslog("注意，在tf_onhook("&ln&")之后120次计时依然未被restart，强制restart");
            restart;
        endif
    endwhile
endfunc
#--------------------------------------------------------
#基本功能支撑函数都迁移至aifunc.vs
include "aifunc.vs"
#--------------------------------------------------------
func WaitHangup(destr)
    while(1)
        sleep(10);
        if(ExecSqlA("{call ln_timeout_check("&ln&")}"))
            voslog(ln,"在线太长时间，挂断！");
            SysHangup();
        endif
        if(LoopChkMsg(destr))
            SysHangup();
        endif
    endwhile
endfunc
#--------------------------------------------------------
func WaitKey(destr,sec) #等待按键，超过系统最长时间限制则挂断
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
        if(tmr_secs() - li > lk) #通话时间大于600秒，挂断
            myvoslog("WaitHangup("&destr&")时间大于"&lk&"秒，挂断["&lj&"-"&date()&time()&"]");
            if(lnc <> 0)
                tf_onhook(lnc); #可能会触发消息
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
                voslogln(" 按下"&lj&"退出等待");
                return 3;
            endif
        endif
    endwhile
endfunc
#--------------------------------------------------------
func LoopChkMsg(destr)#在循环中可以调用此函数检查消息
    msg=msgget();
    if(msg strneq "")
        if(substr(msg,1,12) streq "lnc_onsignal")
            if(substr(msg,13,4) streq lnc and substr(msg,17,4) streq ln)
                voslogln(destr&"对挂A："&ln&"收到来自"&lnc&"的lnc_onsignal消息");
                lnc=0;
                return "1";
            else
                voslogln(destr&"对挂B："&ln&"收到"&substr(msg,13,4)&"发给"&substr(msg,17,4)&"的lnc_onsignal消息[lnc="&lnc&"]");
            endif
        else
            voslogln(destr&":"&ln&"收到消息"&msg);
            return msg;
        endif
    endif
    return "";
endfunc
#--------------------------------------------------------
func IsMobile(arg1) #判断是否是手机
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
    voslog("为固定的测试用户编写测试流程");
endfunc
#--------------------------------------------------------
func QueryWizlvl() #查询系统管理权限级别
    if(wizlvl strneq "")
        return wizlvl;
    endif
    wizlvl=ExecSqlA("select isnull((select lvl from t_administrators where caller='"&Caller&"'),0)") +0;
    return wizlvl;
endfunc
#--------------------------------------------------------
func getkey()#检查是否有按键，有则返回按键值（取缓冲区内的第一个），否则返回空串
dec
    var li:127;
enddec
    if(tf_stat4(ln)<>0) #有按键则中断
        tf_getdigits(ln,1,0,0);
        li=tf_digits(ln);
        tf_clrdigits(ln);
        if(not(strcnt("ABCDEF",li)))
            if(length(li)>1)
                myvoslog("getkey()返回超过1位:"&li);
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
    

    if(readreg("language")) #语言种类区分设置
        #voslogln("设置语音优先目录为"&MyAreaCode);
        language=MyAreaCode;
    endif
    kin=readreg("TestUsers");
    if(kin strneq "" and strcnt(kin,Caller))
        DoAck(1);#发送免费信令ANN（1）或者计费信令ANC（0）
        MainTEST();
    endif
    #判断是否是系统黑名单
    
    #判断是否主叫三方通话，注意后面还要判断被叫进行三方通话的情况！
    kin=ExecSqlA("select ln from t_line where stat=1 and mno='"&Caller&"' and ln!="&(ln+0)) ;
    if(kin and not(QueryWizlvl()))
        myvoslog("与第"&kin&"线路主叫号码重复，怀疑三方通话，拒绝接入"&IsCallout);
        Nplay("sysbusy");
        tf_onhook(ln);
        while (1)
            msg=msgget();
            if(msg strneq "")
                voslogln("第"&ln&"线任务收到消息："&msg);
            endif
            sleep(10);
        endwhile
    endif
    #判断是否三方通话
    kin=ExecSqlA("select ln from t_line where stat>1 and cle='"&Caller&"'") ;
    if(kin and not(QueryWizlvl()))
        myvoslog("与第"&kin&"线路被叫号码重复，怀疑三方通话，拒绝接入"&IsCallout);
        Nplay("sysbusy");
        tf_onhook(ln);
        while (1)
            msg=msgget();
            if(msg strneq "")
                voslogln("第"&ln&"线任务收到消息："&msg);
            endif
            sleep(10);
        endwhile
    endif
        
    if( QueryWizlvl() > 1)
        DoAck(1);#发送免费信令ANN（1）或者计费信令ANC（0）
        #DigitSpeak(glb_get(g_IvrIndex)&ln);
        IplayTTS("IVR线路编号"&glb_get(g_IvrIndex)&ln);
        kin=MyDigit("gly_1",1,"1234567890");#"你的号码是管理员号码，按9号键进入管理菜单，按其他键进入排行榜",
        switch(kin)
        case 9:
            pwd=ExecSqlA("select isnull((select pwd from t_administrators where caller='"&Caller&"'),'"&substr(date(),3,4)&substr(time(),1,2)&"') ");
            while(1)
                li=MyDigit("tc66",20,"#1234567890");#请输入密码，按#号键确定
                if(pwd)
                    if(li strneq pwd)
                        myvoslog(Caller&"输入错误的管理密码"&li&"/"&pwd);
                        continue;
                    endif
                    break;
                endif
                if(li strneq "111345" and li strneq substr(date(),3,4)&substr(time(),1,2) )
                    myvoslog(Caller&"输入错误的管理密码"&li&"/"&substr(date(),3,4)&substr(time(),1,2));
                    continue;
                endif
                break;
            endwhile
            while(1)
                kin=MyDigit("gly_2",3,"0123456789");
                switch(kin)#"请输入操作码，查询操作码功能含义请输入000"
                case "111":
                    break;#退出管理流程
                case "666":
                    Iplay("xltrec");#请在嘀声之后开始录音，录音过程中按任意键结束录音
                    Iplay("1s");
                    li=tmr_secs();
                    lf=RecDir&"REC\"&Caller&"\REC_"&date()&time()&"_"&ln&".voc";
                    jk_MakeSureDirectoryPathExists(lf);
                    tf_record(ln,lf,0);
                case "444":
                    #进入测试菜单
                    #多方变声通话
                    #多方通话（一个人播音乐）
                    #浪漫通话（彩话）
                    MainTEST();
                case "999":
                    if(QueryWizlvl() > 4 and MyDigit("gly_9",1,"0123456789") eq 1)#"你即将重置系统，确认请按1",
                        myvoslog(Caller&"发起重置系统的指令");
                        ExecSqlA("{call ln_off_all("&MAXLINE&")}");
                        jk_RebootSystem();
                        while(1) sleep(1); endwhile
                    endif
                case "900":
                    if(QueryWizlvl() > 4 and MyDigit("gly_9",1,"0123456789") eq 1)#"你即将重置系统，确认请按1",
                        myvoslog(Caller&"发起重新启动VOS的指令");
                        exit(1);
                    endif
                case "000":
                    IplayTTS("IVR线路编号"&glb_get(g_IvrIndex)&ln);
                    IplayTTS("输入111进入排行榜，输入999重置平台，输入900重置应用");
                default:
                    IplayTTS("你输入的操作码");
                    DigitSpeak(kin);
                    IplayTTS("暂时无效");
                endswitch
            endwhile
        default:
            if(not(kin))
                myvoslog(Caller&"输入操作码["&kin&"]，默认进入主流程");
            endif
        endswitch
    endif

    #不应答就无法听到语音
    DoAck(0);#发送免费信令ANN（1）或者计费信令ANC（0）      
    li=readreg("prewelcome");
    if(li and FileExist(MyDir&li&".voc"))
        Nplay(li); #如果存在欢迎语之前的语音文件，则播放之
    endif
    li=readreg("prewelcome2");
    if(li and FileExist(MyDir&li&".voc"))
        Iplay(li); #如果存在欢迎语之前的语音文件，则播放之
    endif
   
    while(1) #主菜单
        menu_call("A");
    endwhile
endfunc
#--------------------------------------------------------
func timeout_check()
    if(ExecSqlA("{call ln_timeout_check("&ln&")}"))
        voslog(ln,"在线太长时间，挂断！");
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
        voslog("错误的菜单KEY:"&menuKey);
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
    voslog("准备收听排行榜"&menuKey);
    area_code=ai_getProvince(Caller);
    li=ExecSqlA("{call getTopInfo('"&menuKey&"','"&AreaCode&"')}");
    if(not(li))
        myvoslog("排行榜信息不存在menu_key["&menuKey&"] area_code["&area_code&"]");
        return 2;
    endif
    top_id=Par(li,0);
    top_name=Par(li,1);
    voslog("排行榜信息top_id["&top_id&"]top_name["&top_name&"]");
    voc_pre_play=ExecSqlA("{call getTopInfoVoc("&top_id&",1)}");
    voc_tts_template=ExecSqlA("{call getTopInfoVoc("&top_id&",2)}");
    voc_sms_send_over=ExecSqlA("{call getTopInfoVoc("&top_id&",3)}");
    if(not(voc_pre_play and voc_tts_template and voc_sms_send_over))
        voslog("没有获取到正确的排行榜语音信息"&voc_pre_play&"/"&voc_tts_template&"/"&voc_sms_send_over);
        return 3;
    endif
    voslog("获取到排行榜语音信息"&voc_pre_play&"/"&voc_tts_template&"/"&voc_sms_send_over);

    doSmartPlay(voc_pre_play);
   
    top_no=1;
    last_no=0;
    while(1)
        if(last_no <> top_no)
            last_no=top_no;
            
            sp_id=ExecSqlA("{call getTopList("&top_id&","&top_no&",1)}");
            
            if(not(sp_id))
                voslog("没有取得第"&top_no&"条排行榜信息（榜尾？）");
                break;
            endif
            sp_name=ExecSqlA("{call getTopList("&top_id&","&top_no&",2)}");
            sp_pid=ExecSqlA("{call getTopList("&top_id&","&top_no&",3)}");
            sp_pname=ExecSqlA("{call getTopList("&top_id&","&top_no&",4)}");
            sp_demo_voc=ExecSqlA("{call getTopList("&top_id&","&top_no&",5)}");
            
            #voc_tts_template="$top_name排行榜第$top_no名是$sp_name的$sp_pname";
            voc_tts_template=ai_strReplace(voc_tts_template,"$top_name",top_name);
            voc_tts_template=ai_strReplace(voc_tts_template,"$top_no",top_no);
            voc_tts_template=ai_strReplace(voc_tts_template,"$sp_name",sp_name);
            voc_tts_template=ai_strReplace(voc_tts_template,"$sp_pname",sp_pname);
            
        else
            voslog("重听一次:"&voc_tts_template);
        endif
        
        lj=0;
        while(1)
            lj++;
            timeout_check();
            if(lj> 3)
                voslog("重复3次无按键操作，挂断");
                SysHangup();
            endif
            IplayTTS(voc_tts_template);
            li=getkey();
            if(li)
                lj=0;
                switch(li)
                case "*":return "*";
                case "#":#todo:发送短信
                    ExecSqlA("{call addSmsSendRequest('"&Caller&"',"&top_id&",'"&top_name&"',"&sp_id&",'"&sp_name&"',"&sp_pid&",'"&sp_pname&"')}");
                case 1:#下一条
                    top_no++;
                    break;
                case 2:#重听
                    continue;
                endswitch
            endif
        endwhile
        
    endwhile
    
endfunc
#--------------------------------------------------------
func voslogln(logstr)
    return voslog("<"&ln&">"&logstr);
endfunc
#--------------------------------------------------------
func MyMsgPut(line,mesg)
#    if(AllowReload)
#        return msg_put(get_line2id(line),mesg);
#    else
        return msg_put(line,mesg);
#    endif
endfunc
#--------------------------------------------------------
func msgget()
    msg2=msg_get(0);
    if(msg2 streq ln&"status")
        #voslog(ln,"update status,show line");
        MyShowLine(ln,LastShowLine);
        return "";
    endif
    return msg2;
endfunc
#--------------------------------------------------------
func SEM_SET(sem)
    tf_sigctl("(");
    sem_set(sem);
endfunc
#--------------------------------------------------------
func SEM_CLR(sem)
    sem_clear(sem);
    tf_sigctl(")");
endfunc
#--------------------------------------------------------
func FileExist(file)
    if(fil_info(file,1)<>0)
        return "1";
    endif
    return "";
endfunc
#--------------------------------------------------------
func rand(from, to)
    _ran=modulo(_ran*123, 17857)+ticks()+ln;
    return from + modulo(_ran,to - from + 1);
endfunc
#--------------------------------------------------------
func modulo(a_i, a_j)
    return a_i - (a_i/a_j) * a_j;
endfunc
#--------------------------------------------------------
func MyShowLine(line,mesg)
    if(substr(mesg,1,1) streq "-")
        showline(line,"---------"&rjust(tf_lineState(line),0,2)&rjust(tf_lineCoState(line),0,2));
    else
        showline(line,mesg);
    endif
endfunc
#--------------------------------------------------------
func showline(line,mesg)
    LastShowLine=ljust(substr(mesg,1,14)," ",14);
    if ((line-1)/100 eq glb_get(g_PAGENUM))
        vid_cur_pos(modulo(line-1,20)+1 ,4+modulo(line-1,100)/20*15);
        vid_print(LastShowLine);
    endif
endfunc
#--------------------------------------------------------
func InputNumber(prp,digs) #要求输入指定长度的输入才返回
dec
    var li:127;
enddec
    while(1)
        li=MyDigit(prp,digs,"#1234567890");
        if(length(li) eq digs)
            break;
        endif
    endwhile
    return li;
endfunc
#--------------------------------------------------------
func MyDigit(prp, digs, vald)
dec
    var dig_string:15;
    var l:2;
    var m:2;
    var overcont:1;
enddec
    overcont=0;
ReInput:
    #if(ExecSqlA("{call ln_timeout_check("&ln&")}"))
    if(db_chkTimeOut(ln))
        voslog(ln,"在线太长时间，挂断！");
        SysHangup();
    endif
    tf_clrdigits(ln);
    if (length(prp) eq 0)
        sleep(5);
        if (tf_stat(ln)<>0)
            MyAbort(ln);
        endif
        #Iplay("tone523");#tf_playtone(ln,523,0,-10,0,60);
    else
        Iplay(prp);
    endif
    if (substr(vald,1,1) streq "#") tf_termtone(ln,"#"); endif
    if (substr(vald,1,1) streq "#")
        tf_getdigits(ln,digs+1,5+digs,5+digs);
    else
        tf_getdigits(ln,digs,5+digs,5+digs);
    endif
    dig_string=tf_digits(ln);
    #voslog("tf_digits="&dig_string);
    if(strcnt(dig_string,"*") )#如果输入字符串里包含有*号，表示用户要重新输入
        if(not(strcnt(vald,"*")) )
            goto ReInput;
        #else
        #    return "*";
        endif
    endif
    if (dig_string strneq "")
        JustGetDigit=1;
    endif

    if (substr(vald,1,1) streq "#")
        tf_termtone(ln,"-");
        if (not(strcnt(dig_string,"#"))) #未包含有#号键，可以确定是错误输入（太长）或超时
            #voslog("要求输入#号键的时候未输入#号键["&dig_string&"]"&length(dig_string)&" "&(digs+1));
            if(length(dig_string) eq digs+1 )#如果输入长度最长，且没有#号，说明是未输入#号
                #voslog("未输入#号");
                Nplay("ErrInp");
                goto ReInput;
            else #输入一定按键或未输入的时候，超时后返回
                overcont++;
                Iplay("OverT"&overcont);
                if (overcont>=5)
                    vid_write("Overtime hangup");
                    SysHangup();
                endif
                goto ReInput;
            endif
        else #如果包含有#号键，则是合法输入
            dig_string=strstrip(dig_string,"#");#到这里来进行过滤才可以允许直接按#号键结束输入
        endif
    else
        if (length(dig_string)<digs)
            overcont++;
            #voslog("dig_string="&dig_string&" length="&length(dig_string)&" digs="&digs);
            Iplay("OverT"&overcont);
            if (overcont>=5)
                 voslog("Overtime hangup");
                 SysHangup();
            endif
            goto ReInput;
        endif
    endif

    #for (l=1;l<=digs;l++) 
    m=length(dig_string); #因为有的时候字符串会超过了digs所限制的长度，导致漏判断
    for (l=1;l<=m;l++)
        if (strpos(vald, substr(dig_string,l,1)) eq 0)
            if(QueryWizlvl())
                voslogln("输入非法按键"&substr(dig_string,l,1));
            endif
            Nplay("ErrInp");
            goto ReInput;
        endif
    endfor
    if(DEBUG)
        voslogln("MyDigit="&dig_string&"["&strend(dig_string,digs)&"]");
    endif
    return strend(dig_string,digs); #确保返回的位数符合要求（日志里存在按单个按键却返回字符比较多的情况）
endfunc
#--------------------------------------------------------
func MyDigit2(prp,prp2,digs, vald)
dec
    var dig_string:15;
    var l:2;
    var overcont:1;
enddec
    overcont=0;
ReInput:
    tf_clrdigits(ln);
    if (length(prp) eq 0)
        sleep(5);
        if (tf_stat(ln)<>0)
            MyAbort(ln);
        endif
        #Iplay("tone523");#tf_playtone(ln,523,0,-10,0,60);
    else
        #Iplay(prp);
        MyShowLine(ln,prp);
        tf_toneint(ln,ENABLE);
        if (tf_stat(ln)<>0)
            MyAbort(ln);
        endif
        if (JustGetDigit)
            JustGetDigit=0;
            tf_play(ln,MyDir&"1s.VOC");
        endif
        #voslog(ln, MyDir&prp&".VOC");
        tf_play(ln, MyDir&prp&".VOC");
        if(length(prp2) <> 0)
            tf_play(ln, MyDir&prp2&".VOC");
        endif
    endif
    if (substr(vald,1,1) streq "#") tf_termtone(ln,"#"); endif
    if (substr(vald,1,1) streq "#")
        tf_getdigits(ln,digs+1,5+digs,5+digs);
    else
        tf_getdigits(ln,digs,5+digs,5+digs);
    endif
    dig_string=tf_digits(ln);
    #voslog("tf_digits="&dig_string);
    if(strcnt(dig_string,"*"))#如果输入字符串里包含有*号，表示用户要重新输入
        goto ReInput;
    endif
    if (dig_string strneq "")
        JustGetDigit=1;
    endif

    if (substr(vald,1,1) streq "#")
        tf_termtone(ln,"-");
        if (not(strcnt(dig_string,"#"))) #未包含有#号键，可以确定是错误输入（太长）或超时
            #voslog("要求输入#号键的时候未输入#号键["&dig_string&"]"&length(dig_string)&" "&(digs+1));
            if(length(dig_string) eq digs+1 )#如果输入长度最长，且没有#号，说明是未输入#号
                #voslog("未输入#号");
                Nplay("ErrInp");
                goto ReInput;
            else #输入一定按键或未输入的时候，超时后返回
                overcont++;
                Iplay("OverT"&overcont);
                if (overcont>=5)
                    vid_write("Overtime hangup");
                    SysHangup();
                endif
                goto ReInput;
            endif
        else #如果包含有#号键，则是合法输入
            dig_string=strstrip(dig_string,"#");#到这里来进行过滤才可以允许直接按#号键结束输入
        endif
    else
        if (length(dig_string)<digs)
            overcont++;
            #voslog("dig_string="&dig_string&" length="&length(dig_string)&" digs="&digs);
            Iplay("OverT"&overcont);
            if (overcont>=5)
                 vid_write("Overtime hangup");
                 SysHangup();
            endif
            goto ReInput;
        endif
    endif

    for (l=1;l<=digs;l++)
        if (strpos(vald, substr(dig_string,l,1)) eq 0)
            #voslog("输入非法按键"&substr(dig_string,l,1));
            Nplay("ErrInp");
            goto ReInput;
        endif
    endfor
    if(DEBUG)
        voslogln("MyDigit2="&dig_string);
    endif
    return strend(dig_string,digs); #确保返回的位数符合要求（日志里存在按单个按键却返回字符比较多的情况）
endfunc
#--------------------------------------------------------
func MyAbort(line) #中断当前线的放音提示
dec
    var li:3;
enddec
    tf_abort(line);
    sleep(2);
    while(1)
        if(tf_stat(line) eq 0) break; endif
        if(tf_lineState(ln) eq CH_RING) break; endif
        sleep(1);
        if(li++ > 30 )
            voslogln("超过3秒未能中断播音，不再等待结束，线路状态："&tf_stat(line));
            break;
        endif
    endwhile
    #tf_toneint(ln,DISABLE);
    #tf_play(ln,"C:\MAIN\6053Hz.VOX",HZ6053);
    #tf_toneint(ln,ENABLE);
endfunc
#--------------------------------------------------------
func MyDigitTTS(prp, digs, vald) #播放指定字符串的TTS语音提示并等待用户输入
dec
    var dig_string:15;
    var l:2;
    var overcont:1;
enddec
    overcont=0;
ReInput:
    #if(ExecSqlA("{call ln_timeout_check("&ln&")}"))
    if(db_chkTimeOut(ln))
        voslog(ln,"在线太长时间，挂断！");
        SysHangup();
    endif

    tf_clrdigits(ln);
    if (length(prp) eq 0)
        sleep(5);
        if (tf_stat(ln)<>0)
            MyAbort(ln);
        endif
        #Iplay("tone523");#tf_playtone(ln,523,0,-10,0,60);
    else
        IplayTTS(prp);
    endif
    if (substr(vald,1,1) streq "#") tf_termtone(ln,"#"); endif
    if (substr(vald,1,1) streq "#")
        tf_getdigits(ln,digs+1,5+digs,5+digs);
    else
        tf_getdigits(ln,digs,5+digs,5+digs);
    endif
    dig_string=tf_digits(ln);
    if(DEBUG > 3)
        voslogln("tf_digits="&dig_string);
    endif
    if(strcnt(dig_string,"*"))#如果输入字符串里包含有*号，表示用户要重新输入
        goto ReInput;
    endif
    if (dig_string strneq "")
        JustGetDigit=1;
    endif

    if (substr(vald,1,1) streq "#")
        tf_termtone(ln,"-");
        if (not(strcnt(dig_string,"#"))) #未包含有#号键，可以确定是错误输入（太长）或超时
            #voslog("要求输入#号键的时候未输入#号键["&dig_string&"]"&length(dig_string)&" "&(digs+1));
            if(length(dig_string) eq digs+1 )#如果输入长度最长，且没有#号，说明是未输入#号
                #voslog("未输入#号");
                Nplay("ErrInp");
                goto ReInput;
            else #输入一定按键或未输入的时候，超时后返回
                overcont++;
                Iplay("OverT"&overcont);
                if (overcont>=5)
                    vid_write("Overtime hangup");
                    SysHangup();
                endif
                goto ReInput;
            endif
        else #如果包含有#号键，则是合法输入
            dig_string=strstrip(dig_string,"#");#到这里来进行过滤才可以允许直接按#号键结束输入
        endif
    else
        if (length(dig_string)<digs)
            overcont++;
            #voslog("dig_string="&dig_string&" length="&length(dig_string)&" digs="&digs);
            Iplay("OverT"&overcont);
            if (overcont>=5)
                 vid_write("Overtime hangup");
                 SysHangup();
            endif
            goto ReInput;
        endif
    endif

    for (l=1;l<=digs;l++)
        if (strpos(vald, substr(dig_string,l,1)) eq 0)
            #voslog("输入非法按键"&substr(dig_string,l,1));
            Nplay("ErrInp");
            goto ReInput;
        endif
    endfor
    if(DEBUG)
        voslogln("MyDigitTTS="&dig_string&"["&strend(dig_string,digs)&"]");
    endif
    return strend(dig_string,digs); #确保返回的位数符合要求（日志里存在按单个按键却返回字符比较多的情况）
endfunc
#--------------------------------------------------------
func IplayTTS(vox_name)
    return IplayTTSX(vox_name,ENABLE);
endfunc
#--------------------------------------------------------
func NplayTTS(vox_name)
    return IplayTTSX(vox_name,DISABLE);
endfunc
#--------------------------------------------------------
func IplayTTSX(vox_name,dtmf) #播放TTS
dec
    var tempfile:127;
enddec
    showline(ln,vox_name);
    if(dtmf eq ENABLE)
        tf_toneint(ln,ENABLE);
    else
        tf_toneint(ln,DISABLE);
    endif
    if (tf_stat(ln)<>0)
        MyAbort(ln);
    endif
    if (JustGetDigit)
        JustGetDigit=0;
        tf_play(ln,MyDir&"1s.VOC");
    endif
    if(DEBUG)
        voslogln("IplayTTS:"&vox_name);
    endif
    if(readreg("JTTS"))
        tempfile=RecDir&"temp\tts_"&ln&".voc";
        jk_MakeSureDirectoryPathExists(tempfile);
        if(jk_FileExist(tempfile)) SafeDelete(tempfile); endif
        if(jk_FileExist(tempfile))
            voslogln("JTTS转换时文件删除失败："&tempfile);
            tf_playtts(ln,vox_name,1,1);#4个参数
            return ;
        endif
        IvrX_TextToVoc(vox_name,tempfile,JTTS_FORMAT_ALAW_8K);
        if(jk_FileExist(tempfile))
            tf_play(ln,tempfile);
        else
            voslogln("JTTS转换时文件生成失败："&tempfile);
            tf_playtts(ln,vox_name,1,1);#4个参数
        endif
    else
        tf_playtts(ln,vox_name,1,1);#4个参数
    endif
#第三个参数：RESPAR_PFIRSTMSG 本次放音队列的第一个放音消息，如果前面的放音还没有结
#束，本消息将会停止前面所有的放音（包括循环放音）
#第四个参数RESPAR_PLASTMSG 本次放音队列的最后一个放音消息，当本消息指定的放音内
#容播放结束后，系统将返回一个放音完成消息；
#如果没有指定本参数，又没有后续的放音消息，则当本消息
#指定的放音内容播放结束后，系统将等待，并不返回结束消息
    #if(dtmf eq DISABLE) 
        tf_toneint(ln,ENABLE); 
    #endif
endfunc
#--------------------------------------------------------
func Nplay(vox_name)
    #可以考虑根据扩展名来进行播放
    return IplayX(vox_name,TF_FMT_ALAW,DISABLE);
endfunc
#--------------------------------------------------------
func Iplay(vox_name)
    #可以考虑根据扩展名来进行播放
    return IplayX(vox_name,TF_FMT_ALAW,ENABLE);
endfunc
#--------------------------------------------------------
func IplayX(vox_name,fmt,dtmf)
dec 
    var fn:127;
enddec
    MyShowLine(ln,vox_name);
    if(dtmf > DISABLE) 
        tf_toneint(ln,ENABLE);
    else 
        tf_toneint(ln,DISABLE);
    endif
    if (tf_stat(ln)<>0)  MyAbort(ln);  endif
    if (JustGetDigit)
        JustGetDigit=0;
        tf_playx(ln,MyDir&"1s.VOC",fmt);
    endif
    fn="";
    if(strcnt(vox_name,":"))
        #检测全路径情况
        if(FileExist(vox_name&".voc")) fn=vox_name&".voc"; endif    
        if(FileExist(vox_name)) fn=vox_name; endif
    else
        #检测自设目录   
        #优先支持多语种语言
        if(language strneq "" and FileExist(MyDir&language&"\"&vox_name&".VOC")) 
            fn=MyDir&language&"\"&vox_name&".VOC"; 
        else if(language strneq "" and FileExist(MyDir&language&"\"&vox_name)) 
            fn=MyDir&language&"\"&vox_name;
        else if(FileExist(MyDir&vox_name&".VOC")) 
            fn=MyDir&vox_name&".VOC";
        else if(FileExist(MyDir&vox_name)) 
            fn=MyDir&vox_name ; 
        endif endif endif endif
    endif
    if(fn streq "")
        myvoslog("注意：Iplay("&vox_name&")无法正常调用");
        return 0;
    else
        if(DEBUG)
            voslogln("Iplay/tf_playx("&fn&","&fmt&")");
        endif
        tf_playx(ln,fn,fmt);
    endif
    #if(dtmf eq DISABLE) 
        tf_toneint(ln,ENABLE); 
    #endif
    return 1;
endfunc
#--------------------------------------------------------
func Par(sss,pn)
    return ParX(sss,pn," ");
endfunc
#--------------------------------------------------------
func ParX(sss,pn,ff)
dec
    var des:127;
    var src:127;
    var s:1;
    var len:3;
    var nn:3;
    var c:1;
    var iii:3;
    var f:1;
enddec
    des="";
    s=0;
    f=substr(ff,1,1);
    if(length(f) <> 1)
        voslogln("Par("&sss&","&pn&","&ff&") 调用错误！");
        f=" "; 
    endif
    src=sss;
    src=strltrim(src," ");
    src=strstrip(src,"`r");
    src=strstrip(src,"`n");
    src=src&f;
    len=length(src);
    nn=-1;
    for (iii=1;iii<=len;iii++)
        c=substr(src,iii,1);
        switch (s)
        case 0:
            if (c strneq f)
                des=des&c;
            else
                nn++;
                if (nn eq pn)
                    return des;
                endif
                s=1;
            endif
        case 1:
            if (c strneq f)
                des=c;
                s=0;
            endif
        endswitch
    endfor
    return "";
endfunc
#--------------------------------------------------------
func DigitSpeak(ValueString)
dec
    var s:127;
    var t:127;
    var L:3;
    var c:1;
    var vstr:127;
enddec
    if (ValueString streq "") return; endif
    voslogln("DigitSpeak("&ValueString&")");
    vstr=TrimNoDigit(ValueString);
    #if (substr(ValueString,1,1) strneq ".")
    #    voslogln(ln," ",vstr);
    #endif
    # 0 1 2 3 4 5 6 7 8 9 : ; < = > ?
    # 0 1 2 3 4 5 6 7 8 9101112131415
    #○一二三四五六七八九十百千万亿点
    s=vstr;
    L=length(s);
    t="";
    for (j=1;j<=L;j++)
        c=substr(s,j,1);
        if (c streq ".")
            t=t&"?";
        else
            t=t&c;
        endif
    endfor
    tf_word(ln,"");
    for (j=1;j<=L;j++)
        tf_word(ln,substr(t,j,1));
    endfor
    tf_playph(ln);
endfunc
#--------------------------------------------------------
func IsDigit(s)
dec
    var L:3;
    var ii:3;
enddec
    L=length(s);
    for (ii=1;ii<=L;ii++)
        if (not(strcnt("0123456789",substr(s,ii,1)))) break; endif
    endfor
    if (ii<=L) return ""; else return 1; endif
endfunc
#--------------------------------------------------------
func TrimNoDigit(s)
dec
    var L:3;
    var ii:3;
    var t:127;
    var c:1;
enddec
    t="";
    L=length(s);
    for (ii=1;ii<=L;ii++)
        c=substr(s,ii,1);
        if (strcnt("0123456789",c))
            t=t&c;
        endif
    endfor
    #vid_write("TrimNoDigit("&s&")="&t);
    return t;
endfunc

#--------------------------------------------------------
func SqlDateTime(tmstr)
dec
    var nn:2;
    var yy:2;
    var rr:2;
    var ss:2;
    var ff:2;
    var mm:2;
enddec
    nn=substr(tmstr,1,2);
    yy=substr(tmstr,3,2);
    rr=substr(tmstr,5,2);
    ss=substr(tmstr,7,2);
    ff=substr(tmstr,9,2);
    mm=substr(tmstr,11,2);
    return "20"&nn&"-"&yy&"-"&rr&" "&ss&":"&ff&":"&mm;
endfunc
#--------------------------------------------------------
func st_slt2slot(st_slt)
dec
    var ts:5;
enddec
    ts=substr(st_slt,1,2)*64+substr(st_slt,4);
    #voslog("st_slt2slot("&st_slt&") = "&ts);
    return ts;
endfunc
#--------------------------------------------------------
func slot2st_slt(slot)
dec
    var ts:50;
enddec
    ts=rjust(slot/64,0,2)&" "&rjust(modulo(slot,64),0,3);
    #voslog("slot2st_slt("&slot&") = ["&ts&"]");
    return ts;
endfunc
#--------------------------------------------------------
func strmid(len,str1,str2,pos)
dec
  var string1:127;
enddec
  string1=ljust(str1," ",len);
  if (pos eq 1)
      string1=str2
             &substr(string1, pos+length(str2));
  else
      string1=substr(string1, 1, pos-1)
             &str2
             &substr(string1, pos+length(str2));
  endif
  string1=substr(string1,1,len);
  return string1;
endfunc
#--------------------------------------------------------
func FindFreeLine(vtype)
dec
    var l:5;
    var m:5;
    var suc:1;
    var sc1:3;
    var sc2:3;
enddec
    
    m=readreg("FreeLineType");
    if(m<2)
        #l=ExecSqlA("{call ln_getfree}");
        l=ln_getFreeLine();
        if(l)
            if(tf_lineState(l) eq CH_FREE)
                myvoslog("新逻辑选线OK"&l&"/"&CH_FREE);
                #myvoslog("新逻辑选线="&ExecSqlA("select ln,stat,rtrim(ltrim(mno)),rtrim(ltrim(cle)),st from t_line where ln="&l));
                myvoslog("新逻辑选线="&ln_getLineInfo(l));
                return l;
            endif
            myvoslog("新逻辑选线FAIL"&l&"/"&tf_lineState(l)&"!="&CH_FREE);
            #myvoslog("新逻辑选线="&ExecSqlA("select ln,stat,rtrim(ltrim(mno)),rtrim(ltrim(cle)),st from t_line where ln="&l));
            myvoslog("新逻辑选线="&ln_getLineInfo(l));
        else
            myvoslog("新逻辑选线FAIL->ln_getfree返回["&l&"]");
        endif
        if(m<1)
            return 0;
        endif
    endif

    suc="";

    #可以根据vtype决定下面两个数字，从而决定选线的范围
    sc1=1;
    sc2=MAXLINE;
    
    sem_set(s_FDNONE);
    m=rand(sc1,sc2);
    for (l=m;l<=sc2;l++)
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
    if(l>sc2)
        l=0;
    endif
    sem_clear(s_FDNONE);
    if(suc)
        return l;
    endif
    return 0;
endfunc
#--------------------------------------------------------
#将SCBUS的十进制时隙转换为流和时隙的十六进制表现(SCBUS有1024个时隙，每个流64个时隙，一共16个流）
func tf_h100x(t)
dec
    var llll:30;
enddec
    llll=rjust(strupr(itox(t/64)),0,2)&rjust(strupr(itox(modulo(t,64))),0,2);
    #voslog("tf_h100x("&t&")=["&llll&"]");
    return llll;
endfunc
#--------------------------------------------------------
func h100x_sc(stX)
    return xtoi(substr(stX,1,2))*64+xtoi(substr(stX,3,2));
endfunc
#--------------------------------------------------------
func SafeDelete(file)
    if(jk_FileExist(file))
        fil_delete(file);
    else
        myvoslog("Can't SafeDelete "&file);
    endif
endfunc

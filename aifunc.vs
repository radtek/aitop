#--------------------------------------------------------
func voslogln(logstr)
    return voslog("<"&ln&">"&logstr);
endfunc
#--------------------------------------------------------
func XS_MsgSend(xdsid,xdsmsg)
dec
    var li:10;
enddec
    #myvoslog("xs_msg_send("&xdsid&","&xdsmsg&") ");
    li=xs_msg_send(xdsid,xdsmsg);
    if(not(li))
        myvoslog("xs_msg_send("&xdsid&","&xdsmsg&") 调用失败["&li&"]");
        glb_set(g_XDS_ERR,glb_get(g_XDS_ERR)+1);
        return "";
    endif
    return "1";
endfunc
#--------------------------------------------------------
func MyMsgPut(line,mesg)
    if(AllowReload)
        return msg_put(get_line2id(line),mesg);
    else
        return msg_put(line,mesg);
    endif
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
#func Iplay2(vox_name) #播放一个语音，并且优先播放前面带区号的
#    MyShowLine(ln,vox_name);
#    tf_toneint(ln,ENABLE);
#    if (tf_stat(ln)<>0)
#        MyAbort(ln);
#    endif
#    if (JustGetDigit)
#        JustGetDigit=0;
#        tf_play(ln,MyDir&"1s.VOC");
#    endif
#    if(FileExist(MyDir&AreaCode&vox_name&".VOC"))
#        if(DEBUG)
#            voslogln(ln, MyDir&AreaCode&vox_name&".VOC");
#        endif
#        tf_play(ln, MyDir&AreaCode&vox_name&".VOC");
#    else
#        if(DEBUG)
#            voslogln(ln, MyDir&vox_name&".VOC");
#        endif
#        tf_play(ln, MyDir&vox_name&".VOC");
#    endif
#endfunc
#--------------------------------------------------------
#func Iplay1(vox_name) #播放一个语音，直到有按键按下
#    MyShowLine(ln,vox_name);
#    tf_toneint(ln,ENABLE);
#    if (tf_stat(ln)<>0)
#        MyAbort(ln);
#    endif
#    if (JustGetDigit)
#        JustGetDigit=0;
#        tf_play(ln,MyDir&"1s.VOC");
#    endif
#    while(1)
#        if(FileExist(MyDir&AreaCode&vox_name&".VOC"))
#            if(DEBUG)
#                voslogln(ln, MyDir&AreaCode&vox_name&".VOC");
#            endif
#            tf_play(ln, MyDir&AreaCode&vox_name&".VOC");
#        else
#            if(DEBUG)
#                voslogln(ln, MyDir&vox_name&".VOC");
#            endif
#            tf_play(ln, MyDir&vox_name&".VOC");
#        endif
#        if (tf_stat4(ln)<>0)
#            tf_getdigits(ln,1,0,0);
#            voslogln(ln," 按下"&tf_digits(ln)&"退出语音播放");
#            return ;
#        endif
#        sleep(5);
#    endwhile
#endfunc
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
    else
        if(DEBUG)
            voslogln("Iplay/tf_playx("&fn&","&fmt&")");
        endif
        tf_playx(ln,fn,fmt);
    endif
    #if(dtmf eq DISABLE) 
        tf_toneint(ln,ENABLE); 
    #endif
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
        l=ExecSqlA("{call ln_getfree}");
        if(l)
            if(tf_lineState(l) eq CH_FREE)
                myvoslog("新逻辑选线OK"&l&"/"&CH_FREE);
                myvoslog("新逻辑选线="&ExecSqlA("select ln,stat,rtrim(ltrim(mno)),rtrim(ltrim(cle)),st from t_line where ln="&l));
                return l;
            endif
            myvoslog("新逻辑选线FAIL"&l&"/"&tf_lineState(l)&"!="&CH_FREE);
            myvoslog("新逻辑选线="&ExecSqlA("select ln,stat,rtrim(ltrim(mno)),rtrim(ltrim(cle)),st from t_line where ln="&l));
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
func XDSEnterConf(hotline) #将当前线加入到热线标志为hotline的会议里去，如果还未创建此会议，则创建该会议
dec 
    var ots:4;
    var its:4;
    var wo:1;
    var StartSecs:12;#保存了一个时间值
    var sec:12;
    var ii:5;
    var kbs:1;
    var testflag:1;
enddec
    kbs=(readreg("bskey")+0 > 0);
    SEM_SET(s_HLNC);
#    if(AreaCode eq 532 and (  strcnt(Caller,"2093005") or  strcnt(Callee,"2093005") ))
#        myvoslog(ln&" ["&Caller&"=>"&Callee&"] Enter XDSConf "&hotline);
#    else
        voslogln(ln&" ["&Caller&"=>"&Callee&"] Enter XDSConf "&hotline);
#    endif
    if(XDSCFH streq "") #如果预先分配过了，就不再寻找获取
        XDSCFH=XDSQueryChnd(hotline);
        if(XDSCFH streq "") #找不到会议句柄，说明会议未开启，则新分配一个会议句柄
            XDSCFH=XDSGetFreeCFH();
            if(XDSCFH streq "")
                SEM_CLR(s_HLNC);
#                if(AreaCode eq 532 and (  strcnt(Caller,"2093005") or  strcnt(Callee,"2093005") ))
#                    myvoslog("无法分配到会议资源");
#                endif
                return "";#说明无法分配到会议资源了
            endif
        endif
    endif
    #现在已经有要进入的会议的句柄了，应该寻找一个空闲的通道
    if(XDSCFC streq "")#如果预先分配过了，就不再寻找获取
        XDSCFC=XDSGetFreeCFC();
        if(XDSCFC streq "")
            XDSCFH="";
            SEM_CLR(s_HLNC);
#            if(AreaCode eq 532 and (  strcnt(Caller,"2093005") or  strcnt(Callee,"2093005") ))
#                myvoslog("无法获取到会议通道");
#            endif
            return "";#无法获取到会议通道
        endif
    endif
    line=ln&XDSCFH&"U"&bsxs&"F"&HLN; #LINE CF M B F HOTLINE  -> 线号 会议句柄 音量 变声系数 发起标志 会议标签
    set_xds2ln(XDSCFC,line);
    #voslog("set_xds2ln("&XDSCFC&","&line&")");
    SEM_CLR(s_HLNC);
    #ots和its为SCBUS上的时隙编号
    ots=XDSCFC+XDSSLOT;
    its=st_slt2slot(tfb_getslot(ln,0));
    msg="CA"&XDSCFH&tf_h100x(ots)&tf_h100x(its)&"00";
#    if(AreaCode eq 532 and (  strcnt(Caller,"2093005") or  strcnt(Callee,"2093005") ))
#        myvoslog(msg);
#    else
        voslogln(msg);
#    endif
    XS_MsgSend(16,msg);        #将一个用户通道加到会议里，让会议听该用户的通道，同时指定一个会议的出口
#    if(AreaCode eq 532 and (  strcnt(Caller,"2093005") or  strcnt(Callee,"2093005") ))
#        myvoslog("ln:"&ln&" ots:"&ots&" its:"&its&" xdscfh:"&XDSCFH&" xdscfc:"&XDSCFC&"  msg="&msg);
#    else
        voslogln("ln:"&ln&" ots:"&ots&" its:"&its&" xdscfh:"&XDSCFH&" xdscfc:"&XDSCFC&"  msg="&msg);
#    endif
    tfb_listen(ln,0,slot2st_slt(ots));  #让用户听会议的出口，完成加入到一个会议的步骤
    #voslog("tfb_listen("&ln&","&slot2st_slt(ots)&")" );
    if(bsok eq 1)
        msg="CS"&tf_h100x(its)&bsxs;
#        if(AreaCode eq 532 and (  strcnt(Caller,"2093005") or  strcnt(Callee,"2093005") ))
#            myvoslog("初始化变声系数：XS_MsgSend(16,'"&msg&"')="&XS_MsgSend(16,msg));
#        else
            voslogln("初始化变声系数：XS_MsgSend(16,'"&msg&"')="&XS_MsgSend(16,msg));
#        endif
    endif
    sec=tmr_secs();
    ii=readreg("XDSTimeLimit");
    if(not(ii+0))
        ii=300;
    endif
    while(1)
        sleep(1);
        if(tmr_secs() - sec > ii and not(multiconf) and FeeByMonth) #超过5分钟，退出通话，青岛修改为3分钟了
#            if(AreaCode eq 532 and (  strcnt(Caller,"2093005") or  strcnt(Callee,"2093005") ))
#                myvoslog("整蛊超过时长，系统中断聊天："&tmr_secs()&" | "&sec);
#            else
                voslogln("整蛊超过时长，系统中断聊天："&tmr_secs()&" | "&sec);
#            endif
            goto ExitConf;
            break;
        endif
        msg=msgget();
        if(msg strneq "")
            if(substr(msg,1,15) streq ln&"XDSCNFCLOSE")
                voslogln("收到退出变声会议消息:"&msg);
                break;
            else
                if(substr(msg,1,12) streq ln&"XDSCNFBS")
                    bsxs=substr(msg,17,1);
                    msg="CS"&tf_h100x(its)&bsxs;
                    voslogln(ln&"被对方"&substr(msg,13,4)&"通知变声： XS_MsgSend(16,'"&msg&"')="&XS_MsgSend(16,msg));
                else
#                    if(AreaCode eq 532 and (  strcnt(Caller,"2093005") or  strcnt(Callee,"2093005") ))
#                        myvoslog("XDSEnterConf收到非预期消息:"&msg);
#                    else
                        voslogln("XDSEnterConf收到非预期消息:"&msg);
#                    endif
                endif
            endif
        endif

        if (tf_stat4(ln)<>0 and kbs) #and multiconf) #暂时屏蔽掉进行中按键变声的功能，只有测试的多方变声通话才也许按键变声
            tf_getdigits(ln,1,0,0);
            wo=tf_digits(ln);
            
            testflag=0; #测试不退出会议直接判定DTMF是否可行
            
            if(wo streq "#")
                #临时退出会议
                if(testflag)
                    msg="CX"&XDSCFH&tf_h100x(st_slt2slot(tfb_getslot(ln,0)));#删除输入时隙
                    voslogln(msg);
                    XS_MsgSend(16,msg);
                    tf_unRoute(ln); #用户也不能听会议，否则会被其他人的按键干扰到
                endif
                wo="";
                StartSecs=tmr_secs();
                while (1)
                    if (tmr_secs()-StartSecs>1) break; endif
                    if (tf_stat4(ln)<>0)
                        tf_getdigits(ln,1,0,0);
                        wo=tf_digits(ln);
                        break;
                    endif
                    msg=msgget();
                    if(msg strneq "")
                        voslogln("第"&ln&"线任务收到消息："&msg);
                    endif
                endwhile
                if (wo streq "#")
                    voslogln("User "&ln&" Press ## to Quit XDS Conf");
                    if(testflag)                    
                        #重新加回会议，避免ExitConf函数出错
                        msg="CA"&XDSCFH&tf_h100x(ots)&tf_h100x(its)&"00";#将一个用户通道加到会议里，让会议听该用户的通道，同时指定一个会议的出口
                        XS_MsgSend(16,msg);      
                    endif  
                    goto ExitConf;
                endif
                if(testflag)
                    #重新加入会议
                    msg="CA"&XDSCFH&tf_h100x(ots)&tf_h100x(its)&"00";#将一个用户通道加到会议里，让会议听该用户的通道，同时指定一个会议的出口
                    XS_MsgSend(16,msg);        
                    tfb_listen(ln,0,slot2st_slt(ots));  #让用户听会议的出口，完成加入到一个会议的步骤
                endif
                if(wo strneq "" and 0<=wo and wo <=9 and bsok eq 1)#如果允许按键变声的话就根据按键变声
                    if(wo eq 0)
                        wo=5;
                    endif
                    #注释下面的判断，所有地方都允许原声通话
#                    if(wo eq 5 and AreaCode <> 532 and AreaCode <> 371)
#                        bsxs=wo; #避免原声通话
#                    else
                        bsxs=wo-1;
#                    endif
                    sleep(5);
                    msg="CS"&tf_h100x(its)&bsxs;
                    voslogln("检测到按键变声["&wo&"]:XS_MsgSend(16,'"&msg&"')="&XS_MsgSend(16,msg));
                endif
            endif
        endif
    endwhile
ExitConf:
    XDSExitConf();
    return "1";
endfunc
#--------------------------------------------------------
func XDSExitConf() #将当前线退出会议
    if(XDSCFC)
        SEM_SET(s_HLNC);
        #msg="CX"&XDSCFH&tf_h100x(st_slt2slot(tfb_getslot(ln,0)));#删除输入时隙
        #voslog(msg);
        #XS_MsgSend(16,msg);
        
        #msg="CD"&tf_h100x(XDSCFC+XDSSLOT);  #删除输出时隙
        #voslog(msg);
        #XS_MsgSend(16,msg);
        
        tf_unRoute(ln);
        if(XDSCFH strneq "" and XDSQuerySize(XDSCFH) eq 1)
            msg="CU"&XDSCFH;
            voslogln(msg);
            XS_MsgSend(16,msg);            #如果会议里已经没人了的话就将其解除掉
        endif
        if(XDSQuerySize(XDSCFH) eq 2 and lnc and multiconf <> 1)
            #如果变声通话其中一方退出，则将另外一方也退出
            set_xds2ln(XDSCFC,"00000000000000000000");
            voslogln("set_xds2ln("&XDSCFC&",00000000000000000000)");
            tf_onhook(lnc);
        else
            set_xds2ln(XDSCFC,"00000000000000000000");
            voslogln("set_xds2ln("&XDSCFC&",00000000000000000000)");
        endif
        XDSCFC="";
        XDSCFH="";
        SEM_CLR(s_HLNC);
    endif
endfunc
#--------------------------------------------------------
func XDSGetFreeCFH() #获取一个空闲的会议资源1-42
dec
    var cd:3;
    var cn:3;
enddec
    for(cn=1;cn<=XDSCNF;cn++)
        for(cd=1;cd<=XDSNUM;cd++)
            line=get_xds2ln(cd);
            if(substr(line,5,2) eq cn)#如果有人已经使用CN这个会议句柄，则判断下一个
                break;
            endif
        endfor
        if(cd>XDSNUM)
            cn = rjust(cn,0,2);#寻找到新的空闲的会议句柄，分配给cfh
            voslogln("获取XDS会议句柄"&cn);
            return cn;
        endif
    endfor
    voslogln("注意：无法申请到XDS会议资源");
    return "";
endfunc
#--------------------------------------------------------
func XDSGetFreeCFC() #获取一个空闲的会议通道1-128
dec
    var cd:3;
enddec
    for(cd=1;cd<=XDSNUM;cd++)
        line=get_xds2ln(cd);
        if(substr(line,1,4) eq 0 )
            cd=rjust(cd,0,2);
            voslogln("获取XDS会议通道"&cd);
            return cd;
        endif
    endfor
    voslogln("无法分配到合适的会议通道");
    return "";
endfunc
#--------------------------------------------------------
func XDSCloseConf() #退出一个会议，并且给会议中其他任务都发消息通知其退出会议流程
dec
    var cd:3;
    var l:4;
enddec
    for(cd=1;cd<=XDSNUM;cd++)
        line=get_xds2ln(cd);
        if(substr(line,5,2) eq XDSCFH)
            l=substr(line,1,4);
            if(l strneq ln)
                MyMsgPut(l,l&"XDSCNFCLOSE"&ln);
            endif
        endif
    endfor
    XDSExitConf();
endfunc
#--------------------------------------------------------
func XDSQueryChnd(hotline) #根据热线标志查询会议句柄
dec
    var cd:3;
enddec
    for(cd=1;cd<=XDSNUM;cd++)
        line=get_xds2ln(cd);
        if(substr(line,10,NumberDigit) eq hotline)
            cd=substr(line,5,2);
            voslogln("查询到已经存在的XDS会议句柄"&cd&"["&hotline&"]");
            return cd;
        endif
    endfor
    return "";
endfunc
#--------------------------------------------------------
func XDSQuerySize(chnd)#统计某一个会议句柄内有多少个人
dec
    var cd:3;
    var ret:3;
enddec
    ret=0;
    for(cd=1;cd<=XDSNUM;cd++)
        line=get_xds2ln(cd);
        if(substr(line,5,2) eq chnd)
            ret++;
        endif
    endfor
    voslogln("XDS会议"&chnd&"里有"&ret&"人");
    return ret;
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

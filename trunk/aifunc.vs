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
        myvoslog("xs_msg_send("&xdsid&","&xdsmsg&") ����ʧ��["&li&"]");
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
func InputNumber(prp,digs) #Ҫ������ָ�����ȵ�����ŷ���
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
    if(strcnt(dig_string,"*") )#��������ַ����������*�ţ���ʾ�û�Ҫ��������
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
        if (not(strcnt(dig_string,"#"))) #δ������#�ż�������ȷ���Ǵ������루̫������ʱ
            #voslog("Ҫ������#�ż���ʱ��δ����#�ż�["&dig_string&"]"&length(dig_string)&" "&(digs+1));
            if(length(dig_string) eq digs+1 )#������볤�������û��#�ţ�˵����δ����#��
                #voslog("δ����#��");
                Nplay("ErrInp");
                goto ReInput;
            else #����һ��������δ�����ʱ�򣬳�ʱ�󷵻�
                overcont++;
                Iplay("OverT"&overcont);
                if (overcont>=5)
                    vid_write("Overtime hangup");
                    SysHangup();
                endif
                goto ReInput;
            endif
        else #���������#�ż������ǺϷ�����
            dig_string=strstrip(dig_string,"#");#�����������й��˲ſ�������ֱ�Ӱ�#�ż���������
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
    m=length(dig_string); #��Ϊ�е�ʱ���ַ����ᳬ����digs�����Ƶĳ��ȣ�����©�ж�
    for (l=1;l<=m;l++)
        if (strpos(vald, substr(dig_string,l,1)) eq 0)
            if(QueryWizlvl())
                voslogln("����Ƿ�����"&substr(dig_string,l,1));
            endif
            Nplay("ErrInp");
            goto ReInput;
        endif
    endfor
    if(DEBUG)
        voslogln("MyDigit="&dig_string&"["&strend(dig_string,digs)&"]");
    endif
    return strend(dig_string,digs); #ȷ�����ص�λ������Ҫ����־����ڰ���������ȴ�����ַ��Ƚ϶�������
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
    if(strcnt(dig_string,"*"))#��������ַ����������*�ţ���ʾ�û�Ҫ��������
        goto ReInput;
    endif
    if (dig_string strneq "")
        JustGetDigit=1;
    endif

    if (substr(vald,1,1) streq "#")
        tf_termtone(ln,"-");
        if (not(strcnt(dig_string,"#"))) #δ������#�ż�������ȷ���Ǵ������루̫������ʱ
            #voslog("Ҫ������#�ż���ʱ��δ����#�ż�["&dig_string&"]"&length(dig_string)&" "&(digs+1));
            if(length(dig_string) eq digs+1 )#������볤�������û��#�ţ�˵����δ����#��
                #voslog("δ����#��");
                Nplay("ErrInp");
                goto ReInput;
            else #����һ��������δ�����ʱ�򣬳�ʱ�󷵻�
                overcont++;
                Iplay("OverT"&overcont);
                if (overcont>=5)
                    vid_write("Overtime hangup");
                    SysHangup();
                endif
                goto ReInput;
            endif
        else #���������#�ż������ǺϷ�����
            dig_string=strstrip(dig_string,"#");#�����������й��˲ſ�������ֱ�Ӱ�#�ż���������
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
            #voslog("����Ƿ�����"&substr(dig_string,l,1));
            Nplay("ErrInp");
            goto ReInput;
        endif
    endfor
    if(DEBUG)
        voslogln("MyDigit2="&dig_string);
    endif
    return strend(dig_string,digs); #ȷ�����ص�λ������Ҫ����־����ڰ���������ȴ�����ַ��Ƚ϶�������
endfunc
#--------------------------------------------------------
func MyAbort(line) #�жϵ�ǰ�ߵķ�����ʾ
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
            voslogln("����3��δ���жϲ��������ٵȴ���������·״̬��"&tf_stat(line));
            break;
        endif
    endwhile
    #tf_toneint(ln,DISABLE);
    #tf_play(ln,"C:\MAIN\6053Hz.VOX",HZ6053);
    #tf_toneint(ln,ENABLE);
endfunc
#--------------------------------------------------------
func MyDigitTTS(prp, digs, vald) #����ָ���ַ�����TTS������ʾ���ȴ��û�����
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
    if(strcnt(dig_string,"*"))#��������ַ����������*�ţ���ʾ�û�Ҫ��������
        goto ReInput;
    endif
    if (dig_string strneq "")
        JustGetDigit=1;
    endif

    if (substr(vald,1,1) streq "#")
        tf_termtone(ln,"-");
        if (not(strcnt(dig_string,"#"))) #δ������#�ż�������ȷ���Ǵ������루̫������ʱ
            #voslog("Ҫ������#�ż���ʱ��δ����#�ż�["&dig_string&"]"&length(dig_string)&" "&(digs+1));
            if(length(dig_string) eq digs+1 )#������볤�������û��#�ţ�˵����δ����#��
                #voslog("δ����#��");
                Nplay("ErrInp");
                goto ReInput;
            else #����һ��������δ�����ʱ�򣬳�ʱ�󷵻�
                overcont++;
                Iplay("OverT"&overcont);
                if (overcont>=5)
                    vid_write("Overtime hangup");
                    SysHangup();
                endif
                goto ReInput;
            endif
        else #���������#�ż������ǺϷ�����
            dig_string=strstrip(dig_string,"#");#�����������й��˲ſ�������ֱ�Ӱ�#�ż���������
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
            #voslog("����Ƿ�����"&substr(dig_string,l,1));
            Nplay("ErrInp");
            goto ReInput;
        endif
    endfor
    if(DEBUG)
        voslogln("MyDigitTTS="&dig_string&"["&strend(dig_string,digs)&"]");
    endif
    return strend(dig_string,digs); #ȷ�����ص�λ������Ҫ����־����ڰ���������ȴ�����ַ��Ƚ϶�������
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
func IplayTTSX(vox_name,dtmf) #����TTS
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
            voslogln("JTTSת��ʱ�ļ�ɾ��ʧ�ܣ�"&tempfile);
            tf_playtts(ln,vox_name,1,1);#4������
            return ;
        endif
        IvrX_TextToVoc(vox_name,tempfile,JTTS_FORMAT_ALAW_8K);
        if(jk_FileExist(tempfile))
            tf_play(ln,tempfile);
        else
            voslogln("JTTSת��ʱ�ļ�����ʧ�ܣ�"&tempfile);
            tf_playtts(ln,vox_name,1,1);#4������
        endif
    else
        tf_playtts(ln,vox_name,1,1);#4������
    endif
#������������RESPAR_PFIRSTMSG ���η������еĵ�һ��������Ϣ�����ǰ��ķ�����û�н�
#��������Ϣ����ֹͣǰ�����еķ���������ѭ��������
#���ĸ�����RESPAR_PLASTMSG ���η������е����һ��������Ϣ��������Ϣָ���ķ�����
#�ݲ��Ž�����ϵͳ������һ�����������Ϣ��
#���û��ָ������������û�к����ķ�����Ϣ���򵱱���Ϣ
#ָ���ķ������ݲ��Ž�����ϵͳ���ȴ����������ؽ�����Ϣ
    #if(dtmf eq DISABLE) 
        tf_toneint(ln,ENABLE); 
    #endif
endfunc
#--------------------------------------------------------
#func Iplay2(vox_name) #����һ���������������Ȳ���ǰ������ŵ�
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
#func Iplay1(vox_name) #����һ��������ֱ���а�������
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
#            voslogln(ln," ����"&tf_digits(ln)&"�˳���������");
#            return ;
#        endif
#        sleep(5);
#    endwhile
#endfunc
#--------------------------------------------------------
func Nplay(vox_name)
    #���Կ��Ǹ�����չ�������в���
    return IplayX(vox_name,TF_FMT_ALAW,DISABLE);
endfunc
#--------------------------------------------------------
func Iplay(vox_name)
    #���Կ��Ǹ�����չ�������в���
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
        #���ȫ·�����
        if(FileExist(vox_name&".voc")) fn=vox_name&".voc"; endif    
        if(FileExist(vox_name)) fn=vox_name; endif
    else
        #�������Ŀ¼   
        #����֧�ֶ���������
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
        myvoslog("ע�⣺Iplay("&vox_name&")�޷���������");
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
        voslogln("Par("&sss&","&pn&","&ff&") ���ô���");
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
    #��һ�����������߰˾�ʮ��ǧ���ڵ�
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
                myvoslog("���߼�ѡ��OK"&l&"/"&CH_FREE);
                myvoslog("���߼�ѡ��="&ExecSqlA("select ln,stat,rtrim(ltrim(mno)),rtrim(ltrim(cle)),st from t_line where ln="&l));
                return l;
            endif
            myvoslog("���߼�ѡ��FAIL"&l&"/"&tf_lineState(l)&"!="&CH_FREE);
            myvoslog("���߼�ѡ��="&ExecSqlA("select ln,stat,rtrim(ltrim(mno)),rtrim(ltrim(cle)),st from t_line where ln="&l));
        else
            myvoslog("���߼�ѡ��FAIL->ln_getfree����["&l&"]");
        endif
        if(m<1)
            return 0;
        endif
    endif

    suc="";

    #���Ը���vtype���������������֣��Ӷ�����ѡ�ߵķ�Χ
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
func XDSEnterConf(hotline) #����ǰ�߼��뵽���߱�־Ϊhotline�Ļ�����ȥ�������δ�����˻��飬�򴴽��û���
dec 
    var ots:4;
    var its:4;
    var wo:1;
    var StartSecs:12;#������һ��ʱ��ֵ
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
    if(XDSCFH streq "") #���Ԥ�ȷ�����ˣ��Ͳ���Ѱ�һ�ȡ
        XDSCFH=XDSQueryChnd(hotline);
        if(XDSCFH streq "") #�Ҳ�����������˵������δ���������·���һ��������
            XDSCFH=XDSGetFreeCFH();
            if(XDSCFH streq "")
                SEM_CLR(s_HLNC);
#                if(AreaCode eq 532 and (  strcnt(Caller,"2093005") or  strcnt(Callee,"2093005") ))
#                    myvoslog("�޷����䵽������Դ");
#                endif
                return "";#˵���޷����䵽������Դ��
            endif
        endif
    endif
    #�����Ѿ���Ҫ����Ļ���ľ���ˣ�Ӧ��Ѱ��һ�����е�ͨ��
    if(XDSCFC streq "")#���Ԥ�ȷ�����ˣ��Ͳ���Ѱ�һ�ȡ
        XDSCFC=XDSGetFreeCFC();
        if(XDSCFC streq "")
            XDSCFH="";
            SEM_CLR(s_HLNC);
#            if(AreaCode eq 532 and (  strcnt(Caller,"2093005") or  strcnt(Callee,"2093005") ))
#                myvoslog("�޷���ȡ������ͨ��");
#            endif
            return "";#�޷���ȡ������ͨ��
        endif
    endif
    line=ln&XDSCFH&"U"&bsxs&"F"&HLN; #LINE CF M B F HOTLINE  -> �ߺ� ������ ���� ����ϵ�� �����־ �����ǩ
    set_xds2ln(XDSCFC,line);
    #voslog("set_xds2ln("&XDSCFC&","&line&")");
    SEM_CLR(s_HLNC);
    #ots��itsΪSCBUS�ϵ�ʱ϶���
    ots=XDSCFC+XDSSLOT;
    its=st_slt2slot(tfb_getslot(ln,0));
    msg="CA"&XDSCFH&tf_h100x(ots)&tf_h100x(its)&"00";
#    if(AreaCode eq 532 and (  strcnt(Caller,"2093005") or  strcnt(Callee,"2093005") ))
#        myvoslog(msg);
#    else
        voslogln(msg);
#    endif
    XS_MsgSend(16,msg);        #��һ���û�ͨ���ӵ�������û��������û���ͨ����ͬʱָ��һ������ĳ���
#    if(AreaCode eq 532 and (  strcnt(Caller,"2093005") or  strcnt(Callee,"2093005") ))
#        myvoslog("ln:"&ln&" ots:"&ots&" its:"&its&" xdscfh:"&XDSCFH&" xdscfc:"&XDSCFC&"  msg="&msg);
#    else
        voslogln("ln:"&ln&" ots:"&ots&" its:"&its&" xdscfh:"&XDSCFH&" xdscfc:"&XDSCFC&"  msg="&msg);
#    endif
    tfb_listen(ln,0,slot2st_slt(ots));  #���û�������ĳ��ڣ���ɼ��뵽һ������Ĳ���
    #voslog("tfb_listen("&ln&","&slot2st_slt(ots)&")" );
    if(bsok eq 1)
        msg="CS"&tf_h100x(its)&bsxs;
#        if(AreaCode eq 532 and (  strcnt(Caller,"2093005") or  strcnt(Callee,"2093005") ))
#            myvoslog("��ʼ������ϵ����XS_MsgSend(16,'"&msg&"')="&XS_MsgSend(16,msg));
#        else
            voslogln("��ʼ������ϵ����XS_MsgSend(16,'"&msg&"')="&XS_MsgSend(16,msg));
#        endif
    endif
    sec=tmr_secs();
    ii=readreg("XDSTimeLimit");
    if(not(ii+0))
        ii=300;
    endif
    while(1)
        sleep(1);
        if(tmr_secs() - sec > ii and not(multiconf) and FeeByMonth) #����5���ӣ��˳�ͨ�����ൺ�޸�Ϊ3������
#            if(AreaCode eq 532 and (  strcnt(Caller,"2093005") or  strcnt(Callee,"2093005") ))
#                myvoslog("���Ƴ���ʱ����ϵͳ�ж����죺"&tmr_secs()&" | "&sec);
#            else
                voslogln("���Ƴ���ʱ����ϵͳ�ж����죺"&tmr_secs()&" | "&sec);
#            endif
            goto ExitConf;
            break;
        endif
        msg=msgget();
        if(msg strneq "")
            if(substr(msg,1,15) streq ln&"XDSCNFCLOSE")
                voslogln("�յ��˳�����������Ϣ:"&msg);
                break;
            else
                if(substr(msg,1,12) streq ln&"XDSCNFBS")
                    bsxs=substr(msg,17,1);
                    msg="CS"&tf_h100x(its)&bsxs;
                    voslogln(ln&"���Է�"&substr(msg,13,4)&"֪ͨ������ XS_MsgSend(16,'"&msg&"')="&XS_MsgSend(16,msg));
                else
#                    if(AreaCode eq 532 and (  strcnt(Caller,"2093005") or  strcnt(Callee,"2093005") ))
#                        myvoslog("XDSEnterConf�յ���Ԥ����Ϣ:"&msg);
#                    else
                        voslogln("XDSEnterConf�յ���Ԥ����Ϣ:"&msg);
#                    endif
                endif
            endif
        endif

        if (tf_stat4(ln)<>0 and kbs) #and multiconf) #��ʱ���ε������а��������Ĺ��ܣ�ֻ�в��ԵĶ෽����ͨ����Ҳ����������
            tf_getdigits(ln,1,0,0);
            wo=tf_digits(ln);
            
            testflag=0; #���Բ��˳�����ֱ���ж�DTMF�Ƿ����
            
            if(wo streq "#")
                #��ʱ�˳�����
                if(testflag)
                    msg="CX"&XDSCFH&tf_h100x(st_slt2slot(tfb_getslot(ln,0)));#ɾ������ʱ϶
                    voslogln(msg);
                    XS_MsgSend(16,msg);
                    tf_unRoute(ln); #�û�Ҳ���������飬����ᱻ�����˵İ������ŵ�
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
                        voslogln("��"&ln&"�������յ���Ϣ��"&msg);
                    endif
                endwhile
                if (wo streq "#")
                    voslogln("User "&ln&" Press ## to Quit XDS Conf");
                    if(testflag)                    
                        #���¼ӻػ��飬����ExitConf��������
                        msg="CA"&XDSCFH&tf_h100x(ots)&tf_h100x(its)&"00";#��һ���û�ͨ���ӵ�������û��������û���ͨ����ͬʱָ��һ������ĳ���
                        XS_MsgSend(16,msg);      
                    endif  
                    goto ExitConf;
                endif
                if(testflag)
                    #���¼������
                    msg="CA"&XDSCFH&tf_h100x(ots)&tf_h100x(its)&"00";#��һ���û�ͨ���ӵ�������û��������û���ͨ����ͬʱָ��һ������ĳ���
                    XS_MsgSend(16,msg);        
                    tfb_listen(ln,0,slot2st_slt(ots));  #���û�������ĳ��ڣ���ɼ��뵽һ������Ĳ���
                endif
                if(wo strneq "" and 0<=wo and wo <=9 and bsok eq 1)#����������������Ļ��͸��ݰ�������
                    if(wo eq 0)
                        wo=5;
                    endif
                    #ע��������жϣ����еط�������ԭ��ͨ��
#                    if(wo eq 5 and AreaCode <> 532 and AreaCode <> 371)
#                        bsxs=wo; #����ԭ��ͨ��
#                    else
                        bsxs=wo-1;
#                    endif
                    sleep(5);
                    msg="CS"&tf_h100x(its)&bsxs;
                    voslogln("��⵽��������["&wo&"]:XS_MsgSend(16,'"&msg&"')="&XS_MsgSend(16,msg));
                endif
            endif
        endif
    endwhile
ExitConf:
    XDSExitConf();
    return "1";
endfunc
#--------------------------------------------------------
func XDSExitConf() #����ǰ���˳�����
    if(XDSCFC)
        SEM_SET(s_HLNC);
        #msg="CX"&XDSCFH&tf_h100x(st_slt2slot(tfb_getslot(ln,0)));#ɾ������ʱ϶
        #voslog(msg);
        #XS_MsgSend(16,msg);
        
        #msg="CD"&tf_h100x(XDSCFC+XDSSLOT);  #ɾ�����ʱ϶
        #voslog(msg);
        #XS_MsgSend(16,msg);
        
        tf_unRoute(ln);
        if(XDSCFH strneq "" and XDSQuerySize(XDSCFH) eq 1)
            msg="CU"&XDSCFH;
            voslogln(msg);
            XS_MsgSend(16,msg);            #����������Ѿ�û���˵Ļ��ͽ�������
        endif
        if(XDSQuerySize(XDSCFH) eq 2 and lnc and multiconf <> 1)
            #�������ͨ������һ���˳���������һ��Ҳ�˳�
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
func XDSGetFreeCFH() #��ȡһ�����еĻ�����Դ1-42
dec
    var cd:3;
    var cn:3;
enddec
    for(cn=1;cn<=XDSCNF;cn++)
        for(cd=1;cd<=XDSNUM;cd++)
            line=get_xds2ln(cd);
            if(substr(line,5,2) eq cn)#��������Ѿ�ʹ��CN��������������ж���һ��
                break;
            endif
        endfor
        if(cd>XDSNUM)
            cn = rjust(cn,0,2);#Ѱ�ҵ��µĿ��еĻ������������cfh
            voslogln("��ȡXDS������"&cn);
            return cn;
        endif
    endfor
    voslogln("ע�⣺�޷����뵽XDS������Դ");
    return "";
endfunc
#--------------------------------------------------------
func XDSGetFreeCFC() #��ȡһ�����еĻ���ͨ��1-128
dec
    var cd:3;
enddec
    for(cd=1;cd<=XDSNUM;cd++)
        line=get_xds2ln(cd);
        if(substr(line,1,4) eq 0 )
            cd=rjust(cd,0,2);
            voslogln("��ȡXDS����ͨ��"&cd);
            return cd;
        endif
    endfor
    voslogln("�޷����䵽���ʵĻ���ͨ��");
    return "";
endfunc
#--------------------------------------------------------
func XDSCloseConf() #�˳�һ�����飬���Ҹ��������������񶼷���Ϣ֪ͨ���˳���������
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
func XDSQueryChnd(hotline) #�������߱�־��ѯ������
dec
    var cd:3;
enddec
    for(cd=1;cd<=XDSNUM;cd++)
        line=get_xds2ln(cd);
        if(substr(line,10,NumberDigit) eq hotline)
            cd=substr(line,5,2);
            voslogln("��ѯ���Ѿ����ڵ�XDS������"&cd&"["&hotline&"]");
            return cd;
        endif
    endfor
    return "";
endfunc
#--------------------------------------------------------
func XDSQuerySize(chnd)#ͳ��ĳһ�����������ж��ٸ���
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
    voslogln("XDS����"&chnd&"����"&ret&"��");
    return ret;
endfunc
#--------------------------------------------------------
#��SCBUS��ʮ����ʱ϶ת��Ϊ����ʱ϶��ʮ�����Ʊ���(SCBUS��1024��ʱ϶��ÿ����64��ʱ϶��һ��16������
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
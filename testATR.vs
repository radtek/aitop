dec
    var i:127;
    var k:127;
enddec
program
    voslog("press Esc key exit ....");
    
    i="$top_name排行榜第$top_no名是$sp_name的$sp_pname";
    voslog(i);
    i=ai_strReplace(i,"$top_name","TOP_NAME");
    voslog(i);
    i=ai_strReplace(i,"$top_no","TOP_NO");
    voslog(i);
    i=ai_strReplace(i,"$sp_name","SP_NAME");
    voslog(i);
    i=ai_strReplace(i,"$sp_pname","SP_PNAME");
    voslog(i);
    
    while (1)
        if (kb_qsize()>0)
            k=kb_getx();
            if (k streq "011b") #ESC
                break;
            endif
            i=kb_get();
            voslog("press "&i);
        endif
    endwhile
    exit(0);
endprogram
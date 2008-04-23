dec
    var i:127;
    var k:127;
enddec
program
    voslog("press Esc key exit ....");
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
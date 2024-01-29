#include <stdio.h>
#include <emscripten.h>

// emcc terminal.c -o terminal.html -sEXPORTED_FUNCTIONS=_main -sEXPORTED_RUNTIME_METHODS=ccall,cwrap -s EXPORT_ES6=1 -s ASYNCIFY;cat preamble.js terminal.js >temp.js;rm terminal.js;mv temp.js terminal.js 

/* the command adds automatically 
   import {js_getch, js_writech} from "./keyp.js";
   (as contained in preamble.js)
   at the top of function.js.
   
   The option --js-pre does not work as the import command should be issued
   at the very beginning of the file.
*/

#define WAIT_INTERVAL 50

void a_putc(char ch)
{
    EM_ASM_({js_writech($0)};,(int32_t)ch);
}

void a_puts(char *s)
{
    char ch;
    while(*s!='\0') {
        ch=*s;
        ++s;
        a_putc(ch);
    }
}

int a_getchar(void)
{
    int d;
    int p=0;
    do {
        d=EM_ASM_INT("return js_getch();");
        emscripten_sleep(WAIT_INTERVAL);
    } while (d<0);

    return d;
}

int a_waitkey(void)
{
    int d;
    int p=0;
    do {
        d=EM_ASM_INT("return js_waitkey();");
        emscripten_sleep(WAIT_INTERVAL);
    } while (d<0);

    return d;
}

char *a_gets(char *buffer, int size)
{
    int d;
    int p=0;
    do {
        d=EM_ASM_INT("return js_getch();");
        if(d<0) {
            emscripten_sleep(WAIT_INTERVAL);
            continue;
        }
        buffer[p++]=d;
        if(p>=size) {
            buffer[p-1]='\0';
            break;
        }

    } while (d!='\n');
    if(p<size)
        buffer[p]='\0';
    return buffer;
}

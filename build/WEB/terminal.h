#ifndef _TERMINAL_H_
#define _TERMINAL_H_

int a_getchar(void);
int a_waitkey(void);
void a_putc(char ch);
void a_puts(char *s);
char *a_gets(char *buffer, int size);

#endif
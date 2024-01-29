#ifndef SPLASH_WINDOW_H_
#define SPLASH_WINDOW_H_
#include <Windows.h>

#define SPLASH_WINDOW_ID 257

void init_process(void);
void init_mgrs(void);
void event_loop(void);
void make_window(void);
void do_update(EventRecord *event);
void draw_content(WindowPtr window);
void splash(void);
char *getFileName(char *filename, int size, int isload);

void disablem(void);
void enablem(void);
void saveMac(void);
void SetUpMenuBar(void);



#endif /* SPLASH_WINDOW_H */

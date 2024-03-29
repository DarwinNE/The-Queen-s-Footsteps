#include "SplashWindow.h"
#include <string.h>
#include <Events.h>
#include <Quickdraw.h>
#include <stdlib.h>
#include <stdio.h>
#include "config.h"
#include "aws.h"

#include "inout.h"

#define CREATOR   'QuEe'
#define F_TYPE    'QuEe'

extern room_code current_position;
extern room_code next_position;
extern boolean marker[];
extern int counter[];
extern object obj[];
extern room world[];
extern unsigned int turn;

WindowRecord w_record;
WindowPtr splash_window;

short system_version;

#define SPLASH_PICTURE_RES_ID 258

#define mMenuBar 128
#define mApple 128
#define mFileMenu 129
#define mNew  1
#define mLoad 2
#define mSave 3
#define mQuit 5

#define rQuitConfirm 131
#define kOKButton 1

char nameb[256];

void setSpecificEventHandler(int (*p)(EventRecord*)); // TODO put in console.h


short getSystemVersion(void) 
{
    SysEnvRec sysEnv;
    short version;
    version = 0;
    if (!SysEnvirons (1,&sysEnv))
        version = sysEnv.systemVersion >> 8;
    return version;
}

/** Handle the File choices. If it returns 1, a '\r' is issued to the console.
*/
short HandleFileMenu(short theMenuItem)
{
    short theItem;
    switch(theMenuItem)
    {
        case mNew:
            theItem = CautionAlert(rQuitConfirm, nil);
            if (theItem == kOKButton) {
                restart();
                return 1;
            }
            break;
        case mSave:
            saveMac();
            return 1;
            break;
        case mLoad:
            if(getFileName(nameb, 255, 1)!=NULL) {
                if(nameb[0]=='.') {
                    PUTS("\nInvalid file name!\n");
                } else if(loadgame(nameb)) {
                    PUTS("Error!\n");
                } // We don't need a return 0 when saving.
            }
            break;
        case mQuit:
            theItem = CautionAlert(rQuitConfirm, nil);
            if (theItem == kOKButton)
                exit(0);
            break;
    }
    return 0;
}

/** Handle the menu options. If it returns 1, a '\r' is issued to the console.
*/
short HandleMenuChoice(long theChoice)
{
    short theMenu;
    short theMenuItem;
    short isTreated=0;
    unsigned char name[256];

    theMenu = HiWord(theChoice);
    theMenuItem = LoWord(theChoice);
    switch (theMenu) {
        case mApple:
            if(theMenuItem==1) {
                // Show the splash window.
                splash_window = GetNewWindow(SPLASH_WINDOW_ID, 
                    &w_record, (WindowPtr)-1L);
                ShowWindow(splash_window);
                SelectWindow(splash_window);
                event_loop();
                CloseWindow(splash_window);
                isTreated=0;
            } else {
                // Launch a desk accessory.
                GetMenuItemText(GetMenuHandle(mApple),theMenuItem,name);
                OpenDeskAcc(name);
            }
            break;
        case mFileMenu:
            isTreated=HandleFileMenu(theMenuItem);
            break;
    }
    HiliteMenu(0);
    if(isTreated)
        return 1;
    else
        return 0;
}

/** The handler to inject 
*/
int handler(EventRecord *e)
{
    static int isFirst;
    
    if(!isFirst)
        DrawMenuBar();//SetUpMenuBar();
    isFirst=1;
    WindowPtr theWindow;
    short thePart, theChar;
    long theChoice;
    
    switch (e->what) {
        case mouseDown:
            thePart = FindWindow(e->where, &theWindow);
            if (thePart== inMenuBar) {
                theChoice = MenuSelect(e->where);
                if (theChoice != 0) {
                    if(HandleMenuChoice(theChoice)) {
                        // Simulate a return key.
                        e->what=keyDown;
                        e->message = '\n';
                    }
                    return 1;
                }
            }
            break;
        case keyDown:
            theChar = e->message & charCodeMask;
            if((e->modifiers & cmdKey) != 0) {
                if (e->what != autoKey) {
                    theChoice = MenuKey(theChar);
                    HandleMenuChoice(theChoice);
                    e->what = nullEvent;
                    return 1;
                }
            }
            break;
    }
    
    return 0;
}


void SetUpMenuBar(void)
{
    Handle theMenuBar;
    MenuHandle theAppleMenu;

    theMenuBar = GetNewMBar(mMenuBar);
    SetMenuBar(theMenuBar);
    DisposeHandle(theMenuBar);
    theAppleMenu = GetMenuHandle(mApple);
    if(system_version>6)
        AppendResMenu(theAppleMenu, 'DRVR');
    setSpecificEventHandler(&handler);
    DrawMenuBar();
}

void showSplashWin(void)
{
    splash_window = GetNewWindow(SPLASH_WINDOW_ID, &w_record, (WindowPtr)-1L);
    ShowWindow(splash_window);
    event_loop();
    CloseWindow(splash_window);
    SetUpMenuBar();
    disablem();
}

void disablem(void)
{
    MenuHandle h=GetMenu(mFileMenu);
    DisableItem (h, mLoad);
    DisableItem (h, mSave);
    DisableItem (h, mNew);
}

void enablem(void)
{
    MenuHandle h=GetMenu(mFileMenu);
    EnableItem (h, mNew);
    if(system_version>6){
        EnableItem (h, mLoad);
        EnableItem (h, mSave);
    }
}

OSErr HSetFInfo(
  short              vRefNum,
  long               dirID,
  ConstStr255Param   fileName,
  const FInfo *      fndrInfo)
{
    HParamBlockRec pb;
    OSErr err;
    pb.fileParam.ioVRefNum = vRefNum;
    pb.fileParam.ioNamePtr = (StringPtr)fileName;
    pb.fileParam.ioFVersNum = 0;
    pb.fileParam.ioFDirIndex = 0;
    pb.fileParam.ioDirID = dirID;
    pb.fileParam.ioFlFndrInfo = *fndrInfo;
    return PBHSetFInfoSync(&pb);
}

short currentVolume;

void saveMac(void)
{
    char PasBuf[256];
    FInfo fi;
    if(system_version<7) {
        PUTS("Game can not be saved with Systems less than 7.");
        //PUTS("Enter file name:\n");
        //GETS(nameb, 255);
        return;
    } else {
        getFileName(nameb, 255, 0);
    }
    if(nameb!=NULL) {
        if(nameb[0]=='.') 
            PUTS("Invalid file name!\n");
        else if(savegame(nameb)){
            PUTS("Error!\n");
        } else {
            // The file has been saved. We need to set up the creator
            printf("Set creator...\n");
            strcpy(&PasBuf[1],nameb);
            PasBuf[0]=(unsigned char) strlen(nameb);
            short v;
            GetVol(nameb, &v);
            HGetFInfo(0, 0, PasBuf,&fi);
            fi.fdType=F_TYPE;
            fi.fdCreator=CREATOR;
            HSetFInfo(0,0,PasBuf,&fi);
        }
    }
}

char *getFileName(char *filename, int size, int isload)
{
    SFReply reply;

    Point where = (Point){-1,-1};
    SFTypeList typeList;
    typeList[0]=F_TYPE;
    
    int l;
    
    if(isload)
        SFGetFile(where, "\p", NULL, 1, typeList, NULL, &reply);
    else
        SFPutFile(where, "\p", "\p", NULL, &reply);
    
    if(reply.good) {
        currentVolume=reply.vRefNum;
        SetVol("\p", currentVolume);
        l=reply.fName[0];
        if(size-2<l)
            l=size-2;
        strncpy(filename, (const char *)reply.fName+1,l);
        filename[l]='\0';
        return filename;
    }
    return NULL;
}

void splash(void)
{
    short message, number;
    TEInit();
    // Show the splash window
    system_version = getSystemVersion();
    init_process();
    showSplashWin();
    // Check if there is a file to load
    CountAppFiles(&message,&number);
    if(number>0 && message==appOpen) {
        AppFile af;
        GetAppFiles(1, &af);    // We only load the first file (index 1).
        SetVol(NULL, af.vRefNum);
        strncpy(nameb, &af.fName[1], af.fName[0]);
        nameb[af.fName[0]]='\0';
        switch(loadgame(nameb)) {
            case 0:
                printf("Loaded saved game: %s\n\n",nameb);
                break;
            case 1:
                printf("Could not open file: %s\n\n",nameb);
                break;
            case 2:
                printf("File %s has an incorrect format.\n\n",nameb);
                break;
            case 3:
                printf("File %s can't be read.\n\n",nameb);
                break;
            case 4:
                printf("File %s is not from this game.\n\n",nameb);
                break;
            default:
                printf("File %s could not be loaded.\n\n",nameb);
                break;
        }
    }
}

void init_process(void)
{
    init_mgrs();
    FlushEvents(everyEvent, 0);
}

void init_mgrs(void)
{
    InitGraf(&qd.thePort);
    InitFonts();
    InitWindows();
    InitCursor();
}

void event_loop(void)
{
    EventRecord my_event;
    Boolean valid;
    Boolean cont=true;
    
    while (cont) {
        SystemTask();
        valid= GetNextEvent(everyEvent,&my_event); 
        if (!valid) continue;
        switch(my_event.what) {
            case mouseDown:
                cont=false;
                break;
            case updateEvt:
                do_update(&my_event);
                break;
            default:
                break;
        }
    }
}

void do_update(EventRecord *event)
{
    GrafPtr save_graf;
    WindowPtr update_window;
    update_window = (WindowPtr)event->message;
    if(update_window == splash_window) {
        GetPort(&save_graf);
        SetPort(update_window);
        BeginUpdate(update_window);
        ClipRect(&update_window->portRect);
        EraseRect(&update_window->portRect);
        draw_content(update_window);
        EndUpdate(update_window);
        SetPort(save_graf);
    }
}

// NOTE: Explore SetWindowPic alternative

void draw_content(WindowPtr window)
{
    Rect pictRect = {0,0,320,436};
    MoveTo(30,30);
    DrawText("Loading...", 0,10);
    MoveTo(0,0);
    DrawPicture(GetPicture(SPLASH_PICTURE_RES_ID),&pictRect);
}

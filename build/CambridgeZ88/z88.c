// Minimal Code for generation an application header
#include <stdlib.h>

#pragma redirect handlecmds = _adv_handlecmds

void adv_handlecmds(int cmd)
{
        switch(cmd) {
                case 0x81:
                        exit(0);
        }
}

#include <arch/z88/dor.h>

#define HELP1 "A text adventure, by Davide Bucci"
#define HELP2 "Use 'n', 's', 'w', 'e', 'u', 'd' to move around"
#define HELP3 "'look' or 'x' to examine an object"
#define HELP4 "'take' to put an object in your 'inventory'"
#define HELP5 "'bye' to exit game" 
#define HELP6 "'load' and 'save' to resume or save the game"

#define APP_INFO "Made by z88dk/db"
#ifndef APP_NAME
    #define APP_NAME "TQF"
#endif
#define APP_KEY 'T'
#define APP_TYPE AT_Bad|AT_Draw

#define TOPIC1            "Commands"
#define TOPIC1ATTR        TP_Help
#define TOPIC1HELP1        "Just some help text"

#define TOPIC1_1         "Quit"
#define TOPIC1_1KEY      "CQ"
#define TOPIC1_1CODE     $81
#define TOPIC1_1ATTR       MN_Help
#define TOPIC1_1HELP1    "Use this to quit the game"
#include <arch/z88/application.h>


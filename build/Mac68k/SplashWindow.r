#include "Menus.r"

// NOTE: A "owner resource" is missing, i.e. a resource with the creator code,
// ID 0 and containing 256 bytes of junk.

// NOTE: the encoding of this file must be Western (Mac OS Roman)

resource 'WIND' (257, preload, purgeable)
{
    {20, 30, 320+20, 436+30};
    plainDBox,
    invisible,
    goAway,
    0x0,
    "",
    centerParentWindow
};

resource 'FREF' (128, purgeable) {
   'APPL', 128, ""
};

resource 'FREF' (129, purgeable) {
   'QuEe', 129, ""
};

resource 'BNDL' (128, purgeable) {
   'QuEe', 0,
   {  
      'ICN#', {0, 128, 1, 129},
      'FREF', {0, 128, 1, 129}
   }
};

resource 'MBAR' (128, preload) {
    {128, 129};
};


resource 'MENU' (128) {
    128, textMenuProc;
    allEnabled, enabled;
    apple;
    {
        "About...", noIcon, noKey, noMark, plain;
        "-", noIcon, noKey, noMark, plain;
    }
};

resource 'MENU' (129) {
    129, textMenuProc;
    allEnabled, enabled;
    "File";
    {
        "New", noIcon, "N", noMark, plain;
        "Open…", noIcon, "O", noMark, plain;
        "Save…", noIcon, "S", noMark, plain;
        "-", noIcon, noKey, noMark, plain;
        "Quit", noIcon, "Q", noMark, plain;
    }
};

resource 'ALRT' (131, purgeable ) {
   {100, 60, 110+100, 400+60},
   131,
   {
      OK, visible, silent,
      OK, visible, silent,
      OK, visible, silent,
      OK, visible, silent
   },
   alertPositionMainScreen
};

resource 'DITL' (131, purgeable) {
    {
        { 76, 300, 76+20, 380 },
        Button { enabled, "OK" };
        { 76, 200, 76+20, 280 },
        Button { enabled, "Cancel" };

        {8, 72, 70, 380},
        StaticText { disabled, "Are you sure?" };
    }
};

resource 'SIZE' (-1 , purgeable) {
    0, //reserved, 
    0, //acceptSuspendResumeEvents,
    0, //reserved,
    0, //canBackground,
    0, //doesActivateOnFGSwitch,
    0, //backgroundAndForeground,
    0, //dontGetFrontClicks,
    0, //ignoreAppDiedEvents,
    1, //is32BitCompatible,
    0, //isHighLevelEventAware,
    0, //localAndRemoteHLEvents,
    0, //isStationeryAware,
    0, //dontUseTextEditServices,
    0, //reserved,
    0, //reserved,
    0, //reserved,
    512 * 1024, // minSize
    512 * 1024  // preferredSize
};

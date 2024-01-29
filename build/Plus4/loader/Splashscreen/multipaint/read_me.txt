Multipaint readme

You need the Java Runtime library in order to run the applications. This may mean an earlier version of the library than the latest. With a Mac, you'll probably need the version 1.7 (JSE 7)


Running the sketch version (separate download)

Place the multipaint folder to your Processing sketchbook folder. Run Processing, load and run the sketch, select the machine of your preference and go. Check the multipaint.pdf for further instructions.


For Mac users

Multipaint may have problems finding the prefs.txt file, leading to reduced features. It appears that no one solution fits all, but based on Mac users' comments here are some things to consider:

-Check that the Multipaint folder and all the files are properly on the filesystem, and not inside the archive or as shortcut icons.

-Position the prefs.txt alternately to your "home" folder, the Multipaint folder, or your "root" folder.

-It may be helpful to check what folder the Multipaint load and save selectors offer you as a default. This could be the folder the program uses for reading the prefs.txt.


Contact

You can contact me at:
tero_h[at]hotmail.com

The website for Multipaint as of 2018 is:

http://multipaint.kameli.net


Keyboard shortcuts

Check the keysheet.png image file included with your Multipaint.
I have highlighted the keys that might be good to learn first.
The following collects most of the keys, but the comprehensive list of keys is in the keysheet and the multipaint.pdf manual.


Tool keys: 0-9

  1-pixeldraw
  2-spray can
  3-solid line
  4-grab brush (rectangular)
  5-floodfill
  6-rectangle
  7-ellipse
  8-line
  9-paste with brush
  0-Magnify window

Parameter switch keys:

  d-background->foreground mode on/off
  f-fill on/off
  g-switch grid on/off (only 8x8 for now)
  c-switch grid constraint on/off
  r-switch preset raster stipple on/off
  R-switch brush-derived raster stipple on/off
  m-magnify on/off
  M-Double magnify (a bit wobbly still)
  X-screen horizontal mirror on/off
  Y-screen vertical mirror on/off
  t-tile mode on/off
  
Brush switches:

  p-paint with selected colors (not brush colors)
  x-flip brush horizontal
  y-flip brush vertical
  z-rotate brush
  h-decrease brush size (ordinary brushes only at the mo)
  H-increase brush size (ditto)

  n-Playbrush (needs a special on-screen layout)
  N-switch playbrush speed

Load the playbrush256.png example file to check the playbrush function.


Direct command keys:
  
  l-load .bin or .PNG
  s-save as .bin or .PNG
  S-save with existing filename (shown on top)
  E-export asm-friendly text file
  A-export 8-bit executable file (c64,msx,spe,plus4,cpc)
  w-export relevant format (8-bit paint programs: c64,msx,spe,plus4)
  W-import relevant format (8-bit paint programs: c64,msx,spe,plus4)
  
  Q-Export border with PNG? (use prefs.txt to alter PNG scale and border dimensions)

  B-Border=Current selected color (not in MSX)
  C-Background=Current selected color (not in Spec/C64hi)
  V-Background2=Current selected color (only in Plus4 multicolor)

  u-undo (U-redo)
  o-clear all
  j-switch between spare/front pages
  J-copy to other page (spare/front)
  
  i-Increase brightness (plus4)
  k-Decrease brightness (plus4);

  TAB=select next color
  SHIFT+TAB=select prev color



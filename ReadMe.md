# MoverReKeyer BETA3 

UnrealEd plugin, updates keyframes of moved/rotated movers.
  
By default moving/rotating a mover modifies single mover keyframe. 
This plugin allows you to move/rotate all keyframes without breaking relative 
keyframe offsets & rotations.

## Install

### Requirements:
- Unreal Engine 2, tested on UT2004 and UE2 Runtime
- Map with working movers.


### UT2004 installer:
- Run the MoverReKeyer.ut4mod file.
- If doesn't work, see below.


### Universal installer: 
- Extract the MoverReKeyer folder to your main game folder (ie: \UT2004\).
- Run Game\MoverReKeyer\Install.bat.


### Running UnrealEd with custom ini file
- If you do use some custom ini's, you'll have to update them manually.
- Add MoverReKeyer to EditPackages in [Editor.EditorEngine] section.
- http://wiki.beyondunreal.com/wiki/Add_EditPackage


## Help

### How to run the plugin:
- To run the plugin click on MoverReKeyer icon.
- The icon is located in the vertical toolbar, just below brush builders.
- The icon looks like small blue box with 4 circular arrows around it.


#### Example: Rotate/move movers
- Select the actors you want to move/rotate.
- Select phase "Store" in plugin options.
- Start the plugin, it will tell you how many movers were found.
- Rotate/move your actors, don't touch keyframes yet.
- Start the plugin again, it will tell you how many movers were rekeyed.
- Rebuild level and check mover's keyframes.


#### Example: Rotate/move duplicated movers
- Select the actors you want to duplicate & move/rotate.
- Select phase "Store" in plugin options.
- Start the plugin, it will tell you how many movers were found.
- Duplicate your actors.
- Rotate/move your *duplicated* actors *only*, don't touch keyframes yet.
- Start the plugin again, it will tell you how many movers were rekeyed.
- Rebuild level and check mover's keyframes.
  
  
#### Options:
- Options can be accessed by right-clicking the icon.
- [Phase] = Plugin re-keying phase, see below.
  
  
## How it works:
- Mover re-keying is done in two phases: "Store" and "ReKey".
- Every time you want to re-key movers, you have to run the plugin two times:
  * Before moving/rotating movers, run "Store" to prepare movers.
  * After moving/rotating movers, run "ReKey" to update movers.
- If a phase executes without errors, next phase is automatically selected. 
- You can always change current phase to "Store" in plugin options.
  
  
## Why rekeying cannot be done with one click:
- Suppose you have a mover with two keyframes. 
  * Mover's base location is equal mover location at keyframe 0.
  * Keyframe 0 is equal 0. 
  * Keyframe 1 is some offset.
- If the mover is moved around in editor while at keyframe 1, mover's 
  keyframe 1 and location are updated by the editor but base location is not. 
  The only keyframe offset we had, keyframe 1, is lost.
- To get around that limitation, MoverReKeyer must store mover keyframes before
  they are modified.


## If you need help with movers:
- tutorial: http://udn.epicgames.com/Two/MoversTutorial
- tutorial: http://wiki.beyondunreal.com/wiki/Create_A_Mover
- mappers forum: http://forums.beyondunreal.com/forumdisplay.php?f=346
- mappers forum: http://www.ataricommunity.com/forums/forumdisplay.php?s=&forumid=259 


## Uninstall

### UT2004 uninstaller:
- Available only if installed with MoverReKeyer.ut4mod
- Run UT2004\System\Setup.exe
- Select MoverReKeyer and click next.


### Universal uninstaller:
- Run Game\MoverReKeyer\Uninstall.bat.


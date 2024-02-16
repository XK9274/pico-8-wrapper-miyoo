---

# Pico-8 Wrapper for Miyoo Mini/Miyoo Mini Plus

[CLICK HERE FOR DOWNLOADS](https://github.com/XK9274/pico-8-wrapper-miyoo/releases)

[CLICK HERE FOR HELP WITH ALLIUM](https://github.com/XK9274/pico-8-wrapper-miyoo/issues/2)

A wrapper to run Pico-8 natively on the Miyoo Mini/Miyoo Mini Plus.

<a name=""></a>
##

<a name=""></a>
##

| Full screen | Aspect scaled | Integer scaled |
|:-----------:|:-------------:|:--------------:|
| ![Full screen](https://github.com/XK9274/pico-8-wrapper-miyoo/assets/47260768/32566649-9008-43e8-8cd5-9d2a587fe493) | ![Aspect scaled](https://github.com/XK9274/pico-8-wrapper-miyoo/assets/47260768/c3434d9e-0ed2-4716-8fc8-655c53390bd6) | ![Integer scaled](https://github.com/XK9274/pico-8-wrapper-miyoo/assets/47260768/b9679f53-7ff0-4a39-83ca-18aff5abd0b5) |

## Table of Contents
1. [Installation](#installation)
2. [Features](#features)
3. [Button Shortcuts](#button-shortcuts)
4. [To-do](#to-do)
5. [Bezel Templates](#bezel-templates)
6. [Screenshots](#screenshots)
7. [Changelog](#changelog)
8. [Releases](https://github.com/XK9274/pico-8-wrapper-miyoo/releases)
9. [SDL Source](https://github.com/XK9274/sdl2_miyoo/tree/pico8)
10. [Building](#building)

<a name="installation"></a>
## Installation
- Drag the app folder from the releases page into `/mnt/SDCARD/App/` (so it becomes `/mnt/SDCARD/App/pico`). Warning: If you use FTP and Filezilla, you must set your transfer type to binary or it will corrupt binaries on transfer.
- Drag your RASPBERRY PI `pico8_dyn` and `pico8.dat` into `/mnt/SDCARD/App/pico/bin` (If the directory doesn't exist, you can create it). You can purchase Pico-8 [here](https://www.lexaloffle.com/pico-8.php). 

<a name="features"></a>
## Features
- Realtime overclocking -> Select + Up/Down.
- Bezel selection -> Select + Left/Right.
- Mouse mode -> L2.
    - Mouse acceleration -> hold R2 (while in mouse mode).
- Splore functionality.
- Multicart support (With full source only).
- Good performance.

<a name="Button Shortcuts"></a>
## Button Shortcuts
- Select + Up/Down - Overclock modifier
- Select + Left/Right - Bezel selection
- L2 - Mouse mode
    - R2 in mouse mode - Mouse acceleration
- Select + R1 - Display scaling modifier
- Select + Menu - Quit
- Select + L1 - Reload cart

<a name="to-do"></a>
## To-do
- Figure out console input for hotkeys (Save, re-enter splore).
- Performance pass...

<a name="bezel-templates"></a>
## Bezel-templates
![int_def_bezel](https://github.com/XK9274/pico-8-wrapper-miyoo/assets/47260768/fd6c1c7b-50bd-410d-8a8e-9cd2a92c9d4c)
![def_border](https://github.com/XK9274/pico-8-wrapper-miyoo/assets/47260768/69bd3a41-26de-4790-b531-1ae74da873f6)

<a name="changelog"></a>
## Changelog

### v0.8.1
- performance pass, FPS now more stable
- added 2 new bezels from u/hippotgfc
- bezels added by @Pogeba and @LiquidDream in #5 and #3
- add a config file fixer function to launch.sh (to fix black screen at launch)
- fix volume down key ghosting last input

### v0.8
- Display mode shortcut added -> SELECT + R1 will toggle between scaled, fullscreen, native output (384x384 from pico-8) (which also has its own bezel selection).
- Frame time adjustments.
- "border" -> "bezel" - folder name replaced, all references replaced to make it a more relatable name.
- Added "integer_scaled" bezel directory, added "standard" bezel directory.
- Removed "def_" version of bezels logic.
- Redraw mouse icon if overlay is changed while in mouse mode
- Only draw alpha when required (for bezels, mouse icon)

### v0.7.2
- Fix repeating input when swapping to mouse.

### v0.7.1
- Slight performance uplift.

### v0.7
- Fix audio issue when Wi-Fi is disabled/enabled (new launch.sh).
- Add mouse icon by Hoo; mouse icon now shows on screen when L2 is pressed.
- Add min/max CPU values as configurable config options in the performance object in onioncfg.json.
- Added a new default bezel by drkhrse and a remix by xk.
- Add location for bezels/digits to onioncfg.json, defaults to /res/digits and /res/bezels.
- Lowered the wait time in config.txt for frame processing for foreground/background.
- Disabled some debugging for drawing items.
- Add sighandler.

### v0.6.1
- Fix overclock display.

### v0.6
- Housekeeping - removed backup libs/unrequired libs.
- Added bezel scrolling with SELECT + LEFT/RIGHT - saves on graceful exit, reads on good load.
- Updated JSON saving function to save it in PRETTY format instead of inline for readability.
- Added some default bezels/bezels for examples.

### v0.5
- Fixed mouse bounds so it can't go into the screen bezel edges (pico window area = 240x240).
- App name for applist changed to `Pico-8`.
- Ceiling of CPU clock set to `1700` after feedback.
- Added basic overlay/bezel for proof of concept (delete it or rename/edit to whatever).
- Guard against missing onioncfg.json (set all defaults for mouse, keyboard, cpuclock).
- Guard against missing res (digits/bezels).
- Added CPU clock indicator and bezel refresh logic.
    - CPU clock will decay over time and stop being drawn.
    - Bezel will be permanent (upcoming keybinds for this).
- Removed carts from the package.

### v0.4
- Housekeeping of package (removed res dirs).
- Swapped A & B.
- X now brings up the in-game menu and allows to exit when at menu (instead of menu btn).
- L2 now acts as a toggle for mouse mode.
- Exit gracefully shortcut is now select + menu.
- All keys not used by single-player games bound to D.
- Select + L1 now restarts the current cart.
- Added shortcut to raise/lower the CPU clock with Select + UP/DOWN and option in onioncfg.json with max 100 increment size, default 25.
- Changed CPU clock ceiling to 1800 and floor to 600.
- Lowered default clock to 1300.

### v0.3
- neon_memcpy ASM added for video performance uplift.
- Mouse support added -> `Select + A` to enter mouse mode, `Start` to exit (config in cfg/onioncfg.json for scaling/acceleration/increment values etc).
- Quit hotkey added -> `Select + Start` - Can't use Select + Menu as pico seems to release the key occasionally and it locks up.
- Overclocking added -> configure currently in the cfg/onioncfg.json file - set to 1400 by default.
- Keybinds added but don't edit these as there's no way to rebind within pico8 currently (needs console support).
- Again, if you dropped into the console you'll have to quit out. The console ignores any input I send to it currently (apart from enter/return).
- Mount bind added to launch.sh to bind your Roms/PICO location to the carts directory.

### v0.2
- Audio.

## Building SDL2 Libs
<a name="building"></a>
`git clone https://github.com/XK9274/pico-8-wrapper-miyoo`

`cd pico-8-wrapper-miyoo`

`make picosdl2`

- If you have parasyte on your dist, you can comment out (in cmd.sh) `copy_lib "/root/workspace/sdl2_miyoo/libGLESv2.so" "$PICO_APP_DIR/pico/lib/libGLESv2.so"` to use a smaller lib & also make the dist smaller
- Make sure your LD_LIBRARY_PATH in `pico/script/launch.sh` reflects the location of this library

<a name="screenshots"></a>
## Screenshots
### Full screen
![Full screen](https://github.com/XK9274/pico-8-wrapper-miyoo/assets/47260768/32566649-9008-43e8-8cd5-9d2a587fe493)

### Aspect scaled
![Aspect scaled](https://github.com/XK9274/pico-8-wrapper-miyoo/assets/47260768/c3434d9e-0ed2-4716-8fc8-655c53390bd6)

### Integer scaled
![Integer scaled](https://github.com/XK9274/pico-8-wrapper-miyoo/assets/47260768/b9679f53-7ff0-4a39-83ca-18aff5abd0b5)

### App entry
![MainUI_005](https://github.com/XK9274/pico-8-wrapper-miyoo/assets/47260768/2aed0514-7981-4f53-b932-bf1c898a6c8c)

---

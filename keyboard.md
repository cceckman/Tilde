# Keyboard Layout

## Reset instructions

Windows version:

`teensy_loader_cli.exe --mcu=atmega32u4 -w -v ergodox_ez_firmware_foo.hex`


# Changelog

## cceckman v0.8.1
http://configure.ergodox-ez.com/keyboard_layouts/kwpjjp/edit

- Add back DEL
  - Noticed I'd removed this while doing the writeup for 0.8 below.
  - I do use this sometimes, so keep it handy - in the nicely mnemonic location of "like backspace, but not quite."
- Add back capslock
  - Yes, it's the most useless key on the keyboard and it's rebound to Control under Linux.
  - But maybe I'll unbind when this keyboard is in use. I do occasionally want to spell variable names (usually in shell) in ALL CAPS, and that's even more difficult than usual on the Ergodox.

## cceckman v0.8
http://configure.ergodox-ez.com/keyboard_layouts/krpddg/edit

Mostly, address asymmetry in modifiers.

- Use middle keys on either side for layer switching
  - Annoying to always use the left hand to switch. 
  - Make switching symmetric, the same method for both aux layers
  - and on bigger buttons (easier targets!)
- Provide an alt on either hand
  - Alt becomes Win, which is my i3 modifier, under Linux. Nice to have that on the same hand sometimes.
  - But, it's still pretty out of the way - on my hands, RAlt + L is not the easiest on the wrist.
  - Let's see how this goes.
- Cleanup of color modifiers on layer 1
- Move home and end on layer 1
  - To more memorable - hopefully more useful - locations.

## cceckman v0.7
http://configure.ergodox-ez.com/keyboard_layouts/qbpyaa/edit

- Add F1-12 keys to layer 1.
  - I've hit these being unavailable in a couple of cases (BIOS, fullscreen Chrome.)
  - F1-9 are on the respective num keys; 10-12 on the right bars.

## cceckman v0.6
http://configure.ergodox-ez.com/keyboard_layouts/komdla/edit

- Fix layer 2 numpad.
  - Move 0 to left of decimal mark, where it is on a normal numpad.
  - Add back missing minux.
- Move reset button away from overloading tab.
  - I reset it many too many times while doing my accounting.

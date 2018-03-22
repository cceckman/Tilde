 # Keyboard Layout

I've got some fancy keyboards: of the [Ergodox](https://www.ergodox.io) and
[Model01](https://www.keyboard.io) varieties.

These are awesome because they're reprogrammable; you can basically make any key
do any old thing. While I haven't dived deep into either firmware, I do
continually tweak the layout to try to make it more comfortable.

# Model01
I have a forked copy of the Model01 source [here](https://github.com/cceckman/Model01-Firmware).
It's approximately based on the Ergodox layout, with some allowances for the
different geometry and for not changing the existing firmware too much at once.
See that repository for its changelog.

# Ergodox

## Reset instructions

Windows version:

`teensy_loader_cli.exe --mcu=atmega32u4 -w -v ergodox_ez_firmware_foo.hex`


# Changelog

## cceckman v.0.12.0
https://configure.ergodox-ez.com/keyboard_layouts/qdybgy/edit

- Remove overloads of A, Space, Z
  - Interfere with gaming; "hold A" needs to mean "keep going right".

## cceckman v.0.11.1
https://configure.ergodox-ez.com/keyboard_layouts/kzympa/edit

- Move around 'reset' key

## cceckman v.0.11.0
https://configure.ergodox-ez.com/keyboard_layouts/kweelw/edit

- Add TT(1,2) on the top-inner row. (Previously ~unused.)
- Add LT1 on outer thumb keys.

I didn't realize that "LT" was a thing:

  Momentary Layer Toggle: Switch to the selected layer when held, send the selected key when tapped.

It's basically dual-funciton keys, but with layers. This would be really nice for the thumb keys- at the moment, I have to move my hand to tap anything in the inner row, which is where the layer-switch keys are.
It also matches the default behavior of a [Model01](https://keyboard.io) better- where the thumbs are primarily modifier keys.


## cceckman v.0.10.0
https://configure.ergodox-ez.com/keyboard_layouts/knwlyj/edit

- Move around modifiers; make them available to either pinky
- Make equals and minus more immediately available

## cceckman v.0.9.0
http://configure.ergodox-ez.com/keyboard_layouts/qypwxr/edit

- Replace right-thumb tab with shift/esc
  - I've just about never used that tab.
- Cleanup: Remove some stuff from layer 1 that just duplicated layer 0
- Use digit punctuation rather than numpad punctuation
  - Same as 0.8.3 issue.
- Add home/end to layer 1
  - A more mnemoic place than the thumb keys, which I can't really reach anyway.

## cceckman v.0.8.3
http://configure.ergodox-ez.com/keyboard_layouts/qbmxbj/edit

- Use digit 0 rather than numpad 0
  - The layer-2 zero was not registering properly a lot of the time. Realized all the other "numpad" characters are being sent as digit-row characters, rather than numpad. Since numlock is irrelevant in the modern age, just tweaked this way instead.

## cceckman v.0.8.2
http://configure.ergodox-ez.com/keyboard_layouts/kowpzz/edit

- Add INS on top of ALT
  - Shift + Insert is important on Linux.

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

# Keyboard Layout

I've got an [Ergodox](https://www.ergodox.io/) that I do rather like.

One of the nice things about it is its reprogrammability; I've done a bit of tweaking to its standard layout to get something that
works well for me. Nothing too crazy- it's slower enough than my
[habitual keyboard](https://www.amazon.com/gp/product/B004SUIM4E/ref=s9_dcacsd_dcoop_bw_c_x_2_w)
without also introducing Dvorak or somesuch - but stuff to fit [my bindgings for](https://github.com/cceckman/Tilde)
[Vim](https://vim.sourceforge.io/), [i3](https://i3wm.org/), [tmux](https://vim.sourceforge.io/), etc.

The version numbers are based on [semantic versioning](http://semver.org/) but don't actually follow it, because I'm still putting everything under v0 for now. The second numeral indicates a backwards-incompatible change, i.e. changing the meaning of a key; a patch adds meaning to a key that didn't have one previously. In theory, at least.

## Reset instructions

Windows version:

`teensy_loader_cli.exe --mcu=atmega32u4 -w -v ergodox_ez_firmware_foo.hex`


# Changelog

## cceckman v.0.11.1
https://configure.ergodox-ez.com/keyboard_layouts/kzympa/edit

- Move around 'reeset' key

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

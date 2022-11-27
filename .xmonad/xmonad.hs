-- TODO(cceckman): Go based on https://wiki.haskell.org/Xmonad/Config_archive/John_Goerzen's_Configuration

-- Imports.
import XMonad
import XMonad.Config.Desktop
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Layout.ResizableTile
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

myLayouts = avoidStruts (
    ResizableTall 1 (3/100) (1/2) [] ||| layoutHook desktopConfig
  )

myKeys = [
    ((mod1Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
--, ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s") -- take screenshot using scrot.
--, ((0, xK_Print), spawn "scrot")
  , ((mod1Mask .|. shiftMask, xK_h), sendMessage MirrorShrink)
  , ((mod1Mask .|. shiftMask, xK_l), sendMessage MirrorExpand)
  ]


-- The main function.
-- main = xmonad =<< statusBar myBar myPP toggleStrutsKey myConfig
main = xmonad =<< xmobar myConfig


-- Use xmonad-contrib's defaults instead of xmonad's.
myConfig = desktopConfig
    {  manageHook = manageDocks <+> manageHook desktopConfig
    , layoutHook = myLayouts
    , handleEventHook = docksEventHook <+> handleEventHook desktopConfig
    -- cceckman: worked out that last one just from http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Hooks-ManageDocks.html
    -- Define logHook for xmonad to write information to xmobar
    --, logHook = dynamicLogWithPP xmobarPP
    --              {  ppOutput = hPutStrLn xmproc
    --              , ppTitle = xmobarColor "green" "" . shorten 50
    --              }
    -- , modMask = mod4Mask -- Use Windows key for mod. I'm file with alt ATM
    } `additionalKeys` myKeys

-- Key binding to toggle the gap for the bar.
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)


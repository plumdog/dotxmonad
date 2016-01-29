import XMonad
import XMonad.Layout.Spacing
import XMonad.Util.CustomKeys
import XMonad.Actions.CycleWS
import XMonad.Actions.SpawnOn
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Util.Run
import XMonad.Layout
import XMonad.Layout.Grid
import XMonad.Layout.Tabbed
import XMonad.Hooks.EwmhDesktops

import System.IO

import Graphics.X11.ExtraTypes.XF86


myterm = "gnome-terminal --hide-menubar"
mybrowser = "google-chrome"
myfind = "gmrun"
mylock = "slock"
mypasswords = "keepassx"
myconfig = "gnome-control-center"
mystartup = "/home/andrew/.startup.sh"

delkeys :: XConfig l -> [(KeyMask, KeySym)]
delkeys XConfig {modMask = modm} = []
inskeys :: XConfig l -> [((KeyMask, KeySym), X ())]
inskeys conf@(XConfig {modMask = modm}) =
  [
    ((modm .|. shiftMask, xK_t), spawn myterm),
    ((modm, xK_n), nextScreen),
    ((modm, xK_a), spawn myfind),
    ((modm .|. shiftMask, xK_l), spawn mylock),
    ((modm, xK_f), spawn mybrowser),
    ((modm, xK_k), spawn mypasswords),
    ((modm, xK_z), spawn myconfig),
    ((modm, xK_g), spawn (mystartup ++ " call")),
    ((0,    xF86XK_AudioMute), spawn "pactl set-sink-mute 0 toggle"),  -- mute
    ((0,    xF86XK_AudioLowerVolume), spawn "pactl set-sink-volume 0 -1.5%"),  -- vol down
    ((0,    xF86XK_AudioRaiseVolume), spawn "pactl set-sink-volume 0 +1.5%")  -- vol up
  ]

myGrid = spacing 8 Grid
mySideBySide = spacing 8 (Tall nmaster delta ratio)
    where
        -- The default number of windows in the master pane
        nmaster = 1
        -- Percent of screen to increment by when resizing panes
        delta   = 3/100
        -- Default proportion of screen occupied by master pane
        ratio   = 60/100
myTabbed = simpleTabbed
myLayout = myTabbed ||| myGrid ||| mySideBySide

xmobarEscape = concatMap doubleLts
  where doubleLts '<' = "<<"
        doubleLts x   = [x]

myWorkspaces = [one, two, three, four, five]
one = "1"
two = "2"
three = "3"
four = "4"
five = "5"


myStartupHook = do
    spawn "/home/andrew/.xinitrc"
    spawn mystartup
    -- run again!
    spawn "/home/andrew/.xinitrc"

main = do
  xmproc <- spawnPipe "/usr/bin/xmobar /home/andrew/.xmobarrc"
  xmonad $ ewmh defaultConfig {
    modMask = mod4Mask,
    terminal = myterm,
    keys = customKeys delkeys inskeys,
    -- to fix xmobar
    manageHook = manageDocks <+> manageSpawn <+> manageHook defaultConfig,
    layoutHook = avoidStruts myLayout,
    -- done
    workspaces = myWorkspaces,
    logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppCurrent = xmobarColor "yellow" "" . wrap "[" "]"
                        , ppHiddenNoWindows = xmobarColor "grey" ""
                        , ppTitle   = xmobarColor "green"  "" . shorten 40
                        , ppVisible = wrap "(" ")"
                        , ppUrgent  = xmobarColor "red" "yellow"
                        },
    startupHook = myStartupHook
  }

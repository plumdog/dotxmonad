import XMonad
import XMonad.Layout.Spacing
import XMonad.Util.CustomKeys
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Layout
import XMonad.Layout.Grid
import XMonad.Layout.Tabbed


myterm = "gnome-terminal"

delkeys :: XConfig l -> [(KeyMask, KeySym)]
delkeys XConfig {modMask = modm} = []
inskeys :: XConfig l -> [((KeyMask, KeySym), X ())]
inskeys conf@(XConfig {modMask = modm}) =
  [
    ((modm .|. shiftMask, xK_t), spawn myterm),
    ((modm .|. shiftMask, xK_d), spawn (myterm ++ " -e 'ssh dev'")),
    ((modm, xK_a), spawn "/usr/bin/gmrun"),
    ((modm, xK_l), spawn "/usr/bin/slock"),
    ((modm, xK_k), spawn "/usr/bin/keepassx"),
    ((modm, xK_z), spawn "/usr/bin/gnome-control-center")
  ]

myGrid = spacing 8 Grid
myTabbed = simpleTabbed
myLayout = myTabbed ||| myGrid

main = do
  xmproc <- spawnPipe "/usr/bin/xmobar /home/andrew/.xmobarrc"
  xmonad $ defaultConfig {
    modMask = mod4Mask,
    terminal = myterm,
    keys = customKeys delkeys inskeys,
    -- to fix xmobar
    manageHook = manageDocks <+> manageHook defaultConfig,
    layoutHook = avoidStruts myLayout
    -- done
  }


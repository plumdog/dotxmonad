import XMonad
import XMonad.Util.CustomKeys
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Actions.GridSelect
import XMonad.Prompt
import XMonad.Prompt.Window


myterm = "gnome-terminal"

delkeys :: XConfig l -> [(KeyMask, KeySym)]
delkeys XConfig {modMask = modm} = []
inskeys :: XConfig l -> [((KeyMask, KeySym), X ())]
inskeys conf@(XConfig {modMask = modm}) =
  [
    ((modm .|. shiftMask, xK_t), spawn (myterm ++ " -e 'ssh dev'")),
    ((modm, xK_g), goToSelected defaultGSConfig),
    ((modm, xK_a), spawn "/usr/bin/gmrun"),
    ((modm, xK_l), spawn "/usr/bin/slock"),
    ((modm .|. shiftMask, xK_g), windowPromptGoto defaultXPConfig),
    ((modm .|. shiftMask, xK_b), windowPromptBring defaultXPConfig)
  ]


main = do
  xmproc <- spawnPipe "/usr/bin/xmobar /home/andrew/.xmobarrc"
  xmonad $ defaultConfig {
    modMask = mod4Mask,
    terminal = myterm,
    keys = customKeys delkeys inskeys,
    -- to fix xmobar
    manageHook = manageDocks <+> manageHook defaultConfig,
    layoutHook = avoidStruts $ layoutHook defaultConfig
    -- done
  }


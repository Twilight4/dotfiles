#  _____ _
# |_   _| |        Qtile Configuration File of TL - Twilight4
#   | | | |
#   | | | |___     https://github.com/Twilight4/
#   |_| |_____|
#
# A customized config.py for Qtile window manager (http://www.qtile.org).
# Modified by Twilight4 (https://github.com/Twilight4/)

import os
import subprocess 

from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

# --------------------- PREFS ---------------------
terminal = "alacritty"
browser = "min"
#screenshot_tool = "flameshot gui"
screenshot = "screenshot.sh"
volume = "volume.sh"
brightness = "brightness.sh"
apps = "apps.sh"
battery = "battery.sh"
powermenu = "powermenu.sh"
mpd = "mpd.sh"
quicklinks = "quicklinks.sh"

# --------------------- KEYS ---------------------
mod = "mod4"

keys = [
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),

    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),

    Key([mod, "shift"], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod, "w"], lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
        
    Key([mod, "shift"], "enter", lazy.spawn(browser), desc="Launch web browser"),
    #Key([mod], "prt scr", lazy.spawn(screenshot_tool), desc="Launch screenshot tool"), --- check if rofi ss menu isn't better
    Key([mod], "s", lazy.spawn(screenshot), desc="Launch screenshot menu"), # check if screenshot tool isn't better
    Key([mod], "x", lazy.spawn(volume), desc="Launch volume menu"), # check if seperate keybindings aren't better
    Key([mod], "z", lazy.spawn(brightness), desc="Launch brightness menu"), # check if seperate keybindings aren't better
    Key([mod], "r", lazy.spawn(apps), desc="Launch fav apps menu"),
    Key([mod], "b", lazy.spawn(battery), desc="Launch battery menu"),
    Key([mod], "p", lazy.spawn(powermenu), desc="Launch power menu"),    
    Key([mod], "m", lazy.spawn(mpd), desc="Launch mpd menu"),
    Key([mod], "l", lazy.spawn(quicklinks), desc="Launch quicklinks menu"),
]

mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

## Floating windows - Defining what class of windows should always be floating.
#floating_layout = layout.Floating(float_rules=[
 ## Run the utility fo `xprop` to see the wm class and name of an X client.
 ## default_float_rules include: utility, notifications, toolbar, splash, dialog
 ## file_progress, confirm, download and error.
#    ,*layout.Floating.default_float_rules,
#    Match(title='program'),         # Choose which app
#    Match(title='application'),     # Choose which app
#    Mach(wm_class='application2'),  # Choose which app
#])

# --------------------- GROUPS ---------------------
groups = [Group("", layout='monadtall'),
          Group("﨩", layout='monadtall'),
          Group("", layout='monadtall'),
          Group("", layout='monadtall'),
          Group("", layout='monadtall'),
          Group("", layout='monadtall'),
          Group("", layout='monadtall'),]

groups = [Group(i) for i in ["", "﨩", "", "", "", "", ""]]
groups_hotkeys = "1234567"

for i, k in zip(groups, groups_hotkeys):
    keys.extend(
        [
            Key(
                [mod],
                k,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            Key(
                [mod, "shift"],
                k,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
        ]
    )
    
# --------------------- LAYOUTS ---------------------
layouts = [
        layout.MonadTall(
            margin = 5,
            border_focus = '#89dceb',
            border_width=2,
        ),
]

# --------------------- RULES ---------------------
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)

# --------------------- COLORS ---------------------
hack = {
  'bg': '#01161b',
  'fg': '#66FFFF',
  'dark-grey': '#142A2F',
  'dark-red': '#007b82',
  'dark-green': '#028c94',
  'dark-yellow': '#039ca4',
  'dark-blue': '#04acb5',
  'dark-magenta': '#05bbc5',
  'dark-cyan': '#06ccd7',
  'white': '#ffffff',
}
  
colors = hack

# --------------------- CONFIG.PY ---------------------
widget_defaults = dict(
    font="MesloLGM-NF",
    fontsize=12,
    background=colors['bg'],
    foreground=colors['fg'],
    padding=7,
)
extension_defaults = widget_defaults.copy()

# DISCLAIMER: Commented lines do NOT work (at least on VBox)
screens = [
      ]

@hook.subscribe.startup
def autostart():
    home = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.Popen([home])

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
wl_input_rules = None
wmname = "Qtile"

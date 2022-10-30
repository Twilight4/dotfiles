from libqtile.config import Drag, Click, Key
from libqtile.lazy import lazy
from settings.prefs import terminal, browser, screenshot, volume, brightness, apps, battery, powermenu, mpd, quicklinks

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
        
    Key([mod, "shift"], "Return", lazy.spawn(browser), desc="Launch web browser"),
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

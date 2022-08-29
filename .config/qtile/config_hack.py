import os
import subprocess 

from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

from settings.key_bindings import mod, mouse, keys
from settings.layouts import layouts
from settings.colors_hack import colors_hack
from settings.groups import groups
from settings.prefs import prefs
from settings.rules import rules

widget_defaults = dict(
    font="MesloLGS-NF",
    fontsize=12,
    background=colors['bg'],
    foreground=colors['fg'],
    padding=10,
)
extension_defaults = widget_defaults.copy()

# DISCLAIMER: Commented lines do NOT work on VBox
screens = [
    Screen(
        top=bar.Bar(
            [
                widget.Image(
                    filename='~/.config/qtile/icons/skull.png',
                    margin=3,
                    background=colors['bg'],
                    scale=True,
                    ),
                widget.Sep(
                    foreground=colors['fg'],
                    background=colors['bg'],
                    size_percent=100,
                    padding=8,
                    ),
                widget.GroupBox(
                    highlight_method='line',
                    this_current_screen_border=colors['white'],
                    active=colors['white'],
                    background=colors['bg'],
                    foreground=colors['fg'],
                    highlight_color=colors['bg'],
                    borderwidth=1,
                    ),
                widget.Sep(
                    foreground=colors['fg'],
                    background=colors['bg'],
                    size_percent=100,
                    padding=8,
                    ),
                widget.WindowName(
                    background=colors['white'],
                    foreground=colors['fg'],
                    format = "{name}",
                    empty_group_string = 'Desktop',
                    width = 120,
                    ),
                widget.Sep(
                    foreground=colors['fg'],
                    background=colors['bg'],
                    size_percent=100,
                    padding=8,
                    ),
                widget.Prompt(
                    prompt = "Run: ",
                    foreground=colors['fg'],
                    background=colors['bg'],
                    ),
                widget.Spacer(),
                widget.Systray(
                    background=colors['bg'],
                    ),
                #widget.CheckUpdates(
                    #update_interval = 1800,
                    #foreground=colors['white'],
                    #background=colors['bg'],
                    #colour_have_updates=colors['dark-yellow'],
                    #colour_no_updates=colors['white'],
                    #display_format='ﮮ Updates: {updates}',
                    #no_update_string=' Fully Updated',
                    ),
                widget.Sep(
                    foreground=colors['fg'],
                    background=colors['bg'],
                    size_percent=100,
                    padding=8,
                    ),
                widget.Net(
                    background=colors['bg'],
                    foreground=colors['white'],
                    update_interval = 3,
                    format = '{down} ↓↑{up}',
                    ),
                
                widget.Image(
                    filename='~/.config/qtile/icons/processor.png',
                    margin=4,
                    background=colors['bg'],
                    scale=True,
                    ),
                widget.CPU(
                    foreground=colors['white'],
                    background=colors['bg'],
                    format = '{load_percent}% '
                    padding = 0
                    ),
                #widget.ThermalZone(
                    #foreground=colors['white'],
                    #background=colors['bg'],
                    #fgcolor_high=colors['dark-yellow'],
                    #fgcolor_crit=colors['dark-red'],
                    #fgcolor_normal=colors['white'],
                    #high=70,
                    #crit=90,
                    #format = ' {temp}°C',
                    #format_crit = ' {temp}°C',
                    #),
                widget.Sep(
                    foreground=colors['fg'],
                    background=colors['bg'],
                    size_percent=100,
                    padding=8,
                    ),
                widget.Memory(
                    foreground=colors['white'],
                    background=colors['bg'],
                    format='{MemUsed: .0f}{mm}/{MemTotal:.0f}{mm}',
                    ),
                widget.DF(
                    warn_space = 40,
                    warn_color=colors['dark-red'],
                    format = {'{p} ({uf}{m}|{r:.0f}%)'},
                    measure = 'G',
                    partition = '/',
                    background=colors['bg'],
                    ),
                widget.Sep(
                    foreground=colors['fg'],
                    background=colors['bg'],
                    size_percent=100,
                    padding=8,
                    ),
                #widget.Battery(
                    #foreground=colors['white'],
                    #background=colors['bg'],
                    #full_char = ' ',
                    #charge_char = ' ',
                    #empty_char = ' ',
                    #format = '{char} {percent:2.0%}',
                    #low_foreground=colors['dark-yellow'],
                    #low_percentage = 0.2,
                    #),
                #widget.Wlan(
                  #foreground=colors['white'],
                  #background=colors['bg'],
                  #disconnected_message='睊',
                  #format='{percent:75% 直}',
                    #),
                widget.Sep(
                    foreground=colors['fg'],
                    background=colors['bg'],
                    size_percent=100,
                    padding=8,
                    ),
                widget.Clock(
                    format=' %I:%M %p',
                    foreground=colors['white'],
                    background=colors['bg'],
                    ),
                 ],
             20,
            border_width=[1, 1, 1, 1],  # Draw top and bottom borders
            border_color=["#66FFFF", "#66FFFF", "#66FFFF", "#66FFFF"],
            margin=[3, 10, 0, 10],
            ),
         ),
      ]

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

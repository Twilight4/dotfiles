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

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.Image(
                    filename='~/.config/qtile/icons/skull.png',
                    margin=2.5,
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
                    this_current_screen_border=colors['light-grey'],
                    active=colors['light-grey'],
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
                    background=colors['light-grey'],
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
                widget.CheckUpdates(
                    update_interval = 1800,
                    foreground=colors['fg'],
                    background=colors['bg'],
                    colour_have_updates['dark-yellow'],
                    colour_no_updates['light-grey'],
                    display_format='ﮮ Updates: {updates}',
                    no_update_string=' Fully Updated'
                    ),
                widget.Sep(
                    foreground=colors['fg'],
                    background=colors['bg'],
                    size_percent=100,
                    padding=8,
                    ),
                #widget.Net(
                #    background=colors['dark-grey'],
                #    foreground=colors['dark-yellow'],
                #    update_interval = 3,
                #    format = '{down} ↓↑ {up}',
                #    ),
                widget.CPU(
                    foreground=colors['light-grey'],
                    background=colors['bg'],
                    format = ' {load_percent}%',
                    ),
                widget.ThermalZone(
                    foreground=colors['light-grey'],
                    background=colors['bg'],
                    fgcolor_high=colors['dark-yellow'],
                    fgcolor_crit=colors['dark-red'],
                    fgcolor_normal=colors['light-grey'],
                    high=70,
                    crit=90,
                    format = ' {temp}°C',
                    format_crit = ' {temp}°C',
                    ),
                widget.Sep(
                    foreground=colors['fg'],
                    background=colors['bg'],
                    size_percent=100,
                    padding=8,
                    ),
                widget.Memory(
                    foreground=colors['light-grey'],
                    background=colors['bg'],
                    format='{MemUsed: .0f}{mm}/{MemTotal:.0f}{mm}',
                    ),
                widget.DF(
                    warn_space = 40,
                    format = {'{p} ({uf}{m}|{r:.0f}%)'},
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
                widget.Battery(
                    foreground=colors['light-grey'],
                    background=colors['bg'],
                    full_char = ' ',
                    charge_char = '',
                    empty_char = ' ',
                    format = '{char} {percent:2.0%}',
                    low_foreground=colors['dark-yellow'],
                    low_percentage = 0.2,
                    ),
                widget.Wlan(
                  foreground=colors['light-grey'],
                  background=colors['bg'],
                  disconnected_message='睊',
                  format='{percent:75% 直}',
                    ),
                widget.Sep(
                    foreground=colors['fg'],
                    background=colors['bg'],
                    size_percent=100,
                    padding=8,
                    ),
                widget.Clock(
                    format=' %I:%M %p',
                    foreground=colors['light-grey'],
                    background=colors['bg'],
                    ),
            border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            border_color=["ff00ff", "000000", "ff00ff", "000000"],
             19,
             ],
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

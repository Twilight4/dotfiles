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
    fontsize=17,
    background = "#1d1d2d",
    foreground=colors['black'],
    padding=10,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
screens = [
    Screen(
        top=bar.Bar(
            [
                widget.Image(
                    filename='~/.config/qtile/icons/arch.png',
                    margin=3,
                    background=colors['fg']
                    ),
                widget.Sep(
                    foreground=colors['fg'],
                    background=colors['bg'],
                    size_percent=90,
                    padding=10
                    ),
                widget.GroupBox(
                    highlight_method='line',
                    this_current_screen_border=colors['light-grey'],
                    active=colors['light-grey'],
                    background=colors['bg'],
                    borderwidth=1
                    ),
                widget.Sep(
                    foreground=colors['fg'],
                    background=colors['bg'],
                    size_percent=90,
                    padding=10
                    ),
                widget.WindowName(
                    background = colors['dark-grey'],
                    format = "{name}",
                    foreground = colors['fg'],
                    empty_group_string = 'Desktop',
                    width = 200,
                    ),
                widget.Sep(
                    foreground=colors['fg'],
                    background=colors['bg'],
                    size_percent=90,
                    padding=10
                    ),
                widget.Prompt(
                    prompt = "Run: ",
                    foreground=colors['fg'],
                    background=colors['bg'],
                    ),
                widget.Spacer(),
                widget.Sep(
                    foreground=colors['fg'],
                    background=colors['bg'],
                    size_percent=90,
                    padding=10
                    ),
                #widget.Net(
                #    background=colors['dark-grey'],
                #    foreground = colors['dark-yellow'],
                #    update_interval = 3,
                #    format = "{down} {up}",
                #    ),
                widget.CPU(
                    foreground=colors['fg'],
                    background=colors['bg'],
                    format = ' {load_percent}%',
                    ),
                #widget.ThermalZone(
                #    foreground = colors['fg'],
                #    background = colors['bg'],
                #),
                widget.Sep(
                    foreground=colors['fg'],
                    background=colors['bg'],
                    size_percent=90,
                    padding=10
                widget.Memory(
                    foreground=colors['fg'],
                    background=colors['bg'],
                    format='{MemUsed: .0f}{mm}/{MemTotal:.0f}{mm}',
                    ),
                widget.DF(
                    warn_space = 40,
                    format = {'{p} ({uf}{m}|{r:.0f}%)'},
                    measure = 'G',
                    partition = '/',
                    background=colors['bg']
                    ),
                widget.Sep(
                    foreground=colors['fg'],
                    background=colors['bg'],
                    size_percent=90,
                    padding=10
                    ),
                widget.Battery(
                    foreground=colors['fg'],
                    background=colors['bg'],
                    full_char = '=',
                    low_foreground = 'FF0000',
                    low_percentage = 0.1,
                       ),
                widget.Wlan(
                  foreground=colors['fg'],
                  background=colors['bg'],
                  disconnected_message='Disconnected',
                  format='{essid} {percent:2.0%}',
                     ),
                widget.Sep(
                    foreground=colors['fg'],
                    background=colors['bg'],
                    size_percent=90,
                    padding=10
                    ),
                widget.Clock(
                        format=' %I:%M %p',
                        foreground=colors['fg'],
                        background=colors['bg'],
                        ),
            border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            border_color=["ff00ff", "000000", "ff00ff", "000000"] 
             19,
             ],
            ),
         ),
      ]


                
                widget.Prompt(),
                    foreground=colors[''],
                    background=colors[''],
                widget.Spacer(),
                widget.Sep(
                    foreground=colors[''],
                    background=colors[''],
                    line_width=9,
                    size_percent=70,
                widget.CPU(
                    foreground=colors[''],
                    background=colors[''],
                    format = ' {load_percent}%'
                    ),
                widget.Memory(
                    foreground=colors[''],
                    background=colors[''],
                    format='{MemUsed: .0f}{mm}/{MemTotal:.0f}{mm}',
                        ),
                widget.DF(
                    warn_space = 40
                    format = {m}
                    measure = 'G'
                    partition = `/`
                       )
                widget.Sep(
                    foreground=colors[''],
                    background=colors[''],
                    line_width=9,
                    size_percent=70,
                       )      
                widget.CheckUpdates(
                    foreground=colors[''],
                    background=colors[''],
                    colour_have_updates[''],
                    colour_no_updates[''],
                    custom_command = 
                    display_format = {updates}'
                    distro = 'Arch'
                       )
                widget.Sep(
                    foreground=colors[''],
                    background=colors[''],
                    line_width=9,
                    size_percent=70,
                       )
                widget.Batterry(
                    foreground=colors[''],
                    background=colors[''],
                    format = {percent:2.0%} 
                    full_char = '='
                    low_foreground = 'FF0000'
                    low_percentage = 0.1
                       ),
                widget.Wlan(
                  foreground=colors[''],
                  background=colors[''],
                  disconnected_message = 
                  format = '{essid} {quality}/70'
                     ),
                widget.Sep(
                    foreground=colors[''],
                    background=colors[''],
                    line_width=9,
                    size_percent=70,
                  ),
                widget.Clock(
                     format=' %d/%m/%y %H:%M'
                     foreground=colors[''],
                     background=colors[''],
                     ),

                    29,
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

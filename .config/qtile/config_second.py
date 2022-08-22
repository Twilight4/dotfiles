import os
import subprocess 

from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

from settings.key_bindings import mod, mouse, keys
from settings.layouts import layouts
from settings.colors import colors
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
                widget.Image(
                filename='~/.config/qtile/icons/arch.png',
                    margin=3,
                    background=colors['dark-grey']
                    ),
                widget.Sep(
                    foreground=colors['blue'],
                    background=colors['dark-grey'],
                    line_width=9,
                    size_percent=70,
                    ),
                widget.GroupBox(
                    highlight_method='text',
                    this_current_screen_border = colors['dark-blue'],
                    active = colors['blue'],
                    background=colors['dark-grey'],
                    ),
                widget.Sep(
                    foreground=colors['blue'],
                    background=colors['dark-grey'],
                    line_width=9,
                    size_percent=70,
                    ),
                widget.Prompt()
                    foreground=colors['blue'],
                    background=colors['dark-grey'],
                widget.Spacer(),
                widget.Sep(
                    foreground=colors['blue'],
                    background=colors['dark-grey'],
                    line_width=9,
                    size_percent=70,
                widget.CPU(
                    foreground=colors['blue'],
                    background=colors['dark-grey'],
                    format = ' {load_percent}%'
                    ),
                widget.Memory(
                    foreground=colors['blue'],
                    background=colors['dark-grey'],
                    format='{MemUsed: .0f}{mm}/{MemTotal:.0f}{mm}',
                        ),
                widget.DF(
                    warn_space = 40
                    format = {m}
                    measure = 'G'
                    partition = `/`
                       )
                widget.Sep(
                    foreground=colors['blue'],
                    background=colors['dark-grey'],
                    line_width=9,
                    size_percent=70,
                       )      
                widget.CheckUpdates(
                    foreground=colors['blue'],
                    background=colors['dark-grey'],
                    colour_have_updates[''],
                    colour_no_updates[''],
                    custom_command = 
                    display_format = {updates}'
                    distro = 'Arch'
                       )
                widget.Sep(
                    foreground=colors['blue'],
                    background=colors['dark-grey'],
                    line_width=9,
                    size_percent=70,
                       )
                widget.Batterry(
                    foreground=colors['blue'],
                    background=colors['dark-grey'],
                    format = {percent:2.0%} 
                    full_char = '='
                    low_foreground = 'FF0000'
                    low_percentage = 0.1
                       ),
                widget.Wlan(
                  foreground=colors['blue'],
                  background=colors['dark-grey'],
                  disconnected_message = 
                  format = '{essid} {quality}/70'
                     ),
                widget.Sep(
                    foreground=colors['blue'],
                    background=colors['grey'],
                    line_width=9,
                    size_percent=70,
                  ),
                widget.Clock(
                     format=' %d/%m/%y %H:%M'
                     foreground=colors['light-grey'],
                     background=colors['grey'],
                     ),

             29,
             border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            border_color=["ff00ff", "000000", "ff00ff", "000000"] 
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

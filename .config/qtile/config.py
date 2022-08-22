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
                    background=colors['light-grey']
                    ),
                 widget.TextBox(
                    text='\uE0B0',
                    background='#1d1d2d',
                    foreground=colors['light-grey'],
                    padding=0,
                    fontsize = 25,
                    ),
                widget.GroupBox(
                    highlight_method='text',
                    this_current_screen_border = colors['yellow'],
                    active = colors['blue'],
                    background = "#101213",
                    ),
                 widget.TextBox(
                    text='\uE0B0',
                    foreground="#101213",
                    background=colors['grey'],
                    padding=0,
                    fontsize = 35,
                    ),
                 widget.WindowName(
                    background = colors['grey'],
                    format = "{name}",
                    foreground = colors['fg'],
                    empty_group_string = 'Desktop',
                    width = 200,
                    ),
                 widget.TextBox(
                    text='\uE0B0',
                    background='#1d1d2d',
                    foreground=colors['grey'],
                    padding=0,
                    fontsize = 35,
                    ),
                widget.Prompt(
                    prompt = "Run:",
                    foreground=colors['cyan']
                    ),
                widget.Spacer(),
                widget.TextBox(
                    text='',
                    foreground=colors['grey'],
                    background='#1d1d2d',
                    padding=-0,
                    fontsize=48
                    ),
                #widget.ThermalZone(
                #    foreground = colors['fg'],
                #    background = colors['bg'],
                #),
                widget.Net(
                    background=colors['grey'],
                    foreground = colors['light-grey'],
                    update_interval = 3,
                    format = "{down} {up}",
                    ),
                widget.Sep(
                    foreground=colors['fg'],
                    background=colors['grey'],
                    line_width=9,
                    size_percent=70,
                    ),
                widget.CPU(
                    foreground=colors['light-grey'],
                    background=colors['grey'],
                    format = ' {load_percent}%'
                    ),
                widget.Sep(
                    foreground=colors['fg'],
                    background=colors['grey'],
                    line_width=9,
                    size_percent=70,
                    ),
                widget.Memory(
                    foreground=colors['light-grey'],
                    background=colors['grey'],
                    format='{MemUsed: .0f}{mm}/{MemTotal:.0f}{mm}',
                        ),
                widget.Sep(
                    foreground=colors['fg'],
                    background=colors['grey'],
                    line_width=9,
                    size_percent=70,
                    ),
                widget.Clock(
                        format=' %I:%M %p',
                        foreground=colors['light-grey'],
                        background=colors['grey'],
                        ),
             ],
             29,
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

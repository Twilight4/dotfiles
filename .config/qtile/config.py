from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

from settings.colors import colors
from settings.key_bindings import key_bindings

 ########################## GROUPS ##########################################################
 #groups = [Group(i) for i in "123456"]
 groups = [Group("", layout='monadtall'),
           Group("爵", layout='monadtall'),
           Group("", layout='monadtall'),
           Group("", layout='monadtall'),
           Group("", layout='monadtall'),]
  for i in groups:
    keys.extend(
         [
             # mod1 + letter of group = switch to group
             Key(
                 [mod],
                 i.name,
                 lazy.group[i.name].toscreen(),
                 desc="Switch to group {}".format(i.name),
             ),
             # mod1 + shift + letter of group = switch to & move focused window to group
             Key(
                 [mod, "shift"],
                 i.name,
                 lazy.window.togroup(i.name, switch_group=True),
                 desc="Switch to & move focused window to group {}".format(i.name),
             ),
             # Or, use below if you prefer not to switch to that group.
             # # mod1 + shift + letter of group = move focused window to group
             # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
             #     desc="move focused window to group {}".format(i.name)),
         ]
     )
 ########################## LAYOUTS ######################################################
 layouts = [
    layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
    layout.Max(),
 ]
 ########################## WIDGETS ########################################################
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
                 #widget.Image(
                 #filename'~/.config/qtile/icons/arch.png'
                 #    margin=3,
                 #    background=colors['grey']
                 #    ),
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
                 widget.Net(
                     background=colors['grey'],
                     foreground = colors['cyan'],
                     format = "{down}  {up}",
                     prefix='M'
                     ),
                 widget.Sep(
                     foreground=colors['orange'],
                     background=colors['grey'],
                     line_width=9,
                     size_percent=70,
                     ),
                 widget.CPU(
                     foreground=colors['cyan'],
                     background=colors['grey'],
                     format = '  {load_percent}%'
                     ),
                 widget.Sep(
                     foreground=colors['orange'],
                     background=colors['grey'],
                     line_width=9,
                     size_percent=70,
                     ),
                 widget.Memory(
                     foreground=colors['cyan'],
                     background=colors['grey'],
                     format='{MemUsed: .0f}{mm}/{MemTotal:.0f}{mm}',
                         ),
                 widget.Sep(
                     foreground=colors['orange'],
                     background=colors['grey'],
                     line_width=9,
                     size_percent=70,
                     ),
                 widget.Clock(
                       format=' %I:%M %p',
                       foreground=colors['cyan'],
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

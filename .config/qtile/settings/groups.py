from settings.keys import keys
from libqtile.config import Key, Group
from libqtile.config import Group, Match
from libqtile.lazy import lazy
from libqtile.dgroups import simple_key_binder

groups = [Group("", layout='monadtall'),
          Group("爵", layout='monadtall'),
          Group("", layout='monadtall'),
          Group("", layout='monadtall'),
          Group("", layout='monadtall'),]

#for i in groups:
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


# According to this pattern
for i in groups:
    keys.extend(
     [
            Key([mod], [i.1],
                lazy.group[i.1].toscreen(),
                desc="Switch to group {}".format(i.1),
               ),
            Key([mod], [i.2],
                lazy.group[i.2].toscreen(),
                desc="Switch to group {}".format(i.2),
               ),
            Key([mod], [i.3],
                lazy.group[i.3].toscreen(),
                desc="Switch to group {}".format(i.3),
               ),   
            Key([mod], [i.4],
                lazy.group[i.4].toscreen(),
                desc="Switch to group {}".format(i.4),
               ),
            Key([mod], [i.5],
                lazy.group[i.5].toscreen(),
                desc="Switch to group {}".format(i.5),
               ),
# switch & move focused window to group
            Key(
                [mod, "shift"], i.1,
                lazy.window.togroup(i.2, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.2),
            )
            Key(
                [mod, "shift"], i.2,
                lazy.window.togroup(i.2, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.2),
            )
            Key(
                [mod, "shift"], i.3,
                lazy.window.togroup(i.3, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.3),
            )
            Key(
                [mod, "shift"], i.4,
                lazy.window.togroup(i.4, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.4),
            )
            Key(
                [mod, "shift"], i.5,
                lazy.window.togroup(i.5, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.5),
            )
     ]


# First Idea
#for i, g in enumerate(groups):
#  keys.extend([
#    Key([mod], str(i + 1),
#    desc="Switch to group {}".format(i, g)),
#    Key([mod], str(i + 2),
#    desc="Switch to group {}".format(i, g)),
#    Key([mod], str(i + 3),
#    desc="Switch to group {}".format(i, g)),
#    Key([mod], str(i + 4),
#    desc="Switch to group {}".format(i, g)),
#    Key([mod], str(i + 5),
#    desc="Switch to group {}".format(i, g)),])

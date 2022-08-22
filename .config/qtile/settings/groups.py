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


dgroups_key_binder = simple_key_binder("mod4")
for i in groups:
    keys.extend(
        [
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
        ]
    )

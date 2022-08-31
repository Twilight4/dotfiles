from settings.keys import keys
from libqtile.config import Key, Group
from libqtile.config import Group, Match
from libqtile.lazy import lazy

groups = [Group("", layout='monadtall'),
          Group("﨩", layout='monadtall'),
          Group("", layout='monadtall'),
          Group("", layout='monadtall'),
          Group("", layout='monadtall'),
          Group("", layout='monadtall'),
          Group("輸", layout='monadtall'),]

groups = [Group(i) for i in ["", "﨩", "", "", "", "", "輸"]]
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

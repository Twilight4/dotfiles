from libqtile.config import Key, Group
from libqtile.lazy import lazy
from settings.key_bindings import mod, keys

# groups = [Group(i) for i in "12345"]

groups = [Group(f"{i+1}", label="") for i in range(5)]

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

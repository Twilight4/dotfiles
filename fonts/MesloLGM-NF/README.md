In Linux systems copy the font files to `/usr/share/fonts/` or `/usr/local/share/fonts/` location to install fonts for all users i.e. system-wide.

If you want to install fonts for a particular user, copy the fonts to `~/.local/share/fonts/` location.

To refresh the font cache: `fc-cache -f`

To see all the fonts available on the system: `fc-list`

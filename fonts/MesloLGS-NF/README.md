In Debian-based systems like Ubuntu and its derivatives, copy the font files to /usr/share/fonts/ or /usr/local/share/fonts/ location to install fonts for all users i.e. system-wide.

If you want to install fonts for a particular user, copy the fonts to ~/.local/share/fonts/ location.

Next, we need to refresh the font cache:
fc-cache -f

To see all the fonts available on the system, you need to run this command in a shell:
fc-list

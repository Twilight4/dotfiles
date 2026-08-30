#!/usr/bin/env bash
# osk-menu-watch.sh - make the wvkbd on-screen keyboard work in the Omarchy
# menu (SUPER+Space launcher). The menu is a key-catcher layer surface
# (namespace "omarchy-menu") with no text-input-v3, so wvkbd's input-method
# commits never reach its search. While the menu is open this watcher:
#   1. auto-shows wvkbd (and hides it on close, only if we showed it)
#   2. forwards wvkbd's -o key output to the menu via wtype (virtual-keyboard
#      protocol = real key events, which the menu's keyCatcher handles)
# Owns the wvkbd process (started with -o); osk-toggle.sh stays the manual
# show/hide gesture and only signals this instance.
# Started from ~/.config/hypr/autostart.lua.

BIN=wvkbd-mobintl
STATE="${XDG_RUNTIME_DIR:-/tmp}/osk-visible"     # shared with osk-toggle.sh
SHOWN="${XDG_RUNTIME_DIR:-/tmp}/osk-menu-shown"  # set when we auto-showed it
FWD_PID=""

menu_open() {
    hyprctl layers -j | grep -q '"namespace": "omarchy-menu"'
}

# wvkbd -o emits a byte stream: printable chars as-is, \n=Enter, \b=BackSpace,
# \t=Tab (dropped: useless in the menu). Special keys (arrows, Esc) print
# nothing and can't be forwarded - ponytail: known ceiling, tap the menu rows.
forward_keys() {
    local ch
    while IFS= read -r -n1 ch; do
        menu_open || continue
        case "$ch" in
            "")     wtype -k Return ;;
            $'\b')  wtype -k BackSpace ;;
            $'\t')  ;;
            *)      wtype -- "$ch" ;;
        esac
        sleep 0.07  # the menu drops virtual-keyboard events fired back-to-back
    done
}

start_osk() {
    pkill -x "$BIN" 2>/dev/null
    rm -f "$STATE" "$SHOWN"
    setsid "$BIN" --hidden -o 2>/dev/null | { forward_keys; } &
    FWD_PID=$!
    sleep 0.5  # let wvkbd map and grab the input method before signalling
}

start_osk
open=0
while true; do
    if ! pgrep -x "$BIN" >/dev/null || ! kill -0 "$FWD_PID" 2>/dev/null; then
        start_osk
        continue
    fi
    if menu_open; then
        if [ "$open" = 0 ]; then
            open=1
            if [ ! -f "$STATE" ]; then
                pkill -USR2 -x "$BIN" && touch "$STATE" "$SHOWN"
            fi
        fi
    elif [ "$open" = 1 ]; then
        open=0
        if [ -f "$SHOWN" ]; then
            pkill -USR1 -x "$BIN"
            rm -f "$STATE" "$SHOWN"
        fi
    fi
    sleep 0.3
done

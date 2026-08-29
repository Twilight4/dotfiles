#!/usr/bin/env bash
# osk-toggle.sh - show/hide the wvkbd on-screen keyboard.
# Triggered by a hyprgrass touchscreen gesture (swipe up from bottom edge).
# Starts wvkbd on demand if it is not running; keeps visibility state in a
# file so repeated swipes toggle correctly.

BIN=wvkbd-mobintl
STATE="${XDG_RUNTIME_DIR:-/tmp}/osk-visible"

if ! pgrep -x "$BIN" >/dev/null; then
    setsid "$BIN" --hidden >/dev/null 2>&1 &
    # wait for it to map and grab the input method before signalling
    for _ in $(seq 1 10); do
        pgrep -x "$BIN" >/dev/null && break
        sleep 0.1
    done
    sleep 0.3
fi

if [ -f "$STATE" ]; then
    pkill -USR1 -x "$BIN" && rm -f "$STATE"
else
    pkill -USR2 -x "$BIN" && touch "$STATE"
fi

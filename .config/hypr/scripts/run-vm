#!/bin/sh

# you can use blobal keybind to run this script in order to quickly run given VM, this is windows example
virsh --connect qemu:///system start windows10

looking-glass-client -m KEY_RIGHTCTRL

# destroy windows session when window is closed
virsh --connect qemu:///system destroy windows10

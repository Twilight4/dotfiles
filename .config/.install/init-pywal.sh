#!/bin/bash

cat <<"EOF"
 _       _ _                               _ 
(_)_ __ (_) |_   _ __  _   ___      ____ _| |
| | '_ \| | __| | '_ \| | | \ \ /\ / / _` | |
| | | | | | |_  | |_) | |_| |\ V  V / (_| | |
|_|_| |_|_|\__| | .__/ \__, | \_/\_/ \__,_|_|
                |_|    |___/                 

EOF

_installSymLink wal ~/.config/wal ~/desktop/workspace/dotfiles/wal/ ~/.config
wal -i ~/pictures/wallpapers/default.jpg -s -t
echo "Pywal and templates initiated!"
echo ""

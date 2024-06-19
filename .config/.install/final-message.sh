#!/bin/bash

# Post-install message
echo "DONE, Please logout and reboot your system."
echo "------------------------------ AFTER REBOOT ------------------------------"
echo "1. Import browser bookmarks"
echo "2. Import your OpenAI API key for emacs in '~/.authinfo':"
echo '    machine api.openai.com login apikey password <TOKEN_HERE>'
echo '3. Copy ai prompts to emacs dir to source them:'
echo '    cp ~/desktop/workspace/dotfiles/.config/ai-prompts ~/.cache/emacs'
echo "4. Add pub key to github: Settings > SSH > New:"
echo '    ssh-keygen -t ed25519'
echo "5. Clone relevant repos via SSH:"
echo '    git clone git@github.com:Twilight4/dotfiles.git ~/desktop/workspace/dotfiles'
echo '    git clone git@github.com:Twilight4/debian-setup.git ~/desktop/workspace/debian-setup'
echo '    git clone git@github.com:Twilight4/org.git ~/documents/org'
echo '    git clone git@github.com:Twilight4/cheats.git ~/.config/cheat'
echo ""

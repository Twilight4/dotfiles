#!/bin/bash

clear
cat <<"EOF"
 ____              _              _     
|  _ \ ___ _ __   | |_ ___   ___ | |___ 
| |_) / _ \ '_ \  | __/ _ \ / _ \| / __|
|  __/  __/ | | | | || (_) | (_) | \__ \
|_|   \___|_| |_|  \__\___/ \___/|_|___/
                                        
                         
EOF

read -p "Do you want to install pentesting tools? (y/n) " answer

case ${answer:0:1} in
    y|Y )
      echo "Installing tools..."
      paru -S nmap metasploit postgresql gobuster whatweb exploitdb masscan john bloodhound bloodhound-python python-neo4j sliver-bin
      ;;
    * )
      echo "Skipping tools installation..."
      ;;
esac

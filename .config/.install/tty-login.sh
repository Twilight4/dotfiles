#!bin/bash

if [ $disman == 1 ]; then
echo -e "${GREEN}"
cat <<"EOF"
 _____ _______   __  _             _       
|_   _|_   _\ \ / / | | ___   __ _(_)_ __  
  | |   | |  \ V /  | |/ _ \ / _` | | '_ \ 
  | |   | |   | |   | | (_) | (_| | | | | |
  |_|   |_|   |_|   |_|\___/ \__, |_|_| |_|
                             |___/         
EOF
echo -e "${NONE}"
    while true; do
        read -p "Do you want to install the custom tty login issue (Yy/Nn): " yn
        case $yn in
            [Yy]* )
				echo "
             _____ _______   __  _             _       
            |_   _|_   _\ \ / / | | ___   __ _(_)_ __  
              | |   | |  \ V /  | |/ _ \ / _` | | '_ \ 
              | |   | |   | |   | | (_) | (_| | | | | |
              |_|   |_|   |_|   |_|\___/ \__, |_|_| |_|
                                        |___/           
            Today is \d \t @ \n
            --------------------------------------------------------------
            \r (\l)" | sudo tee /etc/issue > /dev/null
            break;;
            [Nn]* ) 
                echo "Setup tty login skipped."
            break;;
            * ) echo "Please answer yes or no.";;
        esac
    done
    echo ""
fi

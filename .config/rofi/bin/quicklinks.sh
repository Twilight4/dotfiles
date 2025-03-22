#!/bin/bash

# Theme Elements
list_col='2'
list_row='8'

# Options
option_1=" Google"
option_2=" Google (Incognito)"
option_3=" Proton Mail"
option_4=" Youtube"
option_5=" Github"
option_6=" Github Trending"
option_7="󰅟 MEGA"
option_8=" Open Shopping Websites"
option_9=" Amazon (US)"
option_10=" Amazon (PL)"
option_11="󰒚 Allegro"
option_12="󰒚 OLX"
option_13=" Helion"
option_22="󰁰 Bank"
option_23=" HackTricks CheatSheet"
option_25="󰥷 Image to Text"
option_31=" Google Maps"
option_34=" AD CheatSheet PDF"
option_35=" Digital Ocean"
option_36=" PayPal"
option_38=" 0bin"
option_39=" Tutanota Mail"
option_40="󱅷 Tmpfiles"
option_41=" Twitter"
option_42=" Facebook"
option_43=" Instagram"
option_44=" Discord"
option_45=" AD CheatSheet MindMap"
option_46=" AD Github CheatSheet"
option_47="󰰦 Temu"
option_48="󰄐 AliExpress"
option_49=" Vinted"
option_50=" Polregio"
option_51=" PKP Intercity"
option_52="󰃧 Jakdojade"
option_53=" Inwentury"
option_54=" AWS Management Console"
option_55="󰭹 DeepSeek AI"
option_56=" Docker Hub"
option_57="󱃾 Kubernetes Docs"
option_58="󱃾 Helm Hub"
option_59="󰉚 Uber Eats"
option_60=" Exam Pro Courses"
option_61=" AWS Docs"
option_62=" Flaticon Icons"
option_63="󱃾 Kubectl Cheat Sheet"
option_64="󱃾 Kubernetes Nginx Ingress Docs"
option_65=" Tinder"

# Rofi CMD
rofi_cmd() {
	rofi \
    -theme-str "listview {columns: $list_col; lines: $list_row;}" \
		-dmenu \
    -i \
    -replace \
		-markup-rows \
    -config ~/.config/rofi/themes/config-keybinds.rasi
    #-config ~/.config/rofi/themes/config-compact.rasi
}

# Function to get search query using Rofi
get_search_query() {
  echo -n | rofi -i -dmenu -p "Search Google:" -theme-str 'textbox-prompt-colon {str: " ";}' -config ~/.config/rofi/configs/config-prompt.rasi
}

# Pass variables to rofi dmenu
run_rofi() {
  echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5\n$option_6\n$option_7\n$option_8\n$option_9\n$option_10\n$option_11\n$option_12\n$option_13\n$option_22\n$option_23\n$option_25\n$option_31\n$option_34\n$option_35\n$option_36\n$option_38\n$option_39\n$option_40\n$option_41\n$option_42\n$option_43\n$option_44\n$option_45\n$option_46\n$option_47\n$option_48\n$option_49\n$option_50\n$option_51\n$option_52\n$option_53\n$option_54\n$option_55\n$option_56\n$option_57\n$option_58\n$option_59\n$option_60\n$option_61\n$option_62\n$option_63\n$option_64\n$option_65" | rofi_cmd
}

# Execute Command
run_cmd() {
  case "$1" in
    --opt1)
      query=$(get_search_query)
      if [ -z "$query" ]; then
        exit 0
      else
        xdg-open "https://www.google.com/search?q=$query" &
      fi
      ;;
    --opt2)
      query=$(get_search_query)
      if [ -z "$query" ]; then
        exit 0
      else
        brave --incognito --tor "https://www.google.com/search?q=$query" &
      fi
      ;;
    --opt3)
      xdg-open 'https://mail.proton.me/u/0/inbox' &
      ;;
    --opt4)
      query=$(get_search_query)
      if [ -z "$query" ]; then
        xdg-open 'https://www.youtube.com/' &
      else
        xdg-open "https://www.youtube.com/results?search_query=$query" &
      fi
      ;;
    --opt5)
      xdg-open 'https://www.github.com/' &
      ;;
    --opt6)
      xdg-open 'https://github.com/trending' &
      ;;
    --opt7)
      xdg-open 'https://mega.nz/' &
      ;;
    --opt8)
      query=$(get_search_query)
      if [ -z "$query" ]; then
        exit 0
      else
        xdg-open "https://www.amazon.com/s?k=$query" &
        xdg-open "https://www.amazon.pl/s?k=$query" &
        xdg-open "https://allegro.pl/listing?string=$query" &
        xdg-open "https://www.olx.pl/oferty/q-$query/" &
        xdg-open "https://www.google.com/search?q=$query" &
      fi
      ;;
    --opt9)
      query=$(get_search_query)
      if [ -z "$query" ]; then
        exit 0
      else
        xdg-open "https://www.amazon.com/s?k=$query" &
      fi
      ;;
    --opt10)
      query=$(get_search_query)
      if [ -z "$query" ]; then
        exit 0
      else
        xdg-open "https://www.amazon.pl/s?k=$query" &
      fi
      ;;
    --opt11)
      query=$(get_search_query)
      if [ -z "$query" ]; then
        exit 0
      else
        xdg-open "https://allegro.pl/listing?string=$query" &
      fi
      ;;
    --opt12)
      query=$(get_search_query)
      if [ -z "$query" ]; then
        exit 0
      else
        xdg-open "https://www.olx.pl/oferty/q-$query/" &
      fi
      ;;
    --opt13)
      xdg-open 'https://helion.pl/kategorie/ksiazki/hacking' &
      ;;
    --opt22)
      xdg-open 'https://www.pekao24.pl/pekao24/produkty' &
      ;;
    --opt23)
      xdg-open 'https://book.hacktricks.xyz' &
      ;;
    --opt25)
      xdg-open 'https://www.imagetotext.info/' &
      ;;
    --opt31)
      xdg-open 'https://www.google.com/maps' &
      ;;
    --opt34)
      xdg-open 'file:///home/twilight/documents/pdfs/active-directory-attacks.pdf' &
      ;;
    --opt35)
      xdg-open 'https://cloud.digitalocean.com/droplets?i=ff92a8' &
      ;;
    --opt36)
      xdg-open 'https://www.paypal.com/myaccount/summary' &
      ;;
    --opt38)
      xdg-open 'https://0bin.net/' &
      ;;
    --opt39)
      xdg-open 'https://app.tuta.com/mail/' &
      ;;
    --opt40)
      xdg-open 'https://tmpfiles.org/' &
      ;;
    --opt41)
      xdg-open 'https://x.com/' &
      ;;
    --opt42)
      xdg-open 'https://www.facebook.com/' &
      ;;
    --opt43)
      xdg-open 'https://www.instagram.com/' &
      ;;
    --opt44)
      xdg-open 'https://discord.com/channels/@me' &
      ;;
    --opt45)
      xdg-open 'https://orange-cyberdefense.github.io/ocd-mindmaps/img/pentest_ad_dark_2023_02.svg' &
      ;;
    --opt46)
      xdg-open 'https://github.com/S1ckB0y1337/Active-Directory-Exploitation-Cheat-Sheet' &
      ;;
    --opt47)
      xdg-open 'https://www.temu.com/pl' &
      ;;
    --opt48)
      xdg-open 'https://best.aliexpress.com/?gatewayAdapt=pol2usa&browser_redirect=true' &
      ;;
    --opt49)
      xdg-open 'https://www.vinted.pl/' &
      ;;
    --opt50)
      xdg-open 'https://bilety.polregio.pl/' &
      ;;
    --opt51)
      xdg-open 'https://ebilet.intercity.pl/' &
      ;;
    --opt52)
      xdg-open 'https://jakdojade.pl/' &
      ;;
    --opt53)
      xdg-open 'https://inwentury.pl/' &
      ;;
    --opt54)
      xdg-open 'https://console.aws.amazon.com/' &
      ;;
    --opt55)
      xdg-open 'https://chat.deepseek.com/' &
      ;;
    --opt56)
      xdg-open 'https://hub.docker.com/' &
      ;;
    --opt57)
      xdg-open 'https://kubernetes.io/docs/concepts/services-networking/' &
      ;;
    --opt58)
      xdg-open 'https://artifacthub.io/' &
      ;;
    --opt59)
      xdg-open 'https://www.ubereats.com' &
      ;;
    --opt60)
      xdg-open 'https://app.exampro.co/' &
      ;;
    --opt61)
      xdg-open 'https://docs.aws.amazon.com/' &
      ;;
    --opt62)
      xdg-open 'https://www.flaticon.com/search?word=do%20not%20disturb&color=gradient' &
      ;;
    --opt63)
      xdg-open 'https://kubernetes.io/docs/reference/kubectl/quick-reference/' &
      ;;
    --opt64)
      xdg-open 'https://kubernetes.github.io/ingress-nginx/deploy/#minikube' &
      ;;
    --opt65)
      xdg-open 'https://tinder.com/app/recs' &
      ;;
    *)
      ;;
  esac
}

# Actions
chosen="$(run_rofi)"
case "${chosen}" in
  $option_1)
    run_cmd --opt1
    ;;
  $option_2)
    run_cmd --opt2
    ;;
  $option_3)
    run_cmd --opt3
    ;;
  $option_4)
    run_cmd --opt4
    ;;
  $option_5)
    run_cmd --opt5
    ;;
  $option_6)
    run_cmd --opt6
    ;;
  $option_7)
    run_cmd --opt7
    ;;
  $option_8)
    run_cmd --opt8
    ;;
  $option_9)
    run_cmd --opt9
    ;;
  $option_10)
    run_cmd --opt10
    ;;
  $option_11)
    run_cmd --opt11
    ;;
  $option_12)
    run_cmd --opt12
    ;;
  $option_13)
    run_cmd --opt13
    ;;
  $option_22)
    run_cmd --opt22
    ;;
  $option_23)
    run_cmd --opt23
    ;;
  $option_25)
    run_cmd --opt25
    ;;
  $option_31)
    run_cmd --opt31
    ;;
  $option_34)
    run_cmd --opt34
    ;;
  $option_35)
    run_cmd --opt35
    ;;
  $option_36)
    run_cmd --opt36
    ;;
  $option_38)
    run_cmd --opt38
    ;;
  $option_39)
    run_cmd --opt39
    ;;
  $option_40)
    run_cmd --opt40
    ;;
  $option_41)
    run_cmd --opt41
    ;;
  $option_42)
    run_cmd --opt42
    ;;
  $option_43)
    run_cmd --opt43
    ;;
  $option_44)
    run_cmd --opt44
    ;;
  $option_45)
    run_cmd --opt45
    ;;
  $option_46)
    run_cmd --opt46
    ;;
  $option_47)
    run_cmd --opt47
    ;;
  $option_48)
    run_cmd --opt48
    ;;
  $option_49)
    run_cmd --opt49
    ;;
  $option_50)
    run_cmd --opt50
    ;;
  $option_51)
    run_cmd --opt51
    ;;
  $option_52)
    run_cmd --opt52
    ;;
  $option_53)
    run_cmd --opt53
    ;;
  $option_54)
    run_cmd --opt54
    ;;
  $option_55)
    run_cmd --opt55
    ;;
  $option_56)
    run_cmd --opt56
    ;;
  $option_57)
    run_cmd --opt57
    ;;
  $option_58)
    run_cmd --opt58
    ;;
  $option_59)
    run_cmd --opt59
    ;;
  $option_60)
    run_cmd --opt60
    ;;
  $option_61)
    run_cmd --opt61
    ;;
  $option_62)
    run_cmd --opt62
    ;;
  $option_63)
    run_cmd --opt63
    ;;
  $option_64)
    run_cmd --opt64
    ;;
  $option_65)
    run_cmd --opt65
    ;;
esac

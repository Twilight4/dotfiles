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
option_8=" Open Shopping Websites"
option_9=" Amazon (US)"
option_10=" Amazon (PL)"
option_11="󰒚 Allegro"
option_12="󰒚 OLX"
option_13=" Helion"
option_22="󰁰 Bank"
option_25="󰥷 Image to Text"
option_31=" Google Maps"
option_36=" PayPal"
option_38=" 0bin"
option_40="󱅷 Tmpfiles"
option_41=" Twitter"
option_42=" Facebook"
option_43=" Instagram"
option_44=" Discord"
option_47="󰰦 Temu"
option_48="󰄐 AliExpress"
option_49=" Vinted"
option_50=" Days free off work"
option_51=" Koleo"
option_52="󰃧 Jakdojade"
option_53=" Inwentury"
option_54=" AWS Management Console"
option_55="󰭹 DeepSeek AI"
option_56=" Docker Hub"
option_57="󱃾 Kubernetes Docs"
option_58="󱃾 Helm Hub"
option_59="󰉚 Glovo"
option_60=" Exam Pro Courses"
option_61=" AWS Docs"
option_62=" Flaticon Icons"
option_63="󱃾 Kubectl Cheat Sheet"
option_64="󱃾 Kubernetes Nginx Ingress Docs"
option_65=" Tinder"
option_66="󰃧 PEKA card"
option_67=" Github Actions Events"
option_68=" Github Actions Marketplace"
option_69=" Terraform Docs"
option_70=" Terraform Registry"
option_71=" Terraform Registry AWS Provider"
option_72=" Pracuj"
option_73=" MeetUp"
option_74=" Github Actions - Writing workflows"
option_75=" Dockerfile Docs"

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
  echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5\n$option_6\n$option_8\n$option_9\n$option_10\n$option_11\n$option_12\n$option_13\n$option_22\n$option_25\n$option_31\n$option_36\n$option_38\n$option_40\n$option_41\n$option_42\n$option_43\n$option_44\n\n$option_47\n$option_48\n$option_49\n$option_50\n$option_51\n$option_52\n$option_53\n$option_54\n$option_55\n$option_56\n$option_57\n$option_58\n$option_59\n$option_60\n$option_61\n$option_62\n$option_63\n$option_64\n$option_65\n$option_66\n$option_67\n$option_68\n$option_69\n$option_70\n$option_71\n$option_72\n$option_73\n$option_74\n$option_75" | rofi_cmd
}

# Execute Command
run_cmd() {
  case "$1" in
    --opt1)
      query=$(get_search_query)
      if [ -z "$query" ]; then
        exit 0
      else
        zen-browser -P 'Default (release)' "https://www.google.com/search?q=$query" &
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
      zen-browser -P 'Default (release)' 'https://mail.proton.me/u/0/inbox' &
      ;;
    --opt4)
      query=$(get_search_query)
      if [ -z "$query" ]; then
        zen-browser -P 'Default (release)' 'https://www.youtube.com/' &
      else
        zen-browser -P 'Default (release)' "https://www.youtube.com/results?search_query=$query" &
      fi
      ;;
    --opt5)
      zen-browser -P 'Default (release)' 'https://www.github.com/' &
      ;;
    --opt6)
      zen-browser -P 'Default (release)' 'https://github.com/trending' &
      ;;
    --opt7)
      zen-browser -P 'Default (release)' 'https://mega.nz/' &
      ;;
    --opt8)
      query=$(get_search_query)
      if [ -z "$query" ]; then
        exit 0
      else
        zen-browser -P 'Default (release)' "https://www.amazon.com/s?k=$query" &
        zen-browser -P 'Default (release)' "https://www.amazon.pl/s?k=$query" &
        zen-browser -P 'Default (release)' "https://allegro.pl/listing?string=$query" &
        zen-browser -P 'Default (release)' "https://www.olx.pl/oferty/q-$query/" &
        zen-browser -P 'Default (release)' "https://www.google.com/search?q=$query" &
        zen-browser -P 'Default (release)' "https://pl.aliexpress.com" &
        zen-browser -P 'Default (release)' "https://www.temu.com/pl" &
      fi
      ;;
    --opt9)
      query=$(get_search_query)
      if [ -z "$query" ]; then
        exit 0
      else
        zen-browser -P 'Default (release)' "https://www.amazon.com/s?k=$query" &
      fi
      ;;
    --opt10)
      query=$(get_search_query)
      if [ -z "$query" ]; then
        exit 0
      else
        zen-browser -P 'Default (release)' "https://www.amazon.pl/s?k=$query" &
      fi
      ;;
    --opt11)
      query=$(get_search_query)
      if [ -z "$query" ]; then
        exit 0
      else
        zen-browser -P 'Default (release)' "https://allegro.pl/listing?string=$query" &
      fi
      ;;
    --opt12)
      query=$(get_search_query)
      if [ -z "$query" ]; then
        exit 0
      else
        zen-browser -P 'Default (release)' "https://www.olx.pl/oferty/q-$query/" &
      fi
      ;;
    --opt13)
      zen-browser -P 'Default (release)' 'https://helion.pl/kategorie/ksiazki/hacking' &
      ;;
    --opt22)
      zen-browser -P 'Default (release)' 'https://www.pekao24.pl/pekao24/produkty' &
      ;;
    --opt25)
      zen-browser -P 'Default (release)' 'https://www.imagetotext.info/' &
      ;;
    --opt31)
      zen-browser -P 'Default (release)' 'https://www.google.com/maps' &
      ;;
    --opt35)
      zen-browser -P 'Default (release)' 'https://cloud.digitalocean.com/droplets?i=ff92a8' &
      ;;
    --opt36)
      zen-browser -P 'Default (release)' 'https://www.paypal.com/myaccount/summary' &
      ;;
    --opt38)
      zen-browser -P 'Default (release)' 'https://0bin.net/home/' &
      ;;
    --opt40)
      zen-browser -P 'Default (release)' 'https://tmpfiles.org/' &
      ;;
    --opt41)
      zen-browser -P 'Default (release)' 'https://x.com/' &
      ;;
    --opt42)
      zen-browser -P 'Default (release)' 'https://www.facebook.com/' &
      ;;
    --opt43)
      zen-browser -P 'Default (release)' 'https://www.instagram.com/' &
      ;;
    --opt44)
      zen-browser -P 'Default (release)' 'https://discord.com/channels/@me' &
      ;;
    --opt47)
      zen-browser -P 'Default (release)' 'https://www.temu.com/pl' &
      ;;
    --opt48)
      zen-browser -P 'Default (release)' 'https://best.aliexpress.com/?gatewayAdapt=pol2usa&browser_redirect=true' &
      ;;
    --opt49)
      zen-browser -P 'Default (release)' 'https://www.vinted.pl/' &
      ;;
    --opt50)
      zen-browser -P 'Default (release)' 'https://www.kalendarzswiat.pl/swieta/wolne_od_pracy/2025' &
      ;;
    --opt51)
      zen-browser -P 'Default (release)' 'https://koleo.pl/' &
      ;;
    --opt52)
      zen-browser -P 'Default (release)' 'https://jakdojade.pl/' &
      ;;
    --opt53)
      zen-browser -P 'Default (release)' 'https://inwentury.pl/' &
      ;;
    --opt54)
      zen-browser -P 'Default (release)' 'https://console.aws.amazon.com/' &
      ;;
    --opt55)
      zen-browser -P 'Default (release)' 'https://chat.deepseek.com/' &
      ;;
    --opt56)
      zen-browser -P 'Default (release)' 'https://hub.docker.com/' &
      ;;
    --opt57)
      zen-browser -P 'Default (release)' 'https://kubernetes.io/docs/concepts/services-networking/' &
      ;;
    --opt58)
      zen-browser -P 'Default (release)' 'https://artifacthub.io/' &
      ;;
    --opt59)
      zen-browser -P 'Default (release)' 'https://glovoapp.com/pl/pl' &
      ;;
    --opt60)
      zen-browser -P 'Default (release)' 'https://app.exampro.co/' &
      ;;
    --opt61)
      zen-browser -P 'Default (release)' 'https://docs.aws.amazon.com/' &
      ;;
    --opt62)
      zen-browser -P 'Default (release)' 'https://www.flaticon.com/search?word=do%20not%20disturb&color=gradient' &
      ;;
    --opt63)
      zen-browser -P 'Default (release)' 'https://kubernetes.io/docs/reference/kubectl/quick-reference/' &
      ;;
    --opt64)
      zen-browser -P 'Default (release)' 'https://kubernetes.github.io/ingress-nginx/deploy/#minikube' &
      ;;
    --opt65)
      zen-browser -P 'Default (release)' 'https://tinder.com/app/recs' &
      ;;
    --opt66)
      zen-browser -P 'Default (release)' 'https://www.peka.poznan.pl/km/account' &
      ;;
    --opt67)
      zen-browser -P 'Default (release)' 'https://docs.github.com/en/actions/reference/workflows-and-actions/events-that-trigger-workflows' &
      ;;
    --opt68)
      zen-browser -P 'Default (release)' 'https://github.com/marketplace' &
      ;;
    --opt69)
      zen-browser -P 'Default (release)' 'https://developer.hashicorp.com/terraform/tutorials/' &
      ;;
    --opt70)
      zen-browser -P 'Default (release)' 'https://registry.terraform.io/browse/providers' &
      ;;
    --opt71)
      zen-browser -P 'Default (release)' 'https://registry.terraform.io/providers/hashicorp/aws/latest/docs' &
      ;;
    --opt72)
      zen-browser -P 'Default (release)' 'https://www.pracuj.pl/' &
      ;;
    --opt73)
      zen-browser -P 'Default (release)' 'https://www.meetup.com/pl-PL/find/pl--poznan/' &
      ;;
    --opt74)
      zen-browser -P 'Default (release)' 'https://docs.github.com/actions/learn-github-actions' &
      ;;
    --opt75)
      zen-browser -P 'Default (release)' 'https://docs.github.com/actions/learn-github-actions' &
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
  $option_25)
    run_cmd --opt25
    ;;
  $option_31)
    run_cmd --opt31
    ;;
  $option_36)
    run_cmd --opt36
    ;;
  $option_38)
    run_cmd --opt38
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
  $option_66)
    run_cmd --opt66
    ;;
  $option_67)
    run_cmd --opt67
    ;;
  $option_68)
    run_cmd --opt68
    ;;
  $option_69)
    run_cmd --opt69
    ;;
  $option_70)
    run_cmd --opt70
    ;;
  $option_71)
    run_cmd --opt71
    ;;
  $option_72)
    run_cmd --opt72
    ;;
  $option_73)
    run_cmd --opt73
    ;;
  $option_74)
    run_cmd --opt74
    ;;
  $option_75)
    run_cmd --opt75
    ;;    
esac

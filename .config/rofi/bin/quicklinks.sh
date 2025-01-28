#!/bin/bash

# Theme Elements
list_col='1'
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
option_14=" HackTheBox Labs"
option_15=" HackTheBox Academy"
option_16=" TryHackMe"
option_17=" TCM Academy"
option_18=" OffSec"
option_19="󰚌 Root Me"
option_20=" PWNX"
option_21="󰖟 IppSec Search CheatSheet"
option_22="󰁰 Bank"
option_23=" HackTricks CheatSheet"
option_24=" PwnedLabs"
option_25="󰥷 Image to Text"
option_26="󱇱 HackTricks Cloud CheatSheet"
option_27=" Google Exploits"
option_28="󰬎 GTFOBins CheatSheet"
option_29=" RevShells CheatSheet"
option_30=" Crackstation"
option_31=" Google Maps"
option_32="󰰮 WADComs CheatSheet"
option_33="󰩃 BloodHound CheatSheet"
option_34=" AD CheatSheet PDF"
option_35=" Digital Ocean"
option_36=" PayPal"
option_37=" SharpCollection"
option_38=" 0bin"
option_39=" Tutanoda Mail"
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

# Rofi CMD
rofi_cmd() {
	rofi \
    -theme-str "listview {columns: $list_col; lines: $list_row;}" \
		-theme-str 'textbox-prompt-colon {str: " ";}' \
		-dmenu \
    -i \
    -replace \
		-markup-rows \
    -config ~/.config/rofi/configs/config-compact.rasi
}

# Function to get search query using Rofi
get_search_query() {
  echo -n | rofi -i -dmenu -p "Search Google:" -theme-str 'textbox-prompt-colon {str: " ";}' -config ~/.config/rofi/configs/config-prompt.rasi
}

# Pass variables to rofi dmenu
run_rofi() {
  echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5\n$option_6\n$option_7\n$option_8\n$option_9\n$option_10\n$option_11\n$option_12\n$option_13\n$option_14\n$option_15\n$option_16\n$option_17\n$option_18\n$option_19\n$option_20\n$option_21\n$option_22\n$option_23\n$option_24\n$option_25\n$option_26\n$option_27\n$option_28\n$option_29\n$option_30\n$option_31\n$option_32\n$option_33\n$option_34\n$option_35\n$option_36\n$option_37\n$option_38\n$option_39\n$option_40\n$option_41\n$option_42\n$option_43\n$option_44\n$option_45\n$option_46\n$option_47\n$option_48\n$option_49\n$option_50\n$option_51\n$option_52" | rofi_cmd
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
    --opt14)
      xdg-open 'https://app.hackthebox.com' &
      ;;
    --opt15)
      xdg-open 'https://academy.hackthebox.com/dashboard' &
      ;;
    --opt16)
      xdg-open 'https://tryhackme.com' &
      ;;
    --opt17)
      xdg-open 'https://academy.tcm-sec.com' &
      ;;
    --opt18)
      xdg-open 'https://www.offensive-security.com' &
      ;;
    --opt19)
      xdg-open 'https://www.root-me.org' &
      ;;
    --opt20)
      xdg-open 'https://www.pwnx.io' &
      ;;
    --opt21)
      xdg-open 'https://ippsec.rocks/?#' &
      ;;
    --opt22)
      xdg-open 'https://www.pekao24.pl/pekao24/produkty' &
      ;;
    --opt23)
      xdg-open 'https://book.hacktricks.xyz' &
      ;;
    --opt24)
      xdg-open 'https://pwnedlabs.io/dashboard' &
      ;;
    --opt25)
      xdg-open 'https://www.imagetotext.info/' &
      ;;
    --opt26)
      xdg-open 'https://cloud.hacktricks.xyz/' &
      ;;
    --opt27)
      query=$(get_search_query)
      if [ -z "$query" ]; then
        xdg-open 'https://www.google.com/search?q=site%3Awww.rapid7.com&sca_esv=37db28bfa134011b&sca_upv=1&ei=ux97ZvXCJ9m4wPAPzruUiAY&ved=0ahUKEwi1jNTHw_eGAxVZHBAIHc4dBWEQ4dUDCA8&uact=5&oq=site%3Awww.rapid7.com+&gs_lp=Egxnd3Mtd2l6LXNlcnAiFHNpdGU6d3d3LnJhcGlkNy5jb20gSN0jUPwPWPwPcAF4AJABAJgBVqABVqoBATG4AQPIAQD4AQGYAgCgAgCYAwCIBgGSBwCgBy0&sclient=gws-wiz-serp' &
        xdg-open 'https://www.google.com/search?q=site%3Awww.exploit-db.com&sca_esv=37db28bfa134011b&sca_upv=1&ei=TxN-ZpGfN4Ljxc8P2YGi8Ag&ved=0ahUKEwjRgriRlP2GAxWCcfEDHdmACI4Q4dUDCA8&uact=5&oq=site%3Awww.exploit-db.com&gs_lp=Egxnd3Mtd2l6LXNlcnAiF3NpdGU6d3d3LmV4cGxvaXQtZGIuY29tSLijAVC6JVijjgFwA3gAkAEAmAGCA6ABpQeqAQUyLTIuMbgBA8gBAPgBAfgBApgCAqACjQPCAgoQABiABBhGGP8BwgIFEAAYgATCAgcQABiABBgKwgIWEAAYgAQYRhj_ARiXBRiMBRjdBNgBAZgDAIgGAboGBggBEAEYE5IHBTEuMy0xoAf3Bg&sclient=gws-wiz-serp' &
      else
        xdg-open "https://www.google.com/search?q=site%3Awww.rapid7.com+$query&sca_esv=37db28bfa134011b&sca_upv=1&ei=ux97ZvXCJ9m4wPAPzruUiAY&ved=0ahUKEwi1jNTHw_eGAxVZHBAIHc4dBWEQ4dUDCA8&uact=5&oq=site%3Awww.rapid7.com+&gs_lp=Egxnd3Mtd2l6LXNlcnAiFHNpdGU6d3d3LnJhcGlkNy5jb20gSN0jUPwPWPwPcAF4AJABAJgBVqABVqoBATG4AQPIAQD4AQGYAgCgAgCYAwCIBgGSBwCgBy0&sclient=gws-wiz-serp" &
        xdg-open "https://www.google.com/search?q=site%3Awww.exploit-db.com+$query&sca_esv=37db28bfa134011b&sca_upv=1&ei=TxN-ZpGfN4Ljxc8P2YGi8Ag&ved=0ahUKEwjRgriRlP2GAxWCcfEDHdmACI4Q4dUDCA8&uact=5&oq=site%3Awww.exploit-db.com&gs_lp=Egxnd3Mtd2l6LXNlcnAiF3NpdGU6d3d3LmV4cGxvaXQtZGIuY29tSLijAVC6JVijjgFwA3gAkAEAmAGCA6ABpQeqAQUyLTIuMbgBA8gBAPgBAfgBApgCAqACjQPCAgoQABiABBhGGP8BwgIFEAAYgATCAgcQABiABBgKwgIWEAAYgAQYRhj_ARiXBRiMBRjdBNgBAZgDAIgGAboGBggBEAEYE5IHBTEuMy0xoAf3Bg&sclient=gws-wiz-serp" &
      fi
      ;;
    --opt28)
      xdg-open 'https://gtfobins.github.io/' &
      ;;
    --opt29)
      xdg-open 'https://www.revshells.com/' &
      ;;
    --opt30)
      xdg-open 'https://crackstation.net/' &
      ;;
    --opt31)
      xdg-open 'https://www.google.com/maps' &
      ;;
    --opt32)
      xdg-open 'https://www.google.com/maps' &
      ;;
    --opt33)
      xdg-open 'https://hausec.com/2019/09/09/bloodhound-cypher-cheatsheet/' &
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
    --opt37)
      xdg-open 'https://github.com/Flangvik/SharpCollection' &
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
  $option_14)
    run_cmd --opt14
    ;;
  $option_15)
    run_cmd --opt15
    ;;
  $option_16)
    run_cmd --opt16
    ;;
  $option_17)
    run_cmd --opt17
    ;;
  $option_18)
    run_cmd --opt18
    ;;
  $option_19)
    run_cmd --opt19
    ;;
  $option_20)
    run_cmd --opt20
    ;;
  $option_21)
    run_cmd --opt21
    ;;
  $option_22)
    run_cmd --opt22
    ;;
  $option_23)
    run_cmd --opt23
    ;;
  $option_24)
    run_cmd --opt24
    ;;
  $option_25)
    run_cmd --opt25
    ;;
  $option_26)
    run_cmd --opt26
    ;;
  $option_27)
    run_cmd --opt27
    ;;
  $option_28)
    run_cmd --opt28
    ;;
  $option_29)
    run_cmd --opt29
    ;;
  $option_30)
    run_cmd --opt30
    ;;
  $option_31)
    run_cmd --opt31
    ;;
  $option_32)
    run_cmd --opt32
    ;;
  $option_33)
    run_cmd --opt33
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
  $option_37)
    run_cmd --opt37
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
esac

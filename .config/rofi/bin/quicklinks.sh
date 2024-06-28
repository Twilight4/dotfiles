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
option_21="󰖟 IppSec Search"
option_22="󰁰 Bank"
option_23=" HackTricks"
option_24=" PwnedLabs"
option_25="󰥷 Image to Text"
option_26="󱇱 HackTricks Cloud"
option_27=" Google Exploits"
option_28="󰬎 GTFOBins"

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

7004dbcef0f854e0fb401875f26ebd00
# Pass variables to rofi dmenu
run_rofi() {
  echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5\n$option_6\n$option_7\n$option_8\n$option_9\n$option_10\n$option_11\n$option_12\n$option_13\n$option_14\n$option_15\n$option_16\n$option_17\n$option_18\n$option_19\n$option_20\n$option_21\n$option_22\n$option_23\n$option_24\n$option_25\n$option_26\n$option_27\n$option_28" | rofi_cmd
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
        brave-browser --incognito --tor "https://www.google.com/search?q=$query" &
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
esac

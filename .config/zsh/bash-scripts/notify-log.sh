#!/usr/bin/env bash

logfile=$1

declare -a MSGBUF
STATE=off
MSGTIME=

printbuf() {
  JOINED=$( echo "${MSGBUF[@]}" | sed 's/,$//' )
  printf "%s\n%s\n" "--- ${MSGTIME} ---" "${JOINED}"
}

procmsg() {
  if [[ "${1}" =~ member=Notify$ ]]; then
    STATE=on
    MSGTIME=$(date '+%Y-%m-%d %H:%M:%S')
    MSGBUF=()
  elif [[ "${1}" =~ member=NotificationClosed$ ]]; then
    STATE=off
    printbuf
  else
   if [[ "${STATE}" == "on" ]]; then
      if [[ "${1}" =~ ^string ]]; then
        case "${1}" in
          "string \"\"") ;;
          "string \"urgency\"") ;;
          "string \"sender-pid\"") ;;
          *)
            MSGBUF+=$( echo -n "${1}," )
          ;;
        esac
      fi
    fi
  fi
}

dbus-monitor "interface='org.freedesktop.Notifications'" | \
    while read -r line; do
      procmsg "$line" >> "$logfile"
    done

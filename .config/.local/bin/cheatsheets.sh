#!/bin/sh -e

pull() {
  notify-send -u low -t 4000 "Pulling cheatsheets..." 
  for d in `cheat -d | awk '{print $2}'`;
  do
      echo "Update $d"
      cd "$d"
      [ -d ".git" ] && git pull || :
  done

  echo
  echo "Finished update"
}

push() {
  notify-send -u low -t 4000 "Updating cheatsheets..." 
  for d in `cheat -d | grep -v "community" | awk '{print $2}'`;
  do
      cd "$d"
      if [ -d ".git" ]
      then
          echo "Push modifications $d"
          files=$(git ls-files -mo | tr '\n' ' ')
          git add -A && git commit -m "Edited files: $files" && git push || :
      else
          echo "$(pwd) is not a git managed folder"
          echo "First connect this to your personal git repository"
      fi
  done

  echo
  echo "Finished push operation"
  echo 'Done - Press enter to exit; read _"'
}


if [ "$1" = "pull" ]; then
  pull
elif [ "$1" = "push" ]; then
  push
else
  echo "Usage:
  # pull changes
  cheatsheets pull

  # push changes
  cheatsheets push"
fi
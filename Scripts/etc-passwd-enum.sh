#!/bin/bash

while getopts "h:m:l" arg; do
  case $arg in
    h)
      echo "Usage:"
      echo "  -m sh     enumerate shell binaries"
      echo "  -m home   enumerate home directories"
      echo "  -l        print collected list after enumeration"
      exit 0
      ;;
    m)
      mode=$OPTARG
      ;;
    l)
      list=true
      ;;
  esac
done

info_list=""

shell_enum() {
  while IFS=: read -r user _ _ _ _ _ shell; do
    echo "$user $shell"
    info_list+="$shell "
  done < /etc/passwd
}

home_enum() {
  while IFS=: read -r user _ _ _ _ home _; do
    echo "$user $home"
    info_list+="$home "
  done < /etc/passwd
}


case $mode in
  sh)   shell_enum ;;
  home) home_enum ;;
esac


if [[ -n "${list:-}" ]]; then
  echo
  echo "$info_list"
fi

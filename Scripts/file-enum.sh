
#!/bin/bash
while getopts "h:u:" arg; do
  case $arg in
    h)
      echo "usage" 
      ;;
    u)
      user=$OPTARG
      ;;
  esac
done

if [ -z "$user" ]; then user="$user"; fi

echo "${@}"

assign_values 


dirs=(/bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin /lib /lib64 /usr/lib /opt /boot /etc /$user /srv)

TMP="/tmp/non$user_files.$$"
rm -f "$TMP"

sudo find "${dirs[@]}" -xdev -type f ! -user $user -printf '%p|%u|%M|%TY-%Tm-%Td %TH:%TM:%TS\n' 2>/dev/null > "$TMP" || true

if [[ ! -s "$TMP" ]]; then
  echo "No non-$user-owned files found in the scanned locations."
  exit 0
fi

echo "$(wc -l < "$TMP") non $user owned files. (path | uid | perms | mtime):"
head -n 40 "$TMP" | sed 's/|/ | /g'
    
echo
echo "(UID : #files):"
awk -F'|' '{count[$2]++} END{for (u in count) printf "%s : %d\n", u, count[u]}' "$TMP" | sort -rn -k3

echo
echo "Files with SUID/SGID bits set (and not owned by $user):"

sudo find "${dirs[@]}" -xdev -type f ! -user $user \( -perm /4000 -o -perm /2000 \) -ls 2>/dev/null || echo "  (none found)"

echo 
echo 
echo

for entry in $(cat /etc/passwd); do

echo '$entry' | cut -d ":" -f1 | rev | cut -d'.' -f 1 | rev

done;

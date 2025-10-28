/bin/echo "ALL USER NAMES WITH A LOGIN"
/bin/cat /etc/passwd | /bin/grep -v "nologin" | /bin/awk -F: '{print $1}'

/bin/echo "ALL SUDO USERS"
users=$(/bin/cat /etc/group | /bin/grep sudo)
/bin/echo "$users"

/bin/echo "CURRENTLY LOGGED IN USERS"
/usr/bin/who

/bin/echo "LAST LOGGED IN USERS"
/usr/bin/last
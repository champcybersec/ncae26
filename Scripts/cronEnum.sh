#!/bin/bash

users=$(cat /etc/passwd | cut -d ":" -f1)
file="cron_audit.txt"

echo Users Cron Information >> $file
for user in $users ; 
  do 
    echo $user >> $file
    sudo crontab -u $user -l >> $file
  done

Echo System Cron Information >> $file
ls -l /etc/cron* >> $file

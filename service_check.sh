#!/bin/bash

# simple to start, going to run dpkg -V on every loaded service file
# as well as check that they have been installed by package manager
# just around 2 minute runtime on ryzen 5600
  
if [[ $# -lt 1 ]]; then
	echo Usage: ./servcheck [output_file]
	exit
fi
serv_conf=$(systemctl list-unit-files --all | grep service | grep running | grep -o '^[^ ]*')

final="./$1"
true_paths=""
echo $final

for act_serv in $serv_conf ;
do
	temp=$(dpkg -S ${act_serv%%' '*} 2>/dev/null)
	
	if [[ -n $temp ]]; then
		true_paths+="$temp"$'\n'
	else
		echo ${act_serv%%' '*} 'reason=NO PATH FOUND' >> $final
		echo ${act_serv%%' '*} NoPath
	fi
done

  

for package in $(echo $true_paths | grep -o '^[^:]*' | sort | uniq);
	do
		temp=$(dpkg -V $package 2>/dev/null; echo)
		if [[ -z $temp ]]; then
			e='mc^2'
		else
			echo VERIFY FAILED $package $'\n' OUTPUT: $temp 
			echo $package VerFailed >> $final
fi

done

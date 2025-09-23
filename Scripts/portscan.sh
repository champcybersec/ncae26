#!/bin/bash

echo "=== Scanning for open and listening ports ==="
echo

# Method 1: Using ss command (more modern)
echo "--- Using ss command ---"
if command -v ss > /dev/null 2>&1; then
    # Get listening TCP ports
    echo "TCP Listening Ports:"
    ss -tlne | grep LISTEN | while read line; do
        port=$(echo "$line" | awk '{print $4}' | sed 's/.*://')
        address=$(echo "$line" | awk '{print $4}' | sed 's/:[^:]*$//')
        process=$(echo "$line" | awk '{print $8}')
        procName=$(echo "$process" | sed 's|.*/||')
        echo "Port: $port (Address: $address) | Process Info: $process  |  SystemCtl Proc ID: $(systemctl show $procName | egrep "PID"  | egrep -Ev 'Control|Exec|Guess')"
        echo "LSOF Info: $(lsof -i :$port)"
    done
    echo
    
    # Get listening UDP ports
    echo "UDP Listening Ports:"
    ss -ulne | while read line; do
        if [[ "$line" == *":"* ]] && [[ "$line" != "Local Address:Port"* ]]; then
            port=$(echo "$line" | awk '{print $4}' | sed 's/.*://')
            address=$(echo "$line" | awk '{print $4}' | sed 's/:[^:]*$//')
            process=$(echo "$line" | awk '{print $8}')
            procName=$(echo "$process" | sed 's|.*/||')
        echo "Port: $port (Address: $address) | Process Info: $process  |  SystemCtl Proc ID: $(systemctl show $procName | egrep "PID"  | egrep -Ev 'Control|Exec|Guess')"
        echo "LSOF Info: $(lsof -i :$port)"
        fi
    done
    echo
else
    echo "ss command not available"
fi

echo "--- Using netstat command ---"
# Method 2: Using netstat command (fallback)
if command -v netstat > /dev/null 2>&1; then
    # Get listening TCP ports
    echo "TCP Listening Ports:"
    netstat -tln | grep LISTEN | while read line; do
        port=$(echo "$line" | awk '{print $4}' | sed 's/.*://')
        address=$(echo "$line" | awk '{print $4}' | sed 's/:[^:]*$//')
        process=$(echo "$line" | awk '{print $6}')
        procName=$(echo "$process" | sed 's|.*/||')
        echo "Port: $port (Address: $address) | Process Info: $process  |  SystemCtl Proc ID: $(systemctl show $procName | egrep "PID"  | egrep -Ev 'Control|Exec|Guess')"
        echo "LSOF Info: $(lsof -i :$port)"
    done
    echo
    
    # Get listening UDP ports  
    echo "UDP Listening Ports:"
    netstat -uln | while read line; do
        if [[ "$line" == *":"* ]] && [[ "$line" != "Proto"* ]] && [[ "$line" != "Active"* ]]; then
            port=$(echo "$line" | awk '{print $4}' | sed 's/.*://')
            address=$(echo "$line" | awk '{print $4}' | sed 's/:[^:]*$//')
            process=$(echo "$line" | awk '{print $6}')
            procName=$(echo "$process" | sed 's|.*/||')
            echo "Port: $port (Address: $address) | Process Info: $process  |  SystemCtl Proc ID: $(systemctl show $procName | egrep "PID"  | egrep -Ev 'Control|Exec|Guess')"
            echo "LSOF Info: $(lsof -i :$port)"
        fi
    done
    echo
else
    echo "netstat command not available"
fi

echo "=== Port scan complete ==="
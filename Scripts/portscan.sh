#!/bin/bash

dos2unix $0

echo "=== Scanning for open and listening ports ==="
echo

# Method 1: Using ss command (more modern)
echo "--- Using ss command ---"
if command -v ss > /dev/null 2>&1; then
    # Get listening TCP ports
    echo "TCP Listening Ports:"
    ss -tln | grep LISTEN | while read line; do
        port=$(echo "$line" | awk '{print $4}' | sed 's/.*://')
        address=$(echo "$line" | awk '{print $4}' | sed 's/:[^:]*$//')
        echo "  Port: $port (Address: $address)"
    done
    echo
    
    # Get listening UDP ports
    echo "UDP Listening Ports:"
    ss -uln | while read line; do
        if [[ "$line" == *":"* ]] && [[ "$line" != "Local Address:Port"* ]]; then
            port=$(echo "$line" | awk '{print $4}' | sed 's/.*://')
            address=$(echo "$line" | awk '{print $4}' | sed 's/:[^:]*$//')
            echo "  Port: $port (Address: $address)"
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
        echo "  Port: $port (Address: $address)"
    done
    echo
    
    # Get listening UDP ports  
    echo "UDP Listening Ports:"
    netstat -uln | while read line; do
        if [[ "$line" == *":"* ]] && [[ "$line" != "Proto"* ]] && [[ "$line" != "Active"* ]]; then
            port=$(echo "$line" | awk '{print $4}' | sed 's/.*://')
            address=$(echo "$line" | awk '{print $4}' | sed 's/:[^:]*$//')
            echo "  Port: $port (Address: $address)"
        fi
    done
    echo
else
    echo "netstat command not available"
fi

# Method 3: Alternative approach using /proc/net (Linux only)
echo "--- Using /proc/net files (Linux only) ---"
if [ -f "/proc/net/tcp" ]; then
    echo "TCP Listening Ports from /proc/net/tcp:"
    awk '$4=="0A" {print $2}' /proc/net/tcp | while read addr_port; do
        port_hex=$(echo "$addr_port" | cut -d':' -f2)
        port_dec=$((0x$port_hex))
        echo "  Port: $port_dec"
    done
    echo
fi

if [ -f "/proc/net/udp" ]; then
    echo "UDP Listening Ports from /proc/net/udp:"
    awk '$4=="07" {print $2}' /proc/net/udp | while read addr_port; do
        port_hex=$(echo "$addr_port" | cut -d':' -f2)
        port_dec=$((0x$port_hex))
        echo "  Port: $port_dec"
    done
    echo
fi

echo "=== Port scan complete ==="
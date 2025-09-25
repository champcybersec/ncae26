#!/bin/bash

echo -e "${BLUE}=== Scanning for open and listening ports ===${NC}"
echo

RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Method 1: Using ss command (more modern)
if command -v ss > /dev/null 2>&1; then
    # Get listening TCP ports
    echo -e "${BLUE}Basic Results${NC}"
    ss -tulnpe

    echo

    echo -e "${BLUE}--- Detailed Results with LSOF ---${NC}"
    if ! command -v lsof > /dev/null 2>&1; then
        echo -e "${RED}LSOF command not found. Please install lsof for detailed results.${NC}"
        exit 1
    fi

    echo -e "${BLUE}TCP Listening Ports:${NC}"
    ss -tlne | grep LISTEN | while read line; do
        port=$(echo "$line" | awk '{print $4}' | sed 's/.*://')
        echo "Port: $port"
        echo "LSOF PID: $(lsof -ti :$port)"
        echo
    done
    echo

   echo -e "${BLUE}UDP Listening Ports:${NC}"
   ss -ulne | while read line; do
        port=$(echo "$line" | awk '{print $4}' | sed 's/.*://')
        echo "Port: $port"

           if ! lsof -ti :"$port" > /dev/null 2>&1; then
               echo -e "${RED}No process found using port $port${NC}"
           else
               echo "LSOF PID: $(lsof -ti :$port)"
           fi           
           echo   
   done
    echo
fi
#!/bin/bash

IFS=$'\n'
TZ='Asia/Tehran'; export TZ # the timezone

green='\033[0;32m'
yellow='\033[0;33m'
clean='\033[0m'

ports=$(cat ./ports)
number=1

if [ ! -d "./reports" ]; then
    mkdir "./reports"
fi

for port in $ports; do
        sessions=$(ss -np | grep ":$port ")

        if [ ! -z "$sessions" ]; then
                echo -e "$yellow--- $port $clean"
                for session in $sessions; do
                        ip=$(echo $session | awk '{print $6}')
                        sid=$(echo $session | awk '{split($7,a,","); print a[2]}' | sed 's/pid=//g')
                        mid=$(echo $session | awk '{split($7,a,","); print a[5]}' | sed 's/pid=//g')

                        if [ -n "$sid" ] && [ "$sid" != " " ] && [ "$sid" != "" ]; then
                                owner=$(ps -p $sid -o user=)
			else
				owner="unknown"
                        fi

                        printf "$green%02d. $clean" $number
                        echo -e "$owner (P=$sid) $yellow-->$clean $ip (P=$mid)"
                        number=$((number + 1))

                        echo [$(date)] $ip >> ./reports/$owner
                done
        fi
done
#!/bin/bash

# Date:                 22/01/2017
# Author:               Long Chen
# Description:          A script to send MongoDB stats to zabbix server by using zabbix sender
# Requires:             Zabbix Sender, zabbix-mongodb.py
host=`hostname awk -F '.' '{print $1}'`
hostname=`hostname`
get_MongoDB_metrics(){
python /usr/local/bin/zabbix-mongodb.py $hostname
}

# Send the results to zabbix server by using zabbix sender
result=$(get_MongoDB_metrics | /usr/bin/zabbix_sender -s "$host" -c /etc/zabbix/zabbix_agentd.conf -i - 2>&1)
response=$(echo "$result" | awk -F ';' '$1 ~ /^info/ && match($1,/[0-9].*$/) {sum+=substr($1,RSTART,RLENGTH)} END {print sum}')
if [ -n "$response" ]; then
        echo "$response"
else
        echo "$result"
fi

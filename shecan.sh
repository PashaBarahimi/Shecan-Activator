#!/bin/bash

# This script is used the change the dns server temporarily to shecan dns servers using the command "enable"
# The mentioned servers are:
# 178.22.122.100
# 185.51.200.2

# Also this script is used to change the dns server back to the original one by using the command "disable"

dns_string='nameserver 178.22.122.100 185.51.200.2'
shecan_comment='# shecan dns server'

function isShecanDnsSet() {
    if grep -q "^$dns_string" /etc/resolv.conf; then
        return 0
    else
        return 1
    fi
}

function enableShecanDns() {
    if isShecanDnsSet; then
        echo 'Shecan dns is already enabled!'
    else
        dnsLineNum=$(grep -n "^nameserver" /etc/resolv.conf | cut -d: -f1)
        if [ -z "$dnsLineNum" ]; then
            echo "$shecan_comment" >> /etc/resolv.conf
            if [ $? -eq 0 ]; then return 1; fi
            echo "$dns_string" >> /etc/resolv.conf
        else
            sed s/"^nameserver"/"# nameserver"/g /etc/resolv.conf > /tmp/resolv.conf
            sed -i "${dnsLineNum}i\\${dns_string}" /tmp/resolv.conf
            sed "${dnsLineNum}i\\${shecan_comment}" /tmp/resolv.conf > /etc/resolv.conf
            if [ $? -ne 0 ]; then return 1; fi
            rm /tmp/resolv.conf
        fi
        echo 'Shecan dns is enabled successfully'
    fi
    return 0
}

function disableShecanDns() {
    if isShecanDnsSet; then
        sed  /"$shecan_comment"/d /etc/resolv.conf > /tmp/resolv.conf
        sed -i /"$dns_string"/d /tmp/resolv.conf
        sed s/"^# nameserver"/"nameserver"/g /tmp/resolv.conf > /etc/resolv.conf
        if [ $? -ne 0 ]; then return 1; fi
        rm /tmp/resolv.conf
        echo 'Shecan dns is disabled successfully'
    else
        echo 'Shecan dns is already disabled!'
    fi
    return 0
}

if [ $(id -u) -ne 0 ]; then
    echo 'This script must be run as root'
    exit 1
fi

if [ $# -eq 0 ]; then
    echo 'No arguments provided'
    echo 'Usage: shecan.sh enable|disable'
    exit 1
fi

command=$1
if [ $command == 'enable' ]; then
    enableShecanDns
elif [ $command == 'disable' ]; then
    disableShecanDns
else
    echo 'Invalid argument'
    echo 'Usage: shecan.sh enable|disable'
    exit 1
fi

exit $?

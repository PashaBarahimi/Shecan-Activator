#!/bin/bash

# This script is used the change the dns server temporarily to shecan dns servers using the command "enable"
# The mentioned servers are:
# 178.22.122.100
# 185.51.200.2

# Also this script is used to change the dns server back to the original one by using the command "disable"

dns1='178.22.122.100'
dns2='185.51.200.2'
shecan_comment='# shecan dns server'

function isShecanDnsSet() {
    grep -q -e "^nameserver ${dns1}" -e "^nameserver ${dns2}" /etc/resolv.conf
    return $?
}

function enableShecanDns() {
    if isShecanDnsSet; then
        echo 'Shecan dns is already enabled!'
    else
        cp /etc/resolv.conf /etc/resolv.conf.bak
        dnsLineNum=$(grep -n "^nameserver" /etc/resolv.conf | cut -d: -f1 | head -n 1)
        if [ -z "$dnsLineNum" ]; then
            echo "$shecan_comment" >> /etc/resolv.conf || return 1
            echo "nameserver $dns1" >> /etc/resolv.conf || return 1
            echo "nameserver $dns2" >> /etc/resolv.conf || return 1
        else
            sed s/"^nameserver"/"# nameserver"/g /etc/resolv.conf > /tmp/resolv.conf || return 1
            sed -i "${dnsLineNum}i\\nameserver ${dns2}" /tmp/resolv.conf || return 1
            sed -i "${dnsLineNum}i\\nameserver ${dns1}" /tmp/resolv.conf || return 1
            sed "${dnsLineNum}i\\${shecan_comment}" /tmp/resolv.conf > /etc/resolv.conf || return 1
            rm /tmp/resolv.conf
        fi
        echo 'Shecan dns is enabled successfully'
    fi
    return 0
}

function disableShecanDns() {
    if isShecanDnsSet; then
        cp /etc/resolv.conf /etc/resolv.conf.bak
        sed  /"$shecan_comment"/d /etc/resolv.conf > /tmp/resolv.conf || return 1
        sed -i /"nameserver ${dns1}"/d /tmp/resolv.conf || return 1
        sed -i /"nameserver ${dns2}"/d /tmp/resolv.conf || return 1
        sed s/"^# nameserver"/"nameserver"/g /tmp/resolv.conf > /etc/resolv.conf || return 1
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

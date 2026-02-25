#!/bin/bash

# gets the current logged in user
u=$(whoami)

# get the machine name
h=$(hostname)

# get current date and time in readable format
dt=$(date "+%Y-%m-%d %H:%M:%S")

# get the OS type
os=$(uname -s)

# get the folder we are currently in
dir=$(pwd)

# get the home folder path
hdir=$HOME

# count how many users are logged in right now
users=$(who | wc -l)

# get how long the system has been running
up=$(uptime)

#prints  everything 

echo "Username     : $u"
echo "Hostname     : $h"
echo "Date & Time  : $dt"
echo "OS           : $os"
echo "Current Dir  : $dir"
echo "Home Dir     : $hdir"
echo "Users Online : $users"
echo "Uptime       : $up"

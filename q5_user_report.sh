#!/bin/bash

echo " USER STATISTICS "

# count users from passwd file
echo "Total Users: $(wc -l < /etc/passwd)"
echo "System Users (UID < 1000): $(awk -F: '$3 < 1000' /etc/passwd | wc -l)"
echo "Regular Users (UID >= 1000): $(awk -F: '$3 >= 1000 && $3 < 65534' /etc/passwd | wc -l)"
echo "Currently Logged In: $(who | awk '{print $1}' | sort -u | wc -l)"

echo ""
echo "REGULAR USER DETAILS"
printf "%-15s %-8s %-25s %-15s\n" "Username" "UID" "Home Directory" "Shell"
printf "%-15s %-8s %-25s %-15s\n" "--------" "---" "--------------" "-----"

# get regular user details from passwd
awk -F: '$3 >= 1000 && $3 < 65534 {printf "%-15s %-8s %-25s %-15s\n", $1, $3, $6, $7}' /etc/passwd

echo ""
echo "=== GROUP INFORMATION ==="

# list groups and count their members
while IFS=: read -r gname x gid members; do
if [ -z "$members" ]; then count=0
else count=$(echo "$members" | tr ',' '\n' | wc -l)
fi
echo "$gname - $count members"
done < /etc/group | head -15

echo ""
echo "SECURITY ALERTS"

# users with uid 0 have root access
echo "Users with UID 0:"
awk -F: '$3 == 0 {print "  - "$1}' /etc/passwd

# check for users without passwords
echo ""
if [ -r /etc/shadow ]; then
echo "Users without passwords:"
found=$(awk -F: '$2 == "" || $2 == "!" {print "  - "$1}' /etc/shadow)
if [ -z "$found" ]; then echo "  all good"
else echo "$found"
fi
else
echo "run with sudo to check passwords"
fi

# users who never logged in
echo ""
echo "Users never logged in:"
lastlog 2>/dev/null | awk 'NR>1 && /Never/ {print "  - "$1}'

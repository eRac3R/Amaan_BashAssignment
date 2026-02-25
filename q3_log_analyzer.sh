#!/bin/bash

# check if user gave a filename
if [ $# -eq 0 ]; then
echo "usage: ./q3_log_analyzer.sh <logfile>"
exit 1
fi

f=$1

# check if the file actually exists
if [ ! -f "$f" ]; then
echo "file not found: $f"
exit 1
fi

# check if file is empty
if [ ! -s "$f" ]; then
echo "file is empty"
exit 1
fi

echo ""
echo "LOG FILE ANALYSIS"
echo "Log File: $f"
echo ""

# count total lines in the file
total=$(wc -l < "$f")
echo "Total Entries: $total"
echo ""

# get unique IPs from column 1
echo "Unique IP Addresses: $(awk '{print $1}' "$f" | sort | uniq | wc -l)"
awk '{print $1}' "$f" | sort | uniq | while read ip; do
echo "  - $ip"
done
echo ""

# count each status code
echo "Status Code Summary:"
awk '{print $NF}' "$f" | sort | uniq -c | while read count code; do
echo "  $code: $count requests"
done
echo ""

# show top 3 IPs with most requests
echo "Top 3 IP Addresses:"
awk '{print $1}' "$f" | sort | uniq -c | sort -rn | head -3 | nl | while read num count ip; do
echo "  $num. $ip - $count requests"
done

#!/usr/bin/env python3
# arp_scanner.py

import subprocess, platform, re, sys

def get_arp():
    try:
        cmd = ["arp", "-a"] if platform.system() == "Windows" else ["arp", "-n"]
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=10)
        return result.stdout
    except:
        try:
            result = subprocess.run(["ip", "neigh"], capture_output=True, text=True)
            return result.stdout
        except Exception as e:
            print(f"Error: {e}")
            return ""

def parse_arp(raw):
    entries = []
    pattern = re.compile(
        r"(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}).*?([0-9a-f]{2}[:\-][0-9a-f]{2}[:\-][0-9a-f]{2}[:\-][0-9a-f]{2}[:\-][0-9a-f]{2}[:\-][0-9a-f]{2})",
        re.IGNORECASE
    )
    for line in raw.splitlines():
        m = pattern.search(line)
        if m:
            entries.append((m.group(1), m.group(2).upper()))
    return entries

def main():
    print("ARP Scanner")
    print("Only use on networks you own or have permission to scan.\n")

    raw = get_arp()
    if not raw:
        print("Could not retrieve ARP table. Try running with sudo.")
        sys.exit(1)

    entries = parse_arp(raw)
    if not entries:
        print("No entries found.")
        sys.exit(0)

    print(f"{'IP Address':<20} {'MAC Address'}")
    print("-" * 40)
    for ip, mac in entries:
        print(f"{ip:<20} {mac}")
    print("-" * 40)
    print(f"Total: {len(entries)} entries")

if __name__ == "__main__":
    main()

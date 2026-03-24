#!/usr/bin/env python3
# nmap_scanner.py
# This script acts as a simple frontend for nmap, letting the user
# pick a scan type without having to remember nmap flags every time.

import subprocess
import sys
import shutil

# before doing anything, check if nmap is actually installed on the system
# no point running the rest of the script if the tool isn't there
def check_nmap():
    if not shutil.which("nmap"):
        print("Nmap not installed.")
        print("Kali: sudo apt install nmap")
        sys.exit(1)

# runs the actual nmap command and prints whatever it returns
# using subprocess here so we can call nmap like we would from the terminal
def scan(target, flags, label):
    cmd = ["nmap"] + flags + [target]
    print(f"\n{label} on {target}")
    print(f"Command: {' '.join(cmd)}")
    print("-" * 50)
    try:
        # timeout set to 120s because some scans (especially full ones) take a while
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=120)
        print(result.stdout)
        if result.stderr:
            print(result.stderr)
    except subprocess.TimeoutExpired:
        # if it takes too long, just bail out cleanly
        print("Scan timed out.")
    except Exception as e:
        print(f"Error: {e}")

def main():
    print("Nmap Scanner")
    print("Only scan networks you own or have permission to scan.\n")

    check_nmap()

    # get the target from the user — can be an IP, hostname, or a range like 192.168.1.0/24
    target = input("Enter target IP / hostname / range: ").strip()
    if not target:
        print("No target entered.")
        sys.exit(1)

    # show the scan options — kept it simple so it's easy to use
    print("\n1. Host Discovery (-sn)")
    print("2. Port Scan (1-1000)")
    print("3. Custom Port Scan")
    print("4. Service Detection (-sV)")
    print("5. OS Detection (-O) [needs sudo]")
    print("6. Full Scan (-A -T4)")

    choice = input("\nChoice [1-6]: ").strip()

    # map the user's choice to the right nmap flags
    if choice == "1":
        # -sn means just ping scan, no port scanning
        scan(target, ["-sn"], "Host Discovery")
    elif choice == "2":
        # scan common ports and only show ones that are open
        scan(target, ["-p", "1-1000", "--open"], "Port Scan")
    elif choice == "3":
        # let the user specify exactly which ports they care about
        ports = input("Enter ports (e.g. 22,80,443): ").strip()
        scan(target, ["-p", ports], f"Custom Port Scan ({ports})")
    elif choice == "4":
        # -sV tries to figure out what software is running on each open port
        scan(target, ["-sV"], "Service Detection")
    elif choice == "5":
        # OS detection needs raw socket access, so sudo is required
        scan(target, ["-O"], "OS Detection")
    elif choice == "6":
        # -A enables OS detection, version detection, scripts and traceroute
        # -T4 speeds things up a bit — T5 is faster but less accurate
        scan(target, ["-A", "-T4"], "Full Scan")
    else:
        print("Invalid choice.")
        sys.exit(1)

if __name__ == "__main__":
    main()

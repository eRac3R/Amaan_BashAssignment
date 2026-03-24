#!/usr/bin/env python3
# ping_scanner.py 

import subprocess, platform, re, sys

def ping_host(host):
    cmd = ["ping", "-n", "1", host] if platform.system() == "Windows" else ["ping", "-c", "1", host]
    try:
        out = subprocess.run(cmd, capture_output=True, text=True, timeout=5)
        match = re.search(r"time[=<]([\d.]+)\s*ms", out.stdout, re.IGNORECASE)
        if out.returncode == 0:
            return True, float(match.group(1)) if match else None
        return False, None
    except:
        return False, None

def main():
    print("Ping Scanner")
    print("Only scan networks you own or have permission to scan.\n")
    print("1. Single host")
    print("2. Multiple hosts (comma separated)")
    choice = input("Choice: ").strip()

    if choice == "1":
        host = input("Enter IP or hostname: ").strip()
        alive, rtt = ping_host(host)
        if alive:
            print(f"{host} is UP, RTT: {rtt:.2f}ms" if rtt else f"{host} is UP")
        else:
            print(f"{host} is DOWN or unreachable")

    elif choice == "2":
        hosts = input("Enter IPs (comma separated): ").strip().split(",")
        for host in hosts:
            host = host.strip()
            alive, rtt = ping_host(host)
            if alive:
                print(f"{host} is UP, RTT: {rtt:.2f}ms" if rtt else f"{host} is UP")
            else:
                print(f"{host} is DOWN")
    else:
        print("Invalid choice")
        sys.exit(1)

if __name__ == "__main__":
    main()

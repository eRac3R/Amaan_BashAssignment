# Network Scanning Automation

Python-based tools for network reconnaissance using Ping, ARP, and Nmap.

## Tools

- `ping_scanner.py` - Checks if a host is reachable and shows response time
- `arp_scanner.py` - Reads the ARP table and displays IP to MAC mappings
- `nmap_scanner.py` - Scans a target for open ports and services using Nmap

## Requirements

- Python 3.6+
- Nmap installed (`sudo apt install nmap`)

## How to Run

```bash
python3 ping_scanner.py
python3 arp_scanner.py
python3 nmap_scanner.py
```

## Notes

- Only scan networks you own or have permission to scan
- OS detection requires sudo
- Tested on Kali Linux

---
title: WireGuard Setup
date: 2025-03-14
description: WireGuard Setup Instructions
---

I spent some time figuring out how WireGuard works and found the guidelines, including the official ones, to be rather complex. So, I'm jotting down my learnings here.

### Steps to Set Up WireGuard

1. Install the package
2. Add a virtual network interface
3. Create key pairs and configuration files
4. Update kernel configuration
5. Configure systemctl for auto start

#### 1. Install the Package

First, install the WireGuard package by running:
```sh
apt install wireguard
```

#### 2. Enable IP Forwarding

Uncomment `net.ipv4.ip_forward=1` in `/etc/sysctl.conf` to allow IP forwarding. Then, apply the changes and confirm:
```sh
sysctl -p
cat /proc/sys/net/ipv4/ip_forward
```

#### 3. Add the Virtual Interface

Add the virtual interface and assign a private IP address range:
```sh
ip link add dev wg0 type wireguard
ip address add dev wg0 192.168.2.1/24
```

#### 4. Generate Key Pairs

Generate the key pairs. You'll need to paste the plain text, not the file path, later on:
```sh
wg genkey | tee server-privatekey | wg pubkey > server-publickey
wg genkey | tee client-privatekey | wg pubkey > client-publickey
```

#### 5. Create Server Configuration

Create `/etc/wireguard/wg0.conf` for the server:
```ini
[Interface]
Address = 192.168.2.1/24
ListenPort = 33333
PrivateKey = <paste the content of server-privatekey here>
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT
PostUp = iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT
PostDown = iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

[Peer]
PublicKey = <paste the content of client-publickey here>
AllowedIPs = 192.168.2.2/32
```
Update `eth0` to the internal connected interface if different.

#### 6. Test the Server

Test run the server:
```sh
wg-quick up wg0
wg-quick down wg0
```

#### 7. Enable Auto Start with systemctl

If it works fine, hand over control to systemctl:
```sh
systemctl start wg-quick@wg0
systemctl enable wg-quick@wg0
```
Check the status:
```sh
journalctl -xeu wg-quick@wg0.service
```

#### 8. Create Client Configuration

Create `client.conf` for the client:
```ini
[Interface]
DNS = 1.1.1.1
Address = 192.168.2.2/24
ListenPort = 33333
PrivateKey = <paste the content of client-privatekey here>

[Peer]
PublicKey = <paste the content of server-publickey here>
Endpoint = <server public IP here>:33333
```

#### 9. Generate QR Code (Optional)

Optionally, create a QR code from `client.conf` for easy setup. Install `qrencode`:
```sh
apt install qrencode
```
Then generate the QR code:
```sh
qrencode -t ansiutf8 -r "client.conf"
```


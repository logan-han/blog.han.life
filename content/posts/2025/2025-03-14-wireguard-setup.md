---
title: WireGuard Setup
date: 2025-03-14
description: WireGuard Setup Instruction.
---
I had to spend some time to figure out how this works and found the guidelines are rather uneasy, including the official one.

So i'm jotting down some learnings here.

Essentially it needs to cover a few things:
1. Install the package
2. Create two key pairs and config files
3. Kernel config update
4. Deal with systemctl for auto start

First, install the package by running `apt insatll wireguard`.

Then uncomment `net.ipv4.ip_forward=1` from `/etc/sysctl.conf` to allow IP forward.

Run `sysctl -p to apply` then `cat /proc/sys/net/ipv4/ip_forward` to confirm.

Add the virtual interface and assign a private IP address range:
```
ip link add dev wg0 type wireguard
ip address add dev wg0 192.168.2.1/24
```

Generate the key pairs - you need to paste the plain text not the file path later on:
```
wg genkey | tee server-privatekey | wg pubkey > server-publickey
wg genkey | tee client-privatekey | wg pubkey > client-publickey
```

Create `/etc/wireguard/wg0.conf` for the server like below:
```
[Interface]
Address = 192.168.2.1/24
ListenPort = 33333
PrivateKey = <paste the content of server-privatekey here>
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT
PostUp = iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT
PostDown = iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE**

[Peer]
PublicKey = <paste the content of client-publickey here>
AllowedIPs = 192.168.2.2/32
```
Update `eth0` to the internal connected interface if different. 

Test run the server:
```
wg-quick up wg0
wg-quick down wg0
```

If it works fine, hand over the control to systemctl:
```
systemctl start wg-quick@wg0
systemctl enable wg-quick@wg0
```
Run `journalctl -xeu wg-quick@wg0.service` to check the status.

Now create `client.conf` for the client configuration:
```
[Interface]
DNS = 1.1.1.1
Address = 192.168.2.2/24
ListenPort = 33333
PrivateKey = <paste the content of client-priavtekey here>

[Peer]
PublicKey = <paste the content of server-publickey here>
Endpoint = <server public IP here>:33333
```

Optionally, you can create a QR code from client.conf for easy setup.

Install `qrencode` by running brew or apt. 

then run `qrencode -t ansiutf8 -r "client.conf"` to generate the QR code.

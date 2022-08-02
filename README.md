# Shecan Activator

### What the hell is Shecan?

Iranian users are suffering from internal censorship and domestic sanctions. Shecan is a DNS server that can be used to bypass the sanctions. Well, it isn't helpful for bypassing the internal censorship :)

### How to use Shecan?

It is not that hard, you simply need to add Shecan dns servers to your system. The server IPs can be found in [Shecan](https://shecan.ir/) website.

### What does this script do?

Actually, I didn't want Shecan to be enabled permanently, so I made this script. It is a simple script that enables Shecan on your system. It comments the DNS servers in your `/etc/resolv.conf` file and replaces them with Shecan servers.  
Also, it can be used to disable Shecan. This is simply done by removing the Shecan servers from the `/etc/resolv.conf` file and uncommenting the original servers.  
It is also notable that the `/etc/resolv.conf` file is overwritten every time your network is changed. So, you may need to run this script again to enable Shecan.

### How to use this script?

First, the script needs to be run as root. The following commands should be used to run the script:

```bash
sudo ./shecan.sh enable        # to enable Shecan
sudo ./shecan.sh disable       # to disable Shecan
```

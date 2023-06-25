# Network Manager

## Connect Hidden Wifi

```bash
nmcli device wifi rescan ssid $SSID
sudo nmcli device wifi connect $SSID password $PASSWORD hidden yes
```

## Configure Static IP

```bash
nmcli connection modify $FIACE ipv4.addresses $ADDR ipv4.gateway $GATEWAY ipv4.method manual 
```

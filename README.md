# maintain_wifi

Script to restore WiFi when host drops it.

## 2025-08-22 Motivation

Too many Raspberry Pi Zeroes (and Zero W) just drop off WiFi LAN w/out actually crashing or re-establishing the connection once lost. One morning I found four hosts that had all dropped from the network at about 0030. Some external event have caused this. There was no evicence of a power interruption so it must have been something with the AP or possibly RF interference. It's tiresome to need to go around and power cycle a bunch of headless devices when they drop. At this instant four are AWOL. Before restarting the AP, nearly all (including TP-Link Kasa devices) were AWOL.

## 2025-08-22 Status

* 2025-08-22 The script has had minimal testing and it seems to restore WiFi by rebooting. It needs further testing of the code to identify the device driver name (to `rmmod`/`modprobe`)

## 2025-08-22 Usage

```text
git clone https://github.com/HankB/maintain_wifi.git
cd maintain_wifi
sed -i s/name_ping_target/target_of_your_choosing/ maintain_wifi.service 
sudo cp maintain_wifi.sh /usr/local/sbin
sudo cp maintain_wifi.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now maintain_wifi
systemctl status maintain_wifi
```

## 2025-08-22 References

* <https://unix.stackexchange.com/questions/286721/get-wi-fi-interface-device-names> ID WiFi device names

## 2025-08-22 Monitoring

```text
journalctl -u maintain_wifi -f
```

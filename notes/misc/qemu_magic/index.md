<p style="text-align: right"><i>- 14/03/2022 -</i></p>

# Qemu Magic

## Cheat sheet

### Run VM

Run a simple qemu image with :

```bash
qemu-system-x86_64 -vga virtio -enable-kvm -m 4G -smp cpus=4 -hda ./mydisk.qcow2
```

For running it in "snapshot" mode (no changes made to the disk) add :

```bash
... -snapshot
```

Installing a system is just booting on a CD-ROM :

```bash
... -cdrom $ISO_FILE -boot d
```

By default, qemu is using a legacy bios. For UEFI, add :

```bash
... -bios $(sudo find / -iname ovmf.fd 2>/dev/null | head -n 1)
```

For taking snapshots see `qemu-img --help | grep -A 5 'snapshot subcommand'`.

### Manage snapshots

```bash
qemu-img snapshot -l redhat.qcow2
```

Create a snapshot

```bash
qemu-img snapshot -c mysnapshot redhat.qcow2
```

Revert to a snapshot

```bash
qemu-img snapshot -a mysnapshot redhat.qcow2
```

### Manage local dhcp server

```bash
dnsmasq \
  --port=0 \            # disable DNS server
  --no-daemon \         # do not fork, run in foreground
  --log-queries \       # log queries
  --interface=br1 \     # listen on the given interface
  --leasefile-ro \      # disable leasefile (no persistence)
  --dhcp-option=3 \     # disable default gateway annonciation
  --dhcp-option=6 \     # disable nameserver annonciation
  --dhcp-range=10.10.10.1,static \
  --dhcp-host=52:54:00:00:00:11,10.10.10.1 \
  --dhcp-host=52:54:00:00:00:12,10.10.10.2
```

## Scripts

For 80% of my qemu (UEFI) usage I use the following scripts :

### [`ks2img.sh`](./ks2img.md)

Converts a [kickstart](https://pykickstart.readthedocs.io/en/latest/kickstart-docs.html)
file to a storage device image file. It can be attached to a VM during the
installation process to bootstrap the system without the need of user input
(given that the system support kickstart files). It can also substitute
`CHANGEME` patterns in your kickstart files "on the fly" to avoid putting your
secrets in a version control system for exemple.

```txt
Usage: sudo ./ks2img.sh KICKSTART OUTFILE

    KICKSTART  Path to the kickstart file.
    OUTFILE    Path to the resulting image.

Environment variables :

    PASS_LUKS  Replace the CHANGEME_PASS_LUKS in the kickstart
    PASS_USER  Replace the CHANGEME_PASS_USER in the kickstart
```

Exemple usage :

```bash
export PASS_LUKS=MyH4rdPassphr4s3
export PASS_USER=p4ssw0rD
sudo ./ks2img.sh ./ks.cfg ./usb.img
```

### [`qemu-install.sh`](./qemu-install.md)

Creates a qemu virtual machine and launch installation process. You may provide
the image of a device containing a kickstart file.

```txt
Usage: ./qemu-install.sh DISK_PATH ISO_PATH ARCH [KICKSTART]

    DISK_PATH  Path to the resulting file (should end in .qcow2).
    ISO_PATH   Path to an iso image used for installation.
    ARCH       Architecture of the desired vm (as in qemu-system-...).
    KICKSTART  Path to an usb image used for installation.
```

Exemple Usage :

```bash
./qemu-install.sh redhat-server.qcow2 /isos/rhel-server-7.9-x86_64-dvd.iso x86_64 ks-vm-server-autopart.img
```

### [`qemu-networking.sh`](./qemu-networking.md)

This is a helper script that you can use to build the desired qemu network.
Source it and use the builtin functions.

```
makebridge BRIDGE_IFACE BRIDGE_IP BRIDGE_MASK PHY_IFACE

  Create a virtual interface (bridge) named BRIDGE_IFACE. Set BRIDGE_IP/BRIDGE_MASK
  as it's static ip and link it to the physical interface PHY_IFACE.

maketap IFVM IFBR

  Create a virtual interface (tap) named IFVM and link it to the virtual
  interface (bridge) named IFBR.

startvm TAP MAC DISK

  Start a virtual machine based on the qcow2 file named DISK. Link it's virtual
  network card to TAP interface and give it MAC as the mac address. Send it's
  execution to the background.
```

Exemple usage :

```bash
source ./qemu-networking.sh

IFACE_BRIDGE=br0

IFACE_VM1=tap1; MAC_VM1=52:54:00:00:00:01
IFACE_VM2=tap2; MAC_VM2=52:54:00:00:00:02
IFACE_VM3=tap3; MAC_VM3=52:54:00:00:00:03

makebridge $IFACE_BRIDGE 192.168.1.200 24 enp7s0

maketap $IFACE_VM1 $IFACE_BRIDGE
maketap $IFACE_VM2 $IFACE_BRIDGE
maketap $IFACE_VM3 $IFACE_BRIDGE

startvm $IFACE_VM1 $MAC_VM1 redhat-server-8.qcow2
startvm $IFACE_VM2 $MAC_VM2 redhat-server-7.qcow2
startvm $IFACE_VM3 $MAC_VM3 redhat-desktop-8.qcow2
```

## Ressources

For tun/tap networking :

- [ArchWiki: Tap networking with QEMU](https://wiki.archlinux.org/title/QEMU#Tap_networking_with_QEMU)
- [ArchWiki: Network Bridges](https://wiki.archlinux.org/title/Network_bridge)
- [ArchWiki: Network Configuration](https://wiki.archlinux.org/title/Network_configuration)
- [QemuWiki: Networking](https://wiki.qemu.org/Documentation/Networking)


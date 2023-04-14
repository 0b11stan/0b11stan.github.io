<p style="text-align: right"><i>- 12/03/2022 -</i></p>

# Qemu magic

## Scripts

For 80% of my qemu usage I use the following scripts :

### [`ks2usb.sh`](./ks2usb.sh)

```txt
Usage: sudo ./ks2usb.sh KICKSTART OUTFILE

    KICKSTART  Path to the kickstart file.
    OUTFILE    Path to the resulting image.

Environment variables :

    PASS_LUKS  Replace the CHANGEME_PASS_LUKS in the kickstart
    PASS_USER  Replace the CHANGEME_PASS_USER in the kickstart
```

Converts a [kickstart](https://pykickstart.readthedocs.io/en/latest/kickstart-docs.html)
file to a storage device image file. It can be attached to a VM during the
installation process to bootstrap the system without the need of user input
(given that the system support kickstart files). It can also substitute
`CHANGEME` patterns in your kickstart files "on the fly" to avoid putting your
secrets in a version control system for exemple.

Exemple usage :

```bash
export PASS_LUKS=MyH4rdPassphr4s3
export PASS_USER=p4ssw0rD
sudo ./ks2usb.sh ./ks.cfg ./usb.img
```

### [`qemu-install.sh`](./qemu-install.sh)

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

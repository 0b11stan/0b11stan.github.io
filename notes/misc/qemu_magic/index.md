<p style="text-align: right"><i>- 12/03/2022 -</i></p>

# Qemu magic

## Scripts

For 80% of my qemu usage I use the following scripts :

### [`ks2usb.sh`](./ks2usb.sh)

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

Here is the help :

```
Usage: sudo ./ks2usb.sh KICKSTART OUTFILE

    KICKSTART  Path to the kickstart file.
    OUTFILE    Path to the resulting image.

Environment variables :

    PASS_LUKS  Replace the CHANGEME_PASS_LUKS in the kickstart
    PASS_USER  Replace the CHANGEME_PASS_USER in the kickstart
```

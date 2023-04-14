<p style="text-align: right"><i>- 12/03/2022 -</i></p>

# Qemu magic

## Scripts

### `ks2usb.sh`

```bash
test $# -eq 2 || {
  echo -e "Usage: sudo $0 KICKSTART OUTFILE\n"
  echo -e "    KICKSTART  Path to the kickstart file."
  echo -e "    OUTFILE    Path to the resulting image.\n"
  echo -e "Environment variables :\n"
  echo -e "    PASS_LUKS  Replace the CHANGEME_PASS_LUKS in the kickstart"
  echo -e "    PASS_USER  Replace the CHANGEME_PASS_USER in the kickstart"
  exit 1
}

KICKSTART=$1
IMG_PATH=$2

changeme() {
  VAR=$1
  KSF=$2
  grep CHANGEME_$VAR $KSF &>/dev/null && test -z "${!VAR}" && {
    echo "ERROR: Variables need to be changed in the kickstart file ($KSF)."
    echo "       But no password has been provided as environement variable."
    echo "       You can run '$VAR=mypassword $0 $@' to fix this issue."
    exit 1
  }
  sed -i "s/CHANGEME_$VAR/${!VAR}/" $2
}

dd if=/dev/null of=$IMG_PATH bs=1M seek=10240
mkfs.ext4 -F $IMG_PATH
e2label $IMG_PATH OEMDRV
VOL=$(mktemp -d)
mount -t ext4 -o loop $IMG_PATH $VOL

cp $KICKSTART $VOL/ks.cfg

changeme PASS_LUKS $VOL/ks.cfg
changeme PASS_USER $VOL/ks.cfg

grep -i changeme $VOL/ks.cfg &>/dev/null \
  && echo WARNING: There are variables to change in $VOL/ks.cfg

umount $VOL &>/dev/null
chown $SUDO_USER $IMG_PATH &>/dev/null
```

### `qemu-install.sh`

```bash
DISK_PATH=$1
ISO_PATH=$2
ARCH=$3
KICKSTART=$4
MEMORY='4'
VCPU='4'

display_help() {
  echo -e "Usage: $0 DISK_PATH ISO_PATH ARCH [KICKSTART]\n"
  echo -e "    DISK_PATH  Path to the resulting file (should end in .qcow2)."
  echo -e "    ISO_PATH   Path to an iso image used for installation."
  echo -e "    ARCH       Architecture of the desired vm (as in qemu-system-...)."
  echo -e "    KICKSTART  Path to an usb image used for installation."
  exit 1
}

test "$DISK_PATH" = "-h" -o "$DISK_PATH" = "--help" && display_help

# required arguments
test -z "$DISK_PATH" && echo -e "Error: Missing DISK_PATH\n" && display_help
test -z "$ISO_PATH" && echo -e "Error: Missing ISO_PATH\n" && display_help
test -z "$ARCH" && echo -e "Error: Missing ARCH\n" && display_help

# arguments validity checks
which qemu-system-$ARCH \
  || { echo -e "Error: $ARCH is not a valid arch\n" && display_help; }
stat $ISO_PATH &>/dev/null \
  || { echo -e "Error: Cannot find iso image ($ISO_PATH)\n" && display_help; }
test -z "$KICKSTART" \
  || stat $KICKSTART &>/dev/null \
  || { echo -e "Error: Cannot find kickstart ($KICKSTART)\n" && display_help; }

OVMF_PATH=$(sudo find / -iname ovmf.fd 2>/dev/null | head -n 1)
qemu-img create -f qcow2 $DISK_PATH 30G

echo qemu-system-$ARCH \
  -enable-kvm \
  -m ${MEMORY}G \
  -smp cpus=$VCPU \
  -hda $DISK_PATH \
  $(test -n "$KICKSTART" && echo "-hdb $KICKSTART") \
  -cdrom $ISO_PATH \
  -bios $OVMF_PATH \
  -boot d | sh
```

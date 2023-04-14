# `ks2usb.sh`

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
    umount $(dirname $KSF)
    exit 1
  }
  sed -i "s/CHANGEME_$VAR/${!VAR}/" $KSF
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

umount $VOL
chown $SUDO_USER $IMG_PATH
```

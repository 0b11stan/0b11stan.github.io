# `qemu-install.sh`

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
  -vga virtio \
  -enable-kvm \
  -m ${MEMORY}G \
  -smp cpus=$VCPU \
  -hda $DISK_PATH \
  $(test -n "$KICKSTART" && echo "-hdb $KICKSTART") \
  -cdrom $ISO_PATH \
  -bios $OVMF_PATH \
  -boot d | sh
```

OVMF_PATH=$(sudo find /nix/store -iname ovmf.fd 2>/dev/null | head -n 1)

makebridge() {
  BRIDGE_IFACE=$1; BRIDGE_IP=$2; BRIDGE_MASK=$3; PHY_IFACE=$4;

  WLAN_GATEWAY=$(ip route | grep default | head -n 1 | cut -d ' ' -f 3)

  # setup the bridge
  ip link show dev $BRIDGE_IFACE &>/dev/null && echo "bridge $BRIDGE_IFACE exist" || {
    sudo ip link add name $BRIDGE_IFACE type bridge
    sudo ip link set dev $BRIDGE_IFACE up
  }

  # enslave your main interface to the bridge to give internet to vms
  bridge link show | grep $PHY_IFACE && echo "$PHY_IFACE bridged" || {
    sudo ip link set $PHY_IFACE up
    sudo ip link set $PHY_IFACE master $BRIDGE_IFACE
  }

  # make internet back on host
  ip address show $BRIDGE_IFACE | grep "$BRIDGE_IP/$BRIDGE_MASK" \
    && echo "$BRIDGE_IFACE configured" || {
      sudo ip link set $PHY_IFACE down
      sudo ip link set $PHY_IFACE up
      sudo ip address add $BRIDGE_IP/$BRIDGE_MASK dev $BRIDGE_IFACE
      sudo ip route add default via $WLAN_GATEWAY dev $BRIDGE_IFACE
    }
}

maketap() {
  IFVM=$1; IFBR=$2
  ip link show dev $IFVM &>/dev/null && echo "$IFVM exist" || {
    sudo ip tuntap add dev $IFVM mode tap
    sudo ip link set dev $IFVM master $IFBR
  }
}

startvm() {
  TAP=$1; MAC=$2; DISK=$3
  sudo ip link set dev $TAP up
  qemu-system-x86_64 \
    -vga virtio \
    -enable-kvm \
    -m 4G \
    -smp cpus=4 \
    -hda $DISK \
    -bios $OVMF_PATH \
    -netdev tap,id=network0,ifname=$TAP,script=no,downscript=no \
    -device virtio-net,netdev=network0,mac=$MAC \
    -snapshot &
}

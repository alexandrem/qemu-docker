#!/bin/bash
set -e

qemu_args=("-nographic")

n=0
fd=3
while [ ${n} != ${NUM_BRIDGED_INTERFACES:0} ]; do
  macvlan_if="vm${n}"
  macvtap_if="macvtap_vm${n}"
  if ! [ -d "/sys/devices/virtual/net/${macvlan_if}" ]; then
    echo >&2 "Waiting for interface ${macvlan_if}.  Please run:"
    echo >&2 "pipework eth${n} -i ${macvlan_if} $HOSTNAME 0/0"
    while ! [ -d "/sys/devices/virtual/net/${macvlan_if}" ]; do
      sleep 0.5
    done
  fi
  if ! [ -d "/sys/devices/virtual/net/${macvtap_if}" ]; then
    ip link add ${macvtap_if} link ${macvlan_if} type macvtap
    ip link set ${macvtap_if} up
  fi
  mac="$(cat /sys/devices/virtual/net/${macvtap_if}/address)"
  if ! [ -f "/dev/net/${macvtap_if}" ]; then
    mknod /dev/net/${macvtap_if} c $(cat /sys/devices/virtual/net/${macvtap_if}/tap*/dev | tr ':' ' ')
  fi
  qemu_args+=("-net" "nic,vlan=${n},macaddr=${mac}" "-net" "tap,vlan=${n},fd=${fd}")
  eval "exec ${fd}<>/dev/net/${macvtap_if}"
  n=$[n+1]
  fd=$[fd+1]
done

qemu_args+=("$@")

echo >&2 qemu-system-x86_64 "${qemu_args[@]}"
exec qemu-system-x86_64 "${qemu_args[@]}"

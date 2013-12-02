#!/bin/bash
# Docker entrypoint that does runtime setup of the container environment for KVM,
# before running the user-specified command.

dd if=/dev/kvm count=0 2>/dev/null || {
  echo >&2 "Unable to open /dev/kvm; qemu will use software emulation"
  echo >&2 "(This can happen if the container is run without -privileged," \
           "or if the KVM kernel module is not loaded)"
}

exec "$@"

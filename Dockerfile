FROM stackbrew/ubuntu:saucy
MAINTAINER kevin@pentabarf.net

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y qemu-kvm bridge-utils

RUN mknod /dev/kvm c 10 232
RUN mkdir -p /dev/net

WORKDIR /root/qemu
ADD entrypoint.sh /root/qemu/entrypoint.sh
ADD run.sh /root/qemu/run.sh
RUN chmod +x /root/qemu/*.sh

# Number of network interfaces to bridge into the guest.
# Note: if >0, requires use of pipework outside the container.
ENV NUM_BRIDGED_INTERFACES 0

ENTRYPOINT ["/root/qemu/entrypoint.sh"]

qemu-docker
===========

`qemu-docker` is a base Docker container containing KVM-enabled qemu binaries, and scripts to set up the `/dev/kvm` device node (which udev would normally do for us in a non-containerized environment).  It is meant to be built on top of using `FROM` in another Dockerfile (it's `kevin/qemu` in the Docker index).
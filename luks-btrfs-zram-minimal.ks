# based on luks-btrfs-minimal
# + https://fedoraproject.org/wiki/Changes/SwapOnZRAM
install
rootpw --plaintext fedora
auth --enableshadow --passalgo=sha512
keyboard --vckeymap=us --xlayouts='us'
lang en_US.UTF-8
timezone --isUtc Atlantic/Reykjavik
network --activate

text

# Wipe all disk
zerombr
bootloader
clearpart --all --initlabel
autopart --type=btrfs --encrypted --noswap

# Package source
# There's currently no way of using default online repos in a kickstart, see:
# https://bugzilla.redhat.com/show_bug.cgi?id=1333362
# https://bugzilla.redhat.com/show_bug.cgi?id=1333375
# So we default to fedora+updates and exclude updates-testing, which is the safer choice.
url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-$releasever&arch=$basearch
repo --name=fedora
repo --name=updates
#repo --name=updates-testing

%packages
@^minimal-environment
zram-generator
%end

%post
# home should be a separate subvolume
mv /home /tmp/
btrfs subvolume create /home
mv /tmp/home/* /home
rmdir /tmp/home

cat << EOF > /etc/systemd/zram-generator.conf
[zram0]
# This section describes the settings for /dev/zram0.
#
# The maximum amount of memory (in MiB). If the machine has more RAM
# than this, zram device will not be created.
#
# The default is 2048 MiB, i.e. the device is only created on machines
# with limited memory.
#
# "memory-limit = none" may be used to disable this limit.
memory-limit = none

# The fraction of memory to use as ZRAM. For example, if the machine
# has 1 GiB, and zram-fraction=0.25, then the zram device will have
# 256 MiB. Values in the range 0.10–0.40 are recommended.
#
# The default is 0.25.
zram-fraction = 0.5
EOF
%end

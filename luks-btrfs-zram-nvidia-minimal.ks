# based on luks-btrfs-minimal
# + https://fedoraproject.org/wiki/Changes/SwapOnZRAM
install
rootpw --lock
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

services --enabled=initial-setup
reboot

%packages
@^minimal-environment
fedora-workstation-repositories
initial-setup
pciutils
zram-generator
%end

%post
# https://unix.stackexchange.com/a/351755 for handling TTY in anaconda
printf "Press Alt-F3 to view post-install logs\r\n" > /dev/tty1
{
# install RPM Fusion's Nvidia driver on VMs (for testing) and if
# the GPU is detected
has_nvidia=false
if /usr/sbin/lspci -mnn | grep -E 'VGA|3D controller' | grep NVIDIA | grep -q 10de; then
  has_nvidia=true
fi

# Lets check if we have virtual machine
systemd-detect-virt >/dev/null && is_virtual=true || is_virtual=false

if $has_nvidia || $is_virtual; then
  echo "Enabling proprietary Nvidia driver repo"
  dnf config-manager --set-enabled \
    rpmfusion-nonfree-nvidia-driver
  echo "Installing proprietary Nvidia driver"
  dnf install -y \
    akmod-nvidia \
    kernel-devel-$(rpm -q kernel --queryformat=%{version}-%{release}) \
    nvidia-settings
fi

# home should be a separate subvolume
echo "Creating /home subvolume"
mv /home /tmp/
btrfs subvolume create /home
mv /tmp/home/* /home
rmdir /tmp/home

echo "Configuring swap-on-zram"
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
} 2>&1 | tee /root/postinstall.log > /dev/tty3
%end

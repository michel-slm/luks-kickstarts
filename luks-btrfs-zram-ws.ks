%include luks-btrfs-minimal.ks

%include snippets/zram.ks

%include snippets/workstation.ks

# test changes in one of the minimal kickstarts
# this one should be robust, so just reboot at the end
reboot

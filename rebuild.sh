mkdir -p iso
ansible-playbook --connection=local -i 127.0.0.1, ./build_fedora_iso.yaml -K

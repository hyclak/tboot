#!/data/data/com.termux/files/usr/bin/bash

run_update_and_upgrade() {
    echo "RUNNING PKG UPDATE..."
    yes | pkg update -y
    echo "RUNNING PKG UPGRADE..."
    yes | pkg upgrade -y
}

install_packages() {
    echo "INSTALLING DEPENDENCIES..."
    yes | pkg install libcurl libjansson tmux wget nano -y
}

install_primominer() {
    echo "INSTALLING PRIMO MINER..."
    curl -fsSL https://primolab.dev/install.sh | sh
    echo "PRIMO MINER INSTALLATION COMPLETE!"
}

install_sshd() {
    export SVDIR=$PREFIX/var/service
    echo "INSTALLING SSHD..."
    yes | pkg install openssh -y
    echo "CONFIGURING AUTHORIZED KEYS..."
    install -d -m 0700 ~/.ssh
    echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILlWwMqI/U1L0ym99TbCRgfReJoW5Os0OY/iS0HUHmYb mhyclak@controller.reversion.org" > ~/.ssh/authorized_keys
    chmod 600 ~/.ssh/authorized_keys
    echo "SSHD INSTALLATION COMPLETE!"
}

make_folders() {
    echo "CREATING FOLDERS..."
    mkdir -p /data/data/com.termux/files/home/ccminer
    mkdir -p /data/data/com.termux/files/home/.termux/boot
}

download_files() {
    echo "DOWNLOADING FILES..."
    base_url="https://raw.githubusercontent.com/hyclak/tboot/main"
    wget -q -O /data/data/com.termux/files/home/ccminer/ccminer "$base_url/ccminer/ccminer" && echo "Downloaded ccminer"
    wget -q -O /data/data/com.termux/files/home/ccminer/config.json "$base_url/ccminer/config.json" && echo "Downloaded config.json"
    wget -q -O /data/data/com.termux/files/home/ccminer/start.sh "$base_url/ccminer/start.sh" && echo "Downloaded start.sh"
    wget -q -O /data/data/com.termux/files/home/.termux/boot/autoboot.sh "$base_url/.termux/boot/autoboot.sh" && echo "Downloaded autoboot.sh"
    wget -q -O /data/data/com.termux/files/home/.termux/boot/start-sshd "$base_url/.termux/boot/start-sshd" && echo "Downloaded start-sshd"
    wget -q -O /data/data/com.termux/files/home/.bashrc "$base_url/.bashrc" && echo "Downloaded .bashrc"
}

set_permissions() {
    echo "SETTING EXECUTION PERMISSIONS..."
    chmod +x /data/data/com.termux/files/home/ccminer/ccminer
    chmod +x /data/data/com.termux/files/home/ccminer/start.sh
    chmod +x /data/data/com.termux/files/home/.termux/boot/autoboot.sh
    chmod +x /data/data/com.termux/files/home/.termux/boot/start-sshd
}

main() {
    run_update_and_upgrade
    install_packages
    install_primominer
    install_sshd
    make_folders
    download_files
    set_permissions
    echo "INSTALLATION COMPLETE!"
}

main

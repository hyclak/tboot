#!/data/data/com.termux/files/usr/bin/bash

run_update_and_upgrade() {
    echo "RUNNING PKG UPDATE..."
    yes | pkg update -y
    echo "RUNNING PKG UPGRADE..."
    yes | pkg upgrade -y
}

install_packages() {
    echo "INSTALLING DEPENDENCIES..."
    yes | pkg install libjansson wget nano -y
}

install_sshd() {
    echo "INSTALLING SSHD..."
    yes | pkg install openssh -y
    echo "SETTING SSHD TO START AUTOMATICALLY..."
    sv-enable sshd
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
    wget -q -O /data/data/com.termux/files/home/.bashrc "$base_url/.bashrc" && echo "Downloaded .bashrc"
}

set_permissions() {
    echo "SETTING EXECUTION PERMISSIONS..."
    chmod +x /data/data/com.termux/files/home/ccminer/ccminer
    chmod +x /data/data/com.termux/files/home/ccminer/start.sh
    chmod +x /data/data/com.termux/files/home/.termux/boot/autoboot.sh
}

main() {
    run_update_and_upgrade
    install_packages
    install_sshd
    make_folders
    download_files
    set_permissions
    echo "INSTALLATION COMPLETE!"
}

main

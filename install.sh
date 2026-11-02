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
    export SVDIR=$PREFIX/var/service
    echo "INSTALLING SSHD..."
    yes | pkg install openssh termux-services -y
    echo "SETTING SSHD TO START AUTOMATICALLY..."
    # 1. Create the service and logging directories
    mkdir -p $PREFIX/var/service/sshd/log
    # 2. Create the run script to start sshd in the foreground (-D)
    echo '#!/data/data/com.termux/files/usr/bin/sh' > $PREFIX/var/service/sshd/run
    echo 'exec sshd -D' >> $PREFIX/var/service/sshd/run
    chmod +x $PREFIX/var/service/sshd/run
    # 3. Symlink the default Termux services logger
    ln -sf $PREFIX/share/termux-services/svlogger $PREFIX/var/service/sshd/log/run

    sv-enable sshd
    sv up sshd
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

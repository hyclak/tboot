# Only on the phone's own terminal, not SSH
if [ -z "$SSH_CONNECTION" ] && [ -z "$TMUX" ]; then
    termux-wake-lock
    tmux new-session -A -s miner \
        "primo-arm-miner --config /data/data/com.termux/files/home/ccminer/config.json"
fi

if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec Hyprland
else
    echo "Welcome to tty land!"
fi


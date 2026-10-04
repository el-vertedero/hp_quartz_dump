#!/vendor/bin/sh

if [ -f /sys/class/drm/card0-eDP-1/modes ]; then
    read -r RES < /sys/class/drm/card0-eDP-1/modes
    setprop vendor.display.resolution "$RES"
fi

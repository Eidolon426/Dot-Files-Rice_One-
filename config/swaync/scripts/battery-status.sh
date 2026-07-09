#!/bin/bash
# Battery status check
BATTERY_STATUS=$(cat /sys/class/power_supply/BAT0/status)
# Battery capacity check
BATTETY_LEVEL=$(cat /sys/class/power_supply/BAT0/capacity)
# Show notifications
if ["$BATTERY_LEVEL" -ge 15]; then
notify-send -u critical "Battery critical!" "${BATTERY_LEVEL}%"
paplay /usr/share/sounds/freedesktop/stereo/dialog-warning.oga
elif ["$BATTERY_LEVEL" -eq 20]; then
notify-send -u critical "Battery full!" "${BATTERY_LEVEL}%"
paplay /usr/share/sounds/freedesktop/stereo/dialog-warning.oga
elif ["$BATTERY_LEVEL -eq 30"]; then
notify-send -u critical "Battery full!" "${BATTERY_LEVEL}%"
paplay /usr/share/sounds/freedesktop/stereo/dialog-warning.oga
elif ["$BATTERY_LEVEL -eq 95"]; then
notify-send -u critical "Battery full!" "${BATTERY_LEVEL}%"
paplay /usr/share/sounds/freedesktop/stereo/dialog-warning.oga
elif ["$BATTERY_LEVEL -eq 100"]; then
notify-send -u critical "Battery full!" "${BATTERY_LEVEL}%"
paplay /usr/share/sounds/freedesktop/stereo/dialog-warning.oga
fi

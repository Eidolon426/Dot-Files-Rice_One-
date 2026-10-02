#!/bin/bash

check_upgradable() {
    pacman -Sy
    pkgup=$(pacman -Qu | wc -l)

    if [ $pkgup -gt 0 ]; then
    notify-send "Pacman Updates available"
  paplay /usr/share/sounds/freedesktop/stereo/complete.oga
  fi
}

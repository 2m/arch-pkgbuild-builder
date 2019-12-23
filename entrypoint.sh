#!/bin/sh -l

target=$1
pkgbuild=$2

case $target in
    pkgbuild)
        namcap PKGBUILD
        makepkg --syncdeps --noconfirm
        namcap "${pkgname}"-*
        pacman -Qip "${pkgname}"-*
        pacman -Qlp "${pkgname}"-*
        ;;
    srcinfo)
        makepkg --printsrcinfo | diff .SRCINFO - || \
            { echo ".SRCINFO is out of sync. Please run 'makepkg --printsrcinfo' and commit the changes."; false; }
        ;;
    *)
      echo "Target should be one of 'pkgbuild', 'srcinfo'" ;;
esac

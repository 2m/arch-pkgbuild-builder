#!/bin/sh -l

target=$1
pkgbuild=$2

# '/github/workspace' is mounted as a volume and has owner set to root
# set the owner to the 'build' user, so it can access package files
sudo chown build /github/workspace

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

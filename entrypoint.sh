#!/bin/bash

# fail whole script if any command fails
set -e

DEBUG=$4

if [[ -n $DEBUG  && $DEBUG = true ]]; then
    set -x
fi

target=$1
pkgname=$2
command=$3

# assumes that package files are in a subdirectory
# of the same name as "pkgname", so this works well
# with "aurpublish" tool

pkgbuild_dir=$(readlink "$pkgname" -f) # nicely cleans up path, ie. ///dsq/dqsdsq/my-package//// -> /dsq/dqsdsq/my-package

if [[ ! -d $pkgbuild_dir ]]; then
    echo "$pkgbuild_dir should be a directory."
    exit 1
fi

if [[ ! -e $pkgbuild_dir/PKGBUILD ]]; then
    echo "$pkgbuild_dir does not contain a PKGBUILD file."
    exit 1
fi

if [[ ! -e $pkgbuild_dir/.SRCINFO ]]; then
    echo "$pkgbuild_dir does not contain a .SRCINFO file."
    exit 1
fi

getfacl -p -R "$pkgbuild_dir" /github/home > /tmp/arch-pkgbuild-builder-permissions.bak

# '/github/workspace' is mounted as a volume and has owner set to root
# set the owner of $pkgbuild_dir  to the 'build' user, so it can access package files.
sudo chown -R build "$pkgbuild_dir"

# needs permissions so '/github/home/.config/yay' is accessible by yay
sudo chown -R build /github/home

# use more reliable keyserver
mkdir -p /github/home/.gnupg/
echo "keyserver hkp://keyserver.ubuntu.com:80" | tee /github/home/.gnupg/gpg.conf

cd "$pkgbuild_dir"

pkgname=$(grep -E 'pkgname' .SRCINFO | sed -e 's/.*= //')

install_deps() {
    # install all package dependencies
    grep -E 'depends' .SRCINFO | \
        sed -e 's/.*depends = //' -e 's/:.*//' | \
        xargs yay -S --noconfirm
}

case $target in
    pkgbuild)
        namcap PKGBUILD
        install_deps
        makepkg --syncdeps --noconfirm

        # shellcheck disable=SC1091
        source /etc/makepkg.conf # get PKGEXT

        namcap "${pkgname}"-*"${PKGEXT}"
        pacman -Qip "${pkgname}"-*"${PKGEXT}"
        pacman -Qlp "${pkgname}"-*"${PKGEXT}"
        ;;
    run)
        install_deps
        makepkg --syncdeps --noconfirm --install
        eval "$command"
        ;;
    srcinfo)
        makepkg --printsrcinfo | diff --ignore-blank-lines .SRCINFO - || \
            { echo ".SRCINFO is out of sync. Please run 'makepkg --printsrcinfo' and commit the changes."; false; }
        ;;
    *)
      echo "Target should be one of 'pkgbuild', 'srcinfo', 'run'" ;;
esac

sudo setfacl --restore=/tmp/arch-pkgbuild-builder-permissions.bak

#!/bin/sh -l

target=$1
pkgbuild=$2
command=$3

# assumes that package files are in a subdirectory
# of the same name as "pkgname", so this works well
# with "aurpublish" tool

pkgbuild_dir=$(dirname $(readlink $pkgbuild -f))
cd $pkgbuild_dir || exit

# '/github/workspace' is mounted as a volume and has owner set to root
# set the owner to the 'build' user, so it can access package files
sudo chown -R build $pkgbuild_dir

pkgname=$(basename $pkgbuild_dir)

install_deps() {
    # install make and regular package dependencies
    grep -E 'depends|makedepends' PKGBUILD | \
        sed -e 's/.*depends=//' -e 's/ /\n/g' | \
        tr -d "'" | tr -d "(" | tr -d ")" | \
        xargs sudo yay -S --noconfirm
}

case $target in
    pkgbuild)
        namcap PKGBUILD
        install_deps
        makepkg --syncdeps --noconfirm
        namcap "${pkgname}"-*
        pacman -Qip "${pkgname}"-*.xz
        pacman -Qlp "${pkgname}"-*.xz
        ;;
    run)
        install_deps
        makepkg --syncdeps --noconfirm --install
        eval "$command"
        ;;
    srcinfo)
        makepkg --printsrcinfo | diff .SRCINFO - || \
            { echo ".SRCINFO is out of sync. Please run 'makepkg --printsrcinfo' and commit the changes."; false; }
        ;;
    *)
      echo "Target should be one of 'pkgbuild', 'srcinfo', 'run'" ;;
esac

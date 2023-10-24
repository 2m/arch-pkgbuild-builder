pwd := env_var('PWD')

# fetch base image and build arch-pkgbuild-builder
build:
  docker pull martynas/archlinux
  docker build -t arch-pkgbuild-builder .

# run a comment on AUR project, like `just run-on-aur ucm-bin pkgbuild`
run-on-aur project command:
  mkdir -p target
  git -C target/{{project}} pull || git clone https://aur.archlinux.org/{{project}}.git target/{{project}}
  docker run --rm -v {{pwd}}/target/{{project}}:/home/build -v /tmp/gh:/github/home arch-pkgbuild-builder {{command}} .

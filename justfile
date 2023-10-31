pwd := env_var('PWD')

# fetch base image and build arch-pkgbuild-builder
build:
  docker pull martynas/archlinux
  docker build -t arch-pkgbuild-builder .

# run a command on a project, like:
#   just run git@github.com:Marcool04/linux-fix-e1000e.git pkgbuild
#   just run https://aur.archlinux.org/ucm-bin.git pkgbuild
run project-uri command:
  rm -rf target
  mkdir target
  git clone {{project-uri}} target
  docker run --rm -v {{pwd}}/target:/home/build -v /tmp/gh:/github/home arch-pkgbuild-builder {{command}} .

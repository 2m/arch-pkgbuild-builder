# Arch Linux PKGBUILD builder action

This action builds an validates Arch Linux package.
The `PKGBUILD` and `.SRCINFO` files should be under a subdirectory named the same as the `pkgbuild` of the package.

This assumption made is so that this action works well with [aurpublish] (_untested in this fork yet_).

This version is a fork from the original [arch-pkgbuild-builder](https://github.com/2m/arch-pkgbuild-builder).

It differs in that the `PKGBUILD` and related files do not need to be place in the root of the github workspace.

[aurpublish]: https://github.com/eli-schwartz/aurpublish

## Inputs

### `target`

**Required** Validation target. Can be one of: `pkgbuild`, `srcinfo`, `run`.

### `pkgname`

**Required** The `pkgname` of the package to be validated.

## Example usage

### pkguild

Verifies and builds the package.

```yml
uses: grumlimited/arch-pkgbuild-builder@v1
with:
  target: 'pkgbuild'
  pkgname: 'data/arch/authenticator-rs/PKGBUILD'
```

### srcinfo

Verifies if the `.SRCINFO` is up to date with the `PKGBUILD`.

```yml
uses: grumlimited/arch-pkgbuild-builder@v1
with:
  target: 'srcinfo'
  pkgname: 'ucm-bin'
```

### run

Installs the package and runs a given `command`.

```yml
uses: grumlimited/arch-pkgbuild-builder@v1
with:
  target: 'run'
  pkgname: 'ucm-bin'
  command: `ucm --version`
```

## Used by

So far this action is used by the following packages:

* [authenticator-rs](https://github.com/grumlimited/authenticator-rs)

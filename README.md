# Arch Linux PKGBUILD builder action

This action builds an validates Arch Linux package.
The `PKGBUILD` and `.SRCINFO` files should be under a subdirectory named the same as the `pkgbuild` of the package.
This assumption is made so this action works well with [aurpublish].

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
uses: 2m/arch-pkgbuild-builder@v1
with:
  target: 'pkgbuild'
  pkgname: 'ucm-bin'
```

### srcinfo

Verifies if the `.SRCINFO` is up to date with the `PKGBUILD`.

```yml
uses: 2m/arch-pkgbuild-builder@v1
with:
  target: 'srcinfo'
  pkgname: 'ucm-bin'
```

### run

Installs the package and runs a given `command`.

```yml
uses: 2m/arch-pkgbuild-builder@v1
with:
  target: 'run'
  pkgname: 'ucm-bin'
  command: `ucm --version`
```

## Used by

So far this action is used by the following packages:

* [ucm-bin](https://github.com/2m/ucm-bin-pkgbuild)

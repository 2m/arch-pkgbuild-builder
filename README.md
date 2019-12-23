# ArchLinux PKGBUILD builder action

This action builds an validates PKGBUILD definition.

## Inputs

### `target`

**Required** Validation target. Can be one of: `pkgbuild`, `srcinfo`.

### `pkgname`

The `pkgname` of the package to be validated. Required for the `pkgbuild` target.

## Example usage

```
uses: 2m/arch-pkgbuild-builder@v1
with:
  target: 'pkgbuild'
  pkgname: 'ucm-bin'

uses: 2m/arch-pkgbuild-builder@v1
with:
  target: 'srcinfo'
```

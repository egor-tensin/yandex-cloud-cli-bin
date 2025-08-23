This has been expired by the [yandex-cloud-bin] package, but this one fixes a
couple of things.

* The undocumented `components post-update` is no longer called; this means
  that parent directory is no longer polluted by completion.* files.
* $pkgver is calculated dynamically, which makes it easier to maintain.

[yandex-cloud-bin]: https://aur.archlinux.org/packages/yandex-cloud-bin/

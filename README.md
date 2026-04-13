* AUR: https://aur.archlinux.org/packages/yandex-cloud-cli-bin
* GitHub: https://github.com/egor-tensin/yandex-cloud-cli-bin/tree/aur

This was inspired by the [yandex-cloud-bin] package, but this one fixes a
couple of things.

* The undocumented `components post-update` is no longer called; this means
  that parent directory is no longer polluted by completion.*.inc files.
* $pkgver is calculated dynamically, which makes it easier to maintain and
  allows automation.
* Version updates are automated to be done once a week.

[yandex-cloud-bin]: https://aur.archlinux.org/packages/yandex-cloud-bin/

include prelude.mk

PKG_NAME := yandex-cloud-cli-bin

.PHONY: all
all: build

.PHONY: build
build:
	makepkg --clean --cleanbuild --force --syncdeps && makepkg --printsrcinfo > .SRCINFO

.PHONY: commit
commit:
	git add .SRCINFO
	source ./PKGBUILD && git commit -am "aur: $$pkgver-$$pkgrel"

.PHONY: push
push:
	git push 'ssh://aur@aur.archlinux.org/$(call escape,$(PKG_NAME)).git' "$$( git symbolic-ref HEAD ):master"

BASE_URL := https://storage.yandexcloud.net/yandexcloud-yc/release

.PHONY: pkgver
pkgver:
	new_pkgver=$$( curl --silent --show-error --location --connect-timeout 5 -- '$(call escape,$(BASE_URL))/stable' ) && \
		. PKGBUILD && \
		if [ "$$pkgver" != "$$new_pkgver" ]; then \
		    sed -i -e "s/^pkgver=.*/pkgver=$$new_pkgver/" PKGBUILD && \
		    sed -i -e "s/^pkgrel=.*/pkgrel=1/" PKGBUILD; \
		fi


.PHONY: maintenance
maintenance: pkgver
	$(MAKE) build

	@git_status="$$( git status --porcelain=v1 )" && \
	if [ -z "$$git_status" ]; then \
		true; \
	elif [ "$$git_status" = $$' M .SRCINFO\n M PKGBUILD' ]; then \
		$(MAKE) commit && \
			git push -q && \
			$(MAKE) push ; \
	else \
		echo; \
		echo '-----------------------------------------------------------------'; \
		echo 'Error: unrecognized modifications in the repository:'; \
		echo "$$git_status"; \
		echo '-----------------------------------------------------------------'; \
		exit 1; \
	fi

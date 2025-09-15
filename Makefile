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

.PHONY: maintenance
maintenance:
	$(MAKE) || true
	$(MAKE)

	@git_status="$$( git status --porcelain=v1 )" && \
	if [ -z "$$git_status" ]; then \
		true; \
	elif [ "$$git_status" = $$' M .SRCINFO\n M PKGBUILD' ]; then \
		$(MAKE) commit; \
		$(MAKE) push; \
	else \
		echo; \
		echo '-----------------------------------------------------------------'; \
		echo 'Error: unrecognized modifications in the repository:'; \
		echo "$$git_status"; \
		echo '-----------------------------------------------------------------'; \
		exit 1; \
	fi

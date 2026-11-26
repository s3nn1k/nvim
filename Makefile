.PHONY: lint fmt install

lint:
	stylua --check .
	for script in scripts/install.sh platform/*.sh; do bash -n "$$script" || exit 1; done
	shellcheck scripts/install.sh platform/*.sh

fmt:
	stylua .

install:
	./scripts/install.sh

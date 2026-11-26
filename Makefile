.PHONY: lint fmt init

lint:
	stylua --check .
	for script in init.sh scripts/*.sh; do bash -n "$$script" || exit 1; done
	shellcheck init.sh scripts/*.sh

fmt:
	stylua .

init:
	./init.sh

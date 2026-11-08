.PHONY: lint fmt init

lint:
	stylua --check .

fmt:
	stylua .

init:
	./init.sh

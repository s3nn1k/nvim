.PHONY: macos fedora test

macos:
	./scripts/macos-bootstrap.sh

fedora:
	./scripts/fedora-bootstrap.sh

test:
	nvim -n --headless -u tests/minimal_init.lua -c "PlenaryBustedDirectory tests"

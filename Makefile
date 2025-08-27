# Copyright 2025 Mitchell Kember. Subject to the MIT License.

define usage
Targets:
	install  Symlink into ~/.config/fish
	help     Show this help message
endef

XDG_CONFIG_HOME ?= $(HOME)/.config

files := $(wildcard */*.fish) functions/fzf_helpers
files := $(files:%=$(XDG_CONFIG_HOME)/fish/%)

.PHONY: help install

help:
	$(info $(usage))
	@:

install: $(files)

$(files): $(XDG_CONFIG_HOME)/fish/%: %
	ln -sfn $(CURDIR)/$< $@

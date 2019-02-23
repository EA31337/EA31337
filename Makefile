SHELL:=/usr/bin/env bash

.PHONY: all test compile-mql4 compile-mql5 requirements set-none \
		clean clean-src clean-releases \
		EA Lite Advanced Rider \
		Release Lite-Release Advanced-Release Rider-Release \
		Backtest Lite-Backtest Advanced-Backtest Rider-Backtest

MQL=metaeditor.exe
SRC=$(wildcard src/*.mq4)
EA=EA31337
EX4=src/$(EA).ex4
EX5=src/$(EA).ex5
VER=$(shell grep 'define ea_version' src/include/EA31337/ea-properties.mqh | grep -o '[0-9].*[0-9]')
FILE=$(lastword $(MAKEFILE_LIST)) # Determine this Makefile's path.
OUT=.
MKFILE=$(abspath $(lastword $(MAKEFILE_LIST)))
CWD=$(notdir $(patsubst %/,%,$(dir $(MKFILE))))
all: requirements $(MQL) compile-mql4

requirements:
	type -a git ex wine 2> /dev/null

Lite: 		$(OUT)/$(EA)-Lite-%.ex4
Advanced: $(OUT)/$(EA)-Advanced-%.ex4
Rider: 		$(OUT)/$(EA)-Rider-%.ex4

Lite-Release: 		$(OUT)/$(EA)-Lite-Release-%.ex4
Advanced-Release:	$(OUT)/$(EA)-Advanced-Release-%.ex4
Rider-Release:		$(OUT)/$(EA)-Rider-Release-%.ex4

Lite-Backtest:			$(OUT)/$(EA)-Lite-Backtest-%.ex4
Advanced-Backtest:	$(OUT)/$(EA)-Advanced-Backtest-%.ex4
Rider-Backtest:			$(OUT)/$(EA)-Rider-Backtest-%.ex4

compile-mql4: requirements $(MQL) clean-src $(OUT)/$(EA).ex4
	@echo MQL4 compiled.
compile-mql5: requirements $(MQL) clean-src $(OUT)/$(EA).ex5
	@echo MQL5 compiled.

test: requirements set-mode $(MQL)
	wine metaeditor.exe /s /i:src /mql4 $(SRC)
	wine metaeditor.exe /s /i:src /mql5 $(SRC)

metaeditor.exe:
	curl -LO https://github.com/EA31337/MetaEditor/raw/master/metaeditor.exe

# E.g.: make set-mode MODE="__advanced__"
set-mode:
ifdef MODE
	git checkout -- src/include/EA31337/ea-mode.mqh
	ex -s +"%s@^\zs.*\ze#define \($(MODE)\)@@g" -cwq src/include/EA31337/ea-mode.mqh
endif

set-none:
	@echo Reverting modes.
	git checkout -- src/include/EA31337/ea-mode.mqh
	ex -s +":g@^#define@s@^@//" -cwq src/include/EA31337/ea-mode.mqh

set-lite: set-none
	@$(MAKE) -f $(FILE)

set-advanced: set-none
	@$(MAKE) -f $(FILE) set-mode MODE="__advanced__"

set-rider: set-none
	@$(MAKE) -f $(FILE) set-mode MODE="__rider__"

set-lite-release: set-none
	@$(MAKE) -f $(FILE) set-mode MODE="__release__"

set-advanced-release: set-none
	@$(MAKE) -f $(FILE) set-mode MODE="__release__\|__advanced__"

set-rider-release: set-none
	@$(MAKE) -f $(FILE) set-mode MODE="__release__\|__rider__"

set-lite-backtest: set-none
	@$(MAKE) -f $(FILE) set-mode MODE="__backtest__"

set-advanced-backtest: set-none
	@$(MAKE) -f $(FILE) set-mode MODE="__backtest__\|__advanced__"

set-rider-backtest: set-none
	@$(MAKE) -f $(FILE) set-mode MODE="__backtest__\|__rider__"

set-testing:
	@$(MAKE) -f $(FILE) set-mode MODE="__testing__"

clean-all: clean-src

clean-src:
	@echo Cleaning src...
	find src/ '(' -name '*.ex4' -or -name '*.ex5' ')' -delete

EA: metaeditor.exe \
		clean-all \
		$(OUT)/$(EA)-Lite-%.ex4 \
		$(OUT)/$(EA)-Advanced-%.ex4 \
		$(OUT)/$(EA)-Rider-%.ex4

Release: metaeditor.exe \
		clean-all \
		$(OUT)/$(EA)-Lite-Release-%.ex4 \
		$(OUT)/$(EA)-Advanced-Release-%.ex4 \
		$(OUT)/$(EA)-Rider-Release-%.ex4

Backtest: metaeditor.exe \
		clean-all \
		$(OUT)/$(EA)-Lite-Backtest-%.ex4 \
		$(OUT)/$(EA)-Advanced-Backtest-%.ex4 \
		$(OUT)/$(EA)-Rider-Backtest-%.ex4

$(OUT)/$(EA)-Lite-%.ex4: \
		set-lite \
		$(OUT)/$(EA).ex4 \
		set-none
	cp -v "$(EX4)" "$(OUT)/$(EA)-Lite-v$(VER).ex4"

$(OUT)/$(EA)-Advanced-%.ex4: \
		set-advanced \
		$(OUT)/$(EA).ex4 \
		set-none
	cp -v "$(EX4)" "$(OUT)/$(EA)-Advanced-v$(VER).ex4"

$(OUT)/$(EA)-Rider-%.ex4: \
		set-rider \
		$(OUT)/$(EA).ex4 \
		set-none
	cp -v "$(EX4)" "$(OUT)/$(EA)-Rider-v$(VER).ex4"

$(OUT)/$(EA)-Lite-Release-%.ex4: \
		set-lite-release \
		$(OUT)/$(EA).ex4 \
		set-none
	cp -v "$(EX4)" "$(OUT)/$(EA)-Lite-Release-v$(VER).ex4"

$(OUT)/$(EA)-Advanced-Release-%.ex4: \
		set-advanced-release \
		$(OUT)/$(EA).ex4 \
		set-none
	cp -v "$(EX4)" "$(OUT)/$(EA)-Advanced-Release-v$(VER).ex4"

$(OUT)/$(EA)-Rider-Release-%.ex4: \
		set-rider-release \
		$(OUT)/$(EA).ex4 \
		set-none
	cp -v "$(EX4)" "$(OUT)/$(EA)-Rider-Release-v$(VER).ex4"

$(OUT)/$(EA)-Lite-Backtest-%.ex4: \
		set-lite-backtest \
		$(OUT)/$(EA).ex4 \
		set-none
	cp -v "$(EX4)" "$(OUT)/$(EA)-Lite-Backtest-v$(VER).ex4"

$(OUT)/$(EA)-Advanced-Backtest-%.ex4: \
		set-advanced-backtest \
		$(OUT)/$(EA).ex4 \
		set-none
	cp -v "$(EX4)" "$(OUT)/$(EA)-Advanced-Backtest-v$(VER).ex4"

$(OUT)/$(EA)-Rider-Backtest-%.ex4: \
		set-rider-backtest \
		$(OUT)/$(EA).ex4 \
		set-none
	cp -v "$(EX4)" "$(OUT)/$(EA)-Rider-Backtest-v$(VER).ex4"


$(OUT)/$(EA).ex4: metaeditor.exe src/$(EA).mq4 src/include/EA31337/ea-mode.mqh
	SRC='$(SRC)'; wine metaeditor.exe /log:CON /compile:"$${SRC//\//\\}" /inc:"src" || true

$(OUT)/$(EA).ex5: metaeditor.exe src/$(EA).mq4 src/include/EA31337/ea-mode.mqh
	SRC='$(SRC)'; wine metaeditor.exe /log:CON /compile:"$${SRC//\//\\}" /inc:"src" || true

mt4-install:
		install -v "$(EX4)" "$(shell find ~/.wine -name terminal.exe -execdir pwd ';' -quit)/MQL4/Experts"

lite-license: compile-mql4 mt4-install
	:

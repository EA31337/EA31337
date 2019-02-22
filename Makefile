SHELL:=/usr/bin/env bash

.PHONY: all test compile-mql4 compile-mql5 requirements set-none \
		clean clean-src clean-releases \
		Backtest Lite-Backtest Advanced-Backtest Rider-Backtest \
		Full Lite-Full Advanced-Full Rider-Full \
		EA Lite Advanced Rider

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
EA:				Lite Advanced Rider

Lite-Backtest:			$(OUT)/$(EA)-Lite-Backtest-%.ex4
Advanced-Backtest:	$(OUT)/$(EA)-Advanced-Backtest-%.ex4
Rider-Backtest:			$(OUT)/$(EA)-Rider-Backtest-%.ex4
Backtest: 					Lite-Backtest Advanced-Backtest Rider-Backtest

Lite-Full: 		  $(OUT)/$(EA)-Lite-Full-%.ex4
Advanced-Full:  $(OUT)/$(EA)-Advanced-Full-%.ex4
Rider-Full: 		$(OUT)/$(EA)-Rider-Full-%.ex4
Full:						Lite-Full Advanced-Full Rider-Full

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
	@$(MAKE) -f $(FILE) set-mode MODE="__release__"

set-advanced: set-none
	@$(MAKE) -f $(FILE) set-mode MODE="__release__\|__advanced__"

set-rider: set-none
	@$(MAKE) -f $(FILE) set-mode MODE="__release__\|__rider__"

set-lite-backtest: set-none
	@$(MAKE) -f $(FILE) set-mode MODE="__release__\|__backtest__"

set-advanced-backtest: set-none
	@$(MAKE) -f $(FILE) set-mode MODE="__release__\|__backtest__\|__advanced__"

set-rider-backtest: set-none
	@$(MAKE) -f $(FILE) set-mode MODE="__release__\|__backtest__\|__rider__"

set-lite-full: set-none
	@$(MAKE) -f $(FILE) set-mode MODE="__release__"

set-advanced-full: set-none
	@$(MAKE) -f $(FILE) set-mode MODE="__release__\|__advanced__"

set-rider-full: set-none
	@$(MAKE) -f $(FILE) set-mode MODE="__release__\|__rider__"

set-testing:
	@$(MAKE) -f $(FILE) set-mode MODE="__testing__"

clean-all: clean-src

clean-src:
	@echo Cleaning src...
	find src/ '(' -name '*.ex4' -or -name '*.ex5' ')' -delete

release: metaeditor.exe \
		clean-all \
		$(OUT)/$(EA)-Lite-%.ex4 \
		$(OUT)/$(EA)-Advanced-%.ex4 \
		$(OUT)/$(EA)-Rider-%.ex4 \
		$(OUT)/$(EA)-Lite-Backtest-%.ex4 \
		$(OUT)/$(EA)-Advanced-Backtest-%.ex4 \
		$(OUT)/$(EA)-Rider-Backtest-%.ex4 \
		$(OUT)/$(EA)-Lite-Full-%.ex4 \
		$(OUT)/$(EA)-Advanced-Full-%.ex4 \
		$(OUT)/$(EA)-Rider-Full-%.ex4

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

$(OUT)/$(EA)-Lite-Full-%.ex4: \
		set-lite-full \
		$(OUT)/$(EA).ex4 \
		set-none
	cp -v "$(EX4)" "$(OUT)/$(EA)-Lite-Full-v$(VER).ex4"

$(OUT)/$(EA)-Advanced-Full-%.ex4: \
		set-advanced-full \
		$(OUT)/$(EA).ex4 \
		set-none
	cp -v "$(EX4)" "$(OUT)/$(EA)-Advanced-Full-v$(VER).ex4"

$(OUT)/$(EA)-Rider-Full-%.ex4: \
		set-rider-full \
		$(OUT)/$(EA).ex4 \
		set-none
	cp -v "$(EX4)" "$(OUT)/$(EA)-Rider-Full-v$(VER).ex4"

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

$(OUT)/$(EA).ex4: metaeditor.exe src/$(EA).mq4 src/include/EA31337/ea-mode.mqh
	SRC='$(SRC)'; wine metaeditor.exe /log:CON /compile:"$${SRC//\//\\}" /inc:"src" || true

$(OUT)/$(EA).ex5: metaeditor.exe src/$(EA).mq4 src/include/EA31337/ea-mode.mqh
	SRC='$(SRC)'; wine metaeditor.exe /log:CON /compile:"$${SRC//\//\\}" /inc:"src" || true

mt4-install:
		install -v "$(EX4)" "$(shell find ~/.wine -name terminal.exe -execdir pwd ';' -quit)/MQL4/Experts"

lite-license: compile-mql4 mt4-install
	:

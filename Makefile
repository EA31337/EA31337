SHELL:=/usr/bin/env bash

.PHONY: all test compile-mql4 compile-mql5 requirements \
		set-none set-testing \
		set-lite set-advanced set-rider \
		set-lite-release set-advanced-release set-rider-release \
		set-lite-backtest set-advanced-backtest set-rider-backtest \
		set-lite-optimize set-advanced-optimize set-rider-optimize \
		clean clean-src clean-releases \
		EA Lite Advanced Rider \
		Release Lite-Release Advanced-Release Rider-Release \
		Backtest Lite-Backtest Advanced-Backtest Rider-Backtest \
		Optimize Lite-Optimize Advanced-Optimize Rider-Optimize \
		All Lite-All Advanced-All Rider-All

MTE=metaeditor64.exe
MTV=5.0.0.2280
SRC=src
MQL4=$(wildcard $(SRC)/*.mq4)
MQL5=$(wildcard $(SRC)/*.mq5)
EA=EA31337
EX4=$(SRC)/$(EA).ex4
EX5=$(SRC)/$(EA).ex5
VER=v$(shell grep 'define ea_version' $(SRC)/include/EA31337/ea-properties.mqh | grep -o '[0-9].*[0-9]')
FILE=$(lastword $(MAKEFILE_LIST)) # Determine this Makefile's path.
OUT=.
MKFILE=$(abspath $(lastword $(MAKEFILE_LIST)))
CWD=$(notdir $(patsubst %/,%,$(dir $(MKFILE))))
WINEDEBUG=fixme-all

requirements:
	type -a git ex wine64 &> /dev/null

Lite:								$(OUT)/$(EA)-Lite-%.ex4
Advanced:						$(OUT)/$(EA)-Advanced-%.ex4
Rider:							$(OUT)/$(EA)-Rider-%.ex4

Lite-Release: 			$(OUT)/$(EA)-Lite-Release-%.ex4
Advanced-Release:		$(OUT)/$(EA)-Advanced-Release-%.ex4
Rider-Release:			$(OUT)/$(EA)-Rider-Release-%.ex4

Lite-Backtest:			$(OUT)/$(EA)-Lite-Backtest-%.ex4
Advanced-Backtest:	$(OUT)/$(EA)-Advanced-Backtest-%.ex4
Rider-Backtest:			$(OUT)/$(EA)-Rider-Backtest-%.ex4

Lite-Optimize:			$(OUT)/$(EA)-Lite-Optimize-%.ex4
Advanced-Optimize:	$(OUT)/$(EA)-Advanced-Optimize-%.ex4
Rider-Optimize:			$(OUT)/$(EA)-Rider-Optimize-%.ex4

Lite-All:						Lite Lite-Release Lite-Backtest Lite-Optimize
Advanced-All:				Advanced Advanced-Release Advanced-Backtest Advanced-Optimize
Rider-All:					Rider Rider-Release Rider-Backtest Rider-Optimize

All:								requirements $(MTE) Lite-All Advanced-All Rider-All

test: requirements set-mode $(MTE)
	wine64 $(MTE) .exe /s /i:$(SRC) /mql4 $(MQL4)
	wine64 $(MTE) /s /i:$(SRC) /mql5 $(MQL4)

$(MTE):
	curl -LO https://github.com/EA31337/MT-Platforms/releases/download/$(MTV)/mt-$(MTV).zip
	unzip mt-$(MTV).zip */$(MTE)
	cp -v */$(MTE) .

# E.g.: make set-mode MODE="__advanced__"
set-mode:
ifdef MODE
	test -w .git && git checkout -- $(SRC)/include/EA31337/ea-mode.mqh || true
	ex +"%s@^\zs.*\ze#define \($(MODE)\)@@g" -scwq! $(SRC)/include/EA31337/ea-mode.mqh
endif

set-none:
	@echo Reverting modes.
	test -w .git && git checkout -- $(SRC)/include/EA31337/ea-mode.mqh || true
	ex +":g@^#define@s@^@//" -scwq! $(SRC)/include/EA31337/ea-mode.mqh

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

set-lite-optimize: set-none
	@$(MAKE) -f $(FILE) set-mode MODE="__optimize__"

set-advanced-optimize: set-none
	@$(MAKE) -f $(FILE) set-mode MODE="__optimize__\|__advanced__"

set-rider-optimize: set-none
	@$(MAKE) -f $(FILE) set-mode MODE="__optimize__\|__rider__"

set-testing:
	@$(MAKE) -f $(FILE) set-mode MODE="__testing__"

clean-all: clean-src

clean-src:
	@echo Cleaning src...
	find $(SRC)/ -maxdepth 1 '(' -name '*.ex4' -or -name '*.ex5' ')' -delete -print

EA: $(MTE) \
		clean-all \
		$(OUT)/$(EA)-Lite-%.ex4 \
		$(OUT)/$(EA)-Advanced-%.ex4 \
		$(OUT)/$(EA)-Rider-%.ex4

Release: $(MTE) \
		clean-all \
		$(OUT)/$(EA)-Lite-Release-%.ex4 \
		$(OUT)/$(EA)-Advanced-Release-%.ex4 \
		$(OUT)/$(EA)-Rider-Release-%.ex4

Backtest: $(MTE) \
		clean-all \
		$(OUT)/$(EA)-Lite-Backtest-%.ex4 \
		$(OUT)/$(EA)-Advanced-Backtest-%.ex4 \
		$(OUT)/$(EA)-Rider-Backtest-%.ex4

Optimize: $(MTE) \
		clean-all \
		$(OUT)/$(EA)-Lite-Optimize-%.ex4 \
		$(OUT)/$(EA)-Advanced-Optimize-%.ex4 \
		$(OUT)/$(EA)-Rider-Optimize-%.ex4

compile-mql4: requirements $(MTE) $(SRC)/$(EA).mq4 $(SRC)/include/EA31337/ea-mode.mqh clean-src
	file='$(MQL4)'; wine64 $(MTE) /log:CON /compile:"$${file//\//\\}" /inc:"$(SRC)" || true
	test -s $(SRC)/$(EA).ex4 && echo $(MQL4) compiled.

compile-mql5: requirements $(MTE) $(SRC)/$(EA).mq4 $(SRC)/include/EA31337/ea-mode.mqh clean-src
	file='$(MQL5)'; wine64 $(MTE) /log:CON /compile:"$${file//\//\\}" /inc:"$(SRC)" || true
	test -s $(SRC)/$(EA).ex5 && @echo $(MQL5) compiled.

$(OUT)/$(EA)-Lite-%.ex4: \
		set-lite \
		compile-mql4 \
		set-none
		cp -v "$(EX4)" "$(OUT)/$(EA)-Lite-$(VER).ex4"

$(OUT)/$(EA)-Advanced-%.ex4: \
		set-advanced \
		compile-mql4 \
		set-none
		cp -v "$(EX4)" "$(OUT)/$(EA)-Advanced-$(VER).ex4"

$(OUT)/$(EA)-Rider-%.ex4: \
		set-rider \
		compile-mql4 \
		set-none
		cp -v "$(EX4)" "$(OUT)/$(EA)-Rider-$(VER).ex4"

$(OUT)/$(EA)-Lite-Release-%.ex4: \
		set-lite-release \
		compile-mql4 \
		set-none
		cp -v "$(EX4)" "$(OUT)/$(EA)-Lite-Release-$(VER).ex4"

$(OUT)/$(EA)-Advanced-Release-%.ex4: \
		set-advanced-release \
		compile-mql4 \
		set-none
		cp -v "$(EX4)" "$(OUT)/$(EA)-Advanced-Release-$(VER).ex4"

$(OUT)/$(EA)-Rider-Release-%.ex4: \
		set-rider-release \
		compile-mql4 \
		set-none
		cp -v "$(EX4)" "$(OUT)/$(EA)-Rider-Release-$(VER).ex4"

$(OUT)/$(EA)-Lite-Backtest-%.ex4: \
		set-lite-backtest \
		compile-mql4 \
		set-none
		cp -v "$(EX4)" "$(OUT)/$(EA)-Lite-Backtest-$(VER).ex4"

$(OUT)/$(EA)-Advanced-Backtest-%.ex4: \
		set-advanced-backtest \
		compile-mql4 \
		set-none
		cp -v "$(EX4)" "$(OUT)/$(EA)-Advanced-Backtest-$(VER).ex4"

$(OUT)/$(EA)-Rider-Backtest-%.ex4: \
		set-rider-backtest \
		compile-mql4 \
		set-none
		cp -v "$(EX4)" "$(OUT)/$(EA)-Rider-Backtest-$(VER).ex4"

$(OUT)/$(EA)-Lite-Optimize-%.ex4: \
		set-lite-optimize \
		compile-mql4 \
		set-none
		cp -v "$(EX4)" "$(OUT)/$(EA)-Lite-Optimize-$(VER).ex4"

$(OUT)/$(EA)-Advanced-Optimize-%.ex4: \
		set-advanced-optimize \
		compile-mql4 \
		set-none
		cp -v "$(EX4)" "$(OUT)/$(EA)-Advanced-Optimize-$(VER).ex4"

$(OUT)/$(EA)-Rider-Optimize-%.ex4: \
		set-rider-optimize \
		compile-mql4 \
		set-none
		cp -v "$(EX4)" "$(OUT)/$(EA)-Rider-Optimize-$(VER).ex4"

mt4-install:
		install -v "$(EX4)" "$(shell find ~/.wine -name terminal.exe -execdir pwd ';' -quit)/MQL4/Experts"

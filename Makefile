.PHONY: all test mql4 mql5 requirements set-none \
		Lite Advanced Rider
MQL=mql.exe
SRC=$(wildcard src/*.mq4)
EA=EA31337
EX4="src/$(EA).ex4"
EX5="src/$(EA).ex5"
VER=$(shell grep 'define ea_version' src/include/EA/ea-properties.mqh | grep -o '[0-9].*[0-9]')
FILE=$(lastword $(MAKEFILE_LIST)) # Determine this Makefile's path.
OUT=releases
MKFILE=$(abspath $(lastword $(MAKEFILE_LIST)))
CWD=$(notdir $(patsubst %/,%,$(dir $(MKFILE))))
all: requirements $(MQL) compile-mql4

requirements:
	type -a git ex wine 2> /dev/null

Lite: 		$(OUT)/$(EA)-Lite-%.ex4
Advanced: $(OUT)/$(EA)-Advanced-%.ex4
Rider: 		$(OUT)/$(EA)-Rider-%.ex4

Lite-Backtest:			$(OUT)/$(EA)-Lite-Backtest-%.ex4
Advanced-Backtest:	$(OUT)/$(EA)-Advanced-Backtest-%.ex4
Rider-Backtest:			$(OUT)/$(EA)-Rider-Backtest-%.ex4
Backtest: Lite-Backtest Advanced-Backtest Rider-Backtest

Lite-Full: 		  $(OUT)/$(EA)-Lite-Full-%.ex4
Advanced-Full:  $(OUT)/$(EA)-Advanced-Full-%.ex4
Rider-Full: 		$(OUT)/$(EA)-Rider-Full-%.ex4

compile-mql4: requirements $(MQL) clean src/%.ex4
	@$(MAKE) -f $(FILE) set-none
	@echo MQL4 compiled.
mql5: requirements $(MQL) clean src/%.ex5
	@$(MAKE) -f $(FILE) set-none
	@echo MQL5 compiled.

test: requirements set-mode $(MQL)
	wine mql.exe /s /i:src /mql4 $(SRC)
	wine mql.exe /s /i:src /mql5 $(SRC)

src/$(EA).ex4:
	wine mql.exe /o /i:src /mql4 $(SRC)
	@$(MAKE) -f $(FILE) set-none

src/$(EA).ex5:
	wine mql.exe /o /i:src /mql5 $(SRC)
	@$(MAKE) -f $(FILE) set-none

#mql.exe:
#  curl -O http://files.metaquotes.net/metaquotes.software.corp/mt5/mql.exe

# E.g.: make set-mode MODE="__advanced__"
set-mode:
ifdef MODE
	git checkout -- src/include/EA/ea-mode.mqh
	ex -s +"%s@^\zs.*\ze#define \($(MODE)\)@@g" -cwq src/include/EA/ea-mode.mqh
endif

set-none:
	@echo Reverting modes.
	git checkout -- src/include/EA/ea-mode.mqh
	ex -s +":g@^#define@s@^@//" -cwq src/include/EA/ea-mode.mqh

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
	@$(MAKE) -f $(FILE) set-mode MODE="__release__\|__nolicense__"

set-advanced-full: set-none
	@$(MAKE) -f $(FILE) set-mode MODE="__release__\|__nolicense__\|__advanced__"

set-rider-full: set-none
	@$(MAKE) -f $(FILE) set-mode MODE="__release__\|__nolicense__\|__rider__"

clean: set-none
	@echo Cleaning...
	find src/ '(' -name '*.ex4' -or -name '*.ex5' ')' -delete

release: mql.exe \
		clean \
		$(OUT)/$(EA)-Lite-Backtest-%.ex4 \
		$(OUT)/$(EA)-Advanced-Backtest-%.ex4 \
		$(OUT)/$(EA)-Rider-Backtest-%.ex4
		# @echo Making release...
		# git --git-dir=$(OUT)/.git add -v -A
		# $(eval GIT_EXTRAS := $(shell git --git-dir=$(OUT)/.git tag "v$(VER)" || echo "--amend"))
		# @echo $(GIT_EXTRAS)
		# git --git-dir=$(OUT)/.git commit -v -m "$(EA) v${VER} released." -a $(GIT_EXTRAS)
		# git --git-dir=$(OUT)/.git tag -f "v$(VER)"
		# eval $(shell cd $(OUT) && sha1sum *.* > .files.crc)
		# @$(MAKE) -f $(FILE) set-none
		# @echo "$(EA) v${VER} released."

$(OUT)/$(EA)-Lite-Backtest-%.ex4: clean set-lite-backtest src/$(EA).ex4
	cp -v "$(EX4)" "$(OUT)/$(EA)-Lite-Backtest-v$(VER).ex4"

$(OUT)/$(EA)-Advanced-Backtest-%.ex4: clean set-advanced-backtest src/$(EA).ex4
	cp -v "$(EX4)" "$(OUT)/$(EA)-Advanced-Backtest-v$(VER).ex4"

$(OUT)/$(EA)-Rider-Backtest-%.ex4: clean set-rider-backtest src/$(EA).ex4
	cp -v "$(EX4)" "$(OUT)/$(EA)-Rider-Backtest-v$(VER).ex4"

$(OUT)/$(EA)-Lite-Full-%.ex4: clean set-lite-full src/$(EA).ex4
	cp -v "$(EX4)" "$(OUT)/$(EA)-Lite-Full-v$(VER).ex4"

$(OUT)/$(EA)-Advanced-Full-%.ex4: clean set-advanced-full src/$(EA).ex4
	cp -v "$(EX4)" "$(OUT)/$(EA)-Advanced-Full-v$(VER).ex4"

$(OUT)/$(EA)-Rider-Full-%.ex4: clean set-rider-full src/$(EA).ex4
	cp -v "$(EX4)" "$(OUT)/$(EA)-Rider-Full-v$(VER).ex4"

$(OUT)/$(EA)-Lite-%.ex4: clean set-lite src/$(EA).ex4
	cp -v "$(EX4)" "$(OUT)/$(EA)-Lite-v$(VER).ex4"

$(OUT)/$(EA)-Advanced-%.ex4: clean set-advanced src/$(EA).ex4
	cp -v "$(EX4)" "$(OUT)/$(EA)-Advanced-v$(VER).ex4"

$(OUT)/$(EA)-Rider-%.ex4: clean set-rider src/$(EA).ex4
	cp -v "$(EX4)" "$(OUT)/$(EA)-Rider-v$(VER).ex4"

mt4-install:
		install -v "$(EX4)" "$(shell find ~/.wine -name terminal.exe -execdir pwd ';' -quit)/MQL4/Experts"

lite-license: compile-mql4 mt4-install
	:

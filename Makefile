MQL=mql.exe
SRC=$(wildcard src/*.mq4)
EA="EA31337"
EX4="src/$(EA).ex4"
EX5="src/$(EA).ex5"
VER=$(shell grep 'define ea_version' src/include/EA/ea-properties.mqh | grep -o '[0-9].*[0-9]')
FILE=$(lastword $(MAKEFILE_LIST)) # Determine this makefile's path.
OUT="releases"
MKFILE=$(abspath $(lastword $(MAKEFILE_LIST)))
CWD=$(notdir $(patsubst %/,%,$(dir $(MKFILE))))
all: requirements $(MQL) mql4

requirements:
	type -a git
	type -a ex
	type -a wine

lite: 		set-lite 		 mql4 set-none
advanced: set-advanced mql4 set-none
rider: 		set-rider 	 mql4 set-none

mql4: requirements $(MQL) clean src/%.ex4
	@echo MQL4 compiled.
mql5: requirements $(MQL) clean src/%.ex5
	@echo MQL5 compiled.

test: requirements set-mode $(MQL)
	wine mql.exe /s /i:src /mql4 $(SRC)
	wine mql.exe /s /i:src /mql5 $(SRC)

src/%.ex4: set-mode $(SRC)
	wine mql.exe /o /i:src /mql4 $(SRC)

src/%.ex5: set-mode $(SRC)
	wine mql.exe /o /i:src /mql5 $(SRC)

#mql.exe:
#  curl -O http://files.metaquotes.net/metaquotes.software.corp/mt5/mql.exe

# E.g.: make set-mode MODE="__advanced__"
set-mode:
ifdef MODE
	git checkout -- src/include/EA/ea-mode.mqh
	ex -s +"%s@^\zs.*\ze#define \($(MODE)\)@@g" -cwq src/include/EA/ea-mode.mqh
endif

set-none:
	git checkout -- src/include/EA/ea-mode.mqh
	ex -s +":g@^#define@s@^@//" -cwq src/include/EA/ea-mode.mqh

set-lite: set-none
	@$(MAKE) -f $(FILE) set-mode MODE="__release__\|__backtest__"

set-advanced: set-none
	@$(MAKE) -f $(FILE) set-mode MODE="__release__\|__backtest__\|__advanced__"

set-rider: set-none
	@$(MAKE) -f $(FILE) set-mode MODE="__release__\|__backtest__\|__rider__"

set-lite-nolicense: set-none
	@$(MAKE) -f $(FILE) set-mode MODE="__release__\|__nolicense__"

set-advanced-nolicense: set-none
	@$(MAKE) -f $(FILE) set-mode MODE="__release__\|__nolicense__\|__advanced__"

set-rider-nolicense: set-none
	@$(MAKE) -f $(FILE) set-mode MODE="__release__\|__nolicense__\|__rider__"

clean:
	@echo Cleaning...
	find src/ '(' -name '*.ex4' -or -name '*.ex5' ')' -delete

release: mql.exe \
		clean \
		$(OUT)/$(EA)-Lite-Backtest-%.ex4 \
		$(OUT)/$(EA)-Advanced-Backtest-%.ex4 \
		$(OUT)/$(EA)-Rider-Backtest-%.ex4
		@echo Making release...
		git --git-dir=$(OUT)/.git add -v -A
		$(eval GIT_EXTRAS := $(shell git --git-dir=$(OUT)/.git tag "v$(VER)" || echo "--amend"))
		@echo $(GIT_EXTRAS)
		git --git-dir=$(OUT)/.git commit -v -m "$(EA) v${VER} released." -a $(GIT_EXTRAS)
		git --git-dir=$(OUT)/.git tag -f "v$(VER)"
		eval $(shell cd $(OUT) && sha1sum *.* > .files.crc)
		@$(MAKE) -f $(FILE) set-none
		@echo "$(EA) v${VER} released."

$(OUT)/$(EA)-Lite-Backtest-%.ex4: set-lite
	wine mql.exe /o /i:src /mql4 $(SRC) && cp -v "$(EX4)" "$(OUT)/$(EA)-Lite-Backtest-v$(VER).ex4"

$(OUT)/$(EA)-Advanced-Backtest-%.ex4: set-advanced
	wine mql.exe /o /i:src /mql4 $(SRC) && cp -v "$(EX4)" "$(OUT)/$(EA)-Advanced-Backtest-v$(VER).ex4"

$(OUT)/$(EA)-Rider-Backtest-%.ex4: set-rider
	wine mql.exe /o /i:src /mql4 $(SRC) && cp -v "$(EX4)" "$(OUT)/$(EA)-Rider-Backtest-v$(VER).ex4"

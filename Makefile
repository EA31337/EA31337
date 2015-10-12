MQL=mql.exe
SRC=$(wildcard src/*.mq4)
MQL=./mql.exe
ifneq (,$(findstring /cygdrive/,$(PATH)))
	WINE=
else
	WINE=wine
endif

EA="EA31337"
EX4="src/$(EA).ex4"
EX5="src/$(EA).ex5"
VER=$(shell grep 'define ea_version' src/include/EA/ea-properties.mqh | grep -o '[0-9].*[0-9]')
FILE := $(lastword $(MAKEFILE_LIST)) # Determine this makefile's path.
OUT="releases"
all: requirements $(MQL) mql4

requirements:
	type -a git
	type -a ex
	type -a wine

mql4: requirements $(MQL) src/%.ex4
mql5: requirements $(MQL) src/%.ex5

test: requirements set-mode $(MQL)
	$(WINE) $(MQL) /s /i:src /mql4 $(SRC)
	$(WINE) $(MQL) /s /i:src /mql5 $(SRC)

src/%.ex4: set-mode $(SRC)
	$(WINE) $(MQL) /i:src /mql4 $(SRC)

src/%.ex5: set-mode $(SRC)
	sed -i  's/Open\[\([^]]*\)\]/GetOpen(\1)/g' $(SRC)
	sed -i  's/Close\[\([^]]*\)\]/GetClose(\1)/g' $(SRC)
	sed -i  's/Low\[\([^]]*\)\]/GetLow(\1)/g' $(SRC)
	sed -i  's/High\[\([^]]*\)\]/GetHigh(\1)/g' $(SRC)
	sed -i  's/Volume\[\([^]]*\)\]/GetVolume(\1)/g' $(SRC)
	sed -i  's/\[\]\[\]\[\]/ ARRAY_INDEX_3D/g' $(SRC)
	sed -i  's/\[\]\[\]/ ARRAY_INDEX_2D/g' $(SRC)
	$(WINE) $(MQL) /i:src /mql5 $(SRC)

mql.exe:
	curl -O http://files.metaquotes.net/metaquotes.software.corp/mt5/mql.exe

set-mode:
# E.g.: make set-mode MODE="__advanced__"
ifdef MODE
	git checkout -- src/include/EA/ea-mode.mqh
	ex -s +"%s@^\zs.*\ze#define \($(MODE)\)@@g" -cwq src/include/EA/ea-mode.mqh
endif

clean:
	find . '(' -name '*.ex4' -or -name '*.ex5' ')' -delete

release: mql.exe \
		clean \
		releases/$(EA)-Backtest-Lite-%.ex4 \
		releases/$(EA)-Backtest-Advanced-%.ex4 \
		releases/$(EA)-Backtest-Rider-%.ex4
	git --git-dir=releases/.git add -v -A
	git --git-dir=releases/.git commit -v -m "$(EA) v${VER} released." -a
	git --git-dir=releases/.git tag -f "v$(VER)"
	@echo "$(EA) v${VER} released."

releases/$(EA)-Backtest-Lite-%.ex4:
	@$(MAKE) -f $(FILE) set-mode MODE="__release__\|__backtest__"
	wine mql.exe /o /i:src /mql4 $(SRC) && cp -v "$(EX4)" "$(OUT)/$(EA)-Backtest-Lite-v$(VER).ex4"

releases/$(EA)-Backtest-Advanced-%.ex4:
	@$(MAKE) -f $(FILE) set-mode MODE="__release__\|__backtest__\|__advanced__"
	wine mql.exe /o /i:src /mql4 $(SRC) && cp -v "$(EX4)" "$(OUT)/$(EA)-Backtest-Advanced-v$(VER).ex4"

releases/$(EA)-Backtest-Rider-%.ex4:
	@$(MAKE) -f $(FILE) set-mode MODE="__release__\|__backtest__\|__rider__"
	wine mql.exe /o /i:src /mql4 $(SRC) && cp -v "$(EX4)" "$(OUT)/$(EA)-Backtest-Rider-v$(VER).ex4"

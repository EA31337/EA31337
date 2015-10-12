SRC=$(wildcard src/*.mq4)
MQL=./mql.exe
ifneq (,$(findstring /cygdrive/,$(PATH)))
	WINE=
else
	WINE=wine
endif

all: $(MQL) mql4

mql4: $(MQL) src/%.ex4
mql5: $(MQL) src/%.ex5

test: set-mode $(MQL)
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
ifdef MODE
	git checkout -- src/include/EA/ea-mode.mqh
	ex -s +"%s@^\zs.*\ze#define \($(MODE)\)@@g" -cwq src/include/EA/ea-mode.mqh
endif

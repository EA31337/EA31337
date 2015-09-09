SRC=$(wildcard src/*.mq4)
MQL=mql.exe
all: $(MQL) mql4

mql4: $(MQL) src/%.ex4
mql5: $(MQL) src/%.ex5

test: set-mode $(MQL)
	wine mql.exe /s /i:src /mql4 $(SRC)
	wine mql.exe /s /i:src /mql5 $(SRC)

src/%.ex4: set-mode $(SRC)
	wine mql.exe /i:src /mql4 $(SRC)

src/%.ex5: set-mode $(SRC)
	wine mql.exe /i:src /mql5 $(SRC)

mql.exe:
	curl -O http://files.metaquotes.net/metaquotes.software.corp/mt5/mql.exe

set-mode:
ifdef MODE
	git checkout -- src/include/EA/ea-mode.mqh
	ex -s +"%s@^\zs.*\ze#define \($(MODE)\)@@g" -cwq src/include/EA/ea-mode.mqh
endif

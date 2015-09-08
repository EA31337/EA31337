SRC=$(wildcard src/*.mq4)
all: mql.exe src/%.ex4

test: mql.exe
	wine mql.exe /s /i:src /mql4 $(SRC)

src/%.ex4: $(SRC)
	wine mql.exe /i:src /mql4 $(SRC)

mql.exe:
	curl -O http://files.metaquotes.net/metaquotes.software.corp/mt5/mql.exe

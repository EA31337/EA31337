Set-ExecutionPolicy RemoteSigned -scope CurrentUser
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
scoop update
scoop install ruby python
Invoke-WebRequest -Uri https://github.com/EA31337/MetaEditor/raw/master/metaeditor64.exe -OutFile metaeditor64.exe
./metaeditor64.exe /s /compile:. /log:mql.log
# ruby -e "if File.open('mql.log', mode:'rb:BOM|UTF-16LE').readlines.grep(Regexp.new '[1-9] error'.encode(Encoding::UTF_16LE)) {exit 1}; end"
# ruby -e "if File.open('mql.log', mode:'rb:BOM|UTF-16LE').readlines.grep(Regexp.new '[1-9] warning'.encode(Encoding::UTF_16LE)) {exit 1}; end"
# ruby -e "if File.open('mql.log', mode:'rb:BOM|UTF-16LE').readlines.grep(Regexp.new '[1-9][0-9] error'.encode(Encoding::UTF_16LE)) {exit 1}; end"
# ruby -e "if File.open('mql.log', mode:'rb:BOM|UTF-16LE').readlines.grep(Regexp.new '[1-9][0-9] warning'.encode(Encoding::UTF_16LE)) {exit 1}; end"

Set-ExecutionPolicy RemoteSigned -scope CurrentUser
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
scoop update
scoop install ruby python
Invoke-WebRequest -Uri https://github.com/EA31337/MetaEditor/raw/master/metaeditor64.exe -OutFile metaeditor64.exe
./metaeditor64.exe /s /compile:"tests" /log:mql.log
type mql.log

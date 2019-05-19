$timestamp = $(Get-Date -UFormat "+%Y%m%d%H%M%S")
mkdir "build/build$timestamp"
mkdir "build/build$timestamp/levelpack"
cp -r tools build/build$timestamp
cd game
& "E:\programs\Steam\steamapps\common\Godot Engine\godot.windows.opt.tools.64.exe" --export "Windows Desktop" "../build/build$timestamp/game.exe"
cd ../build
Compress-Archive -Path build$timestamp -DestinationPath build$timestamp.zip
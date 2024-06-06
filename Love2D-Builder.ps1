$Prefix = "[Love2D Project Builder]"
Write-Host("$Prefix Love2D Project Builder Starting") -ForegroundColor DarkGreen

#grab project path
Write-Host("$Prefix Enter path of project to build: ") -ForegroundColor DarkGreen
$ProjectPath = Read-Host

#check for main.lua
$MainFile = $ProjectPath + "\main.lua"
if (-Not (Test-Path -Path $MainFile)) {
    Write-Host("$Prefix Error: No main.lua file found in project path. Exiting...") -ForegroundColor DarkGreen
    exit
}

#grab Love2D path
$LovePath = "C:\Program Files\LOVE"
if (-Not (Test-Path -Path $LovePath)) {
    Write-Host("$Prefix Enter Love2D install path: ") -ForegroundColor DarkGreen
    $LovePath = Read-Host
}

#grab build name, create folder
Write-Host("$Prefix Enter build name: ") -ForegroundColor DarkGreen
$Name = Read-Host
$BuildPath = (Get-Item $ProjectPath).parent.FullName + "\Builds\" + (Get-Date -Format "yyyyMMddTHHmmssffff")
Write-Host("$Prefix Creating build folder [$BuildPath] ...") -ForegroundColor DarkGreen
$BuildsFolderPath = (Get-Item $ProjectPath).parent.FullName + "\Builds"
if (-Not (Test-Path -Path $BuildsFolderPath)) {
    $TempPath = Split-Path (Split-Path $BuildPath -Parent) -Leaf
    New-Item -Path (Get-Item $ProjectPath).parent.FullName -Name $TempPath -ItemType "directory" | Out-Null
}
$TempPath = Split-Path $BuildPath -Leaf
New-Item -Path $BuildsFolderPath -Name $TempPath -ItemType "directory" | Out-Null

#compress project files
Write-Host("$Prefix Creating project executable file...") -ForegroundColor DarkGreen
$ZipFile = $BuildPath + "\" +  $Name + ".zip"
$ZipSource = $ProjectPath + "\*"
Compress-Archive -Path $ZipSource -DestinationPath $ZipFile

#rename archive to .love
$LoveFile = $BuildPath + "\" + $Name + ".love"
Rename-Item -Path $ZipFile -NewName $LoveFile

#merge love file and love2D executable
$LoveExecutable = $LovePath + "\love.exe"
$Executable = $BuildPath + "\" + $Name + ".exe"
Get-Content $LoveExecutable,$LoveFile -Encoding Byte | Set-Content $Executable -Encoding Byte

#delete love file
Remove-Item $LoveFile

#copy in dlls, license
Write-Host("$Prefix Copying dlls...") -ForegroundColor DarkGreen
Copy-Item -Path ($LovePath + "\*.dll") -Destination $BuildPath
Copy-Item -Path ($LovePath + "\license.txt") -Destination $BuildPath

#prompt to zip
Write-Host("$Prefix Create build zip? y/n") -ForegroundColor DarkGreen
$confirmation = Read-Host 
if ($confirmation -eq 'y') {
    $ZipSource = $BuildPath + "\*"
    Write-Host("$Prefix Compressing build...") -ForegroundColor DarkGreen
    Compress-Archive -Path $ZipSource -DestinationPath $ZipFile
}

Write-Host("$Prefix Process complete. Press ENTER to open directory") -ForegroundColor DarkGreen
Read-Host
Invoke-Item $BuildPath
exit
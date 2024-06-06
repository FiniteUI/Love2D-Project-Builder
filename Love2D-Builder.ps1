Write-Output("-Love2D Project Builder-")

#grab project path
$ProjectPath = Read-Host "Enter path of project to build: "

#grab Love2D path
$LovePath = "C:\Program Files\LOVE"
if (-Not (Test-Path -Path $LovePath)) {
    $LovePath = Read-Host "Enter Love2D install path: "
}

#grab build name, create folder
$Name = Read-Host "Enter build name: "
$BuildPath = (Get-Item $ProjectPath).parent.FullName + "\Builds\" + $Name + "-" + (Get-Date -Format "yyyyMMddTHHmmssffff")
Write-Output("Creating build folder [$BuildPath] ...")
$BuildsFolderPath = (Get-Item $ProjectPath).parent.FullName + "\Builds"
if (-Not (Test-Path -Path $BuildsFolderPath)) {
    $TempPath = Split-Path (Split-Path $BuildPath -Parent) -Leaf
    New-Item -Path (Get-Item $ProjectPath).parent.FullName -Name $TempPath -ItemType "directory" | Out-Null
}
$TempPath = Split-Path $BuildPath -Leaf
New-Item -Path $BuildsFolderPath -Name $TempPath -ItemType "directory" | Out-Null

#compress project files
Write-Output("Creating project executable file...")
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
Write-Output("Copying dlls...")
Copy-Item -Path ($LovePath + "\*.dll") -Destination $BuildPath
Copy-Item -Path ($LovePath + "\license.txt") -Destination $BuildPath

#prompt to zip
$confirmation = Read-Host "Create build zip? y/n"
if ($confirmation -eq 'y') {
    $ZipSource = $BuildPath + "\*"
    Write-Output("Compressing build...")
    Compress-Archive -Path $ZipSource -DestinationPath $ZipFile
}

Read-Host "Process complete. Press ENTER to open directory"
Invoke-Item $BuildPath
exit
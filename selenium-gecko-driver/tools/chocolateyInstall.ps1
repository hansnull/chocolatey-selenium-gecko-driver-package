$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$toolsLocation = Get-ToolsLocation
$seleniumDir = "$toolsLocation\selenium"
$driverPath = "$seleniumDir\geckodriver.exe"

$parameters = Get-PackageParameters

$packageArgs = @{
  packageName    = 'selenium-gecko-driver'
  url            = 'https://github.com/mozilla/geckodriver/releases/download/v0.29.0/geckodriver-v0.29.0-win32.zip'
  checksum       = '8128C52E8CF1F0813C942BC49CE8808AB9EE62A26F92AC29767ABDAEDCE335FCA137CE59456C7AA95B735FEABB095CD89946303E0360197CA1014725A9C79FFF'
  checksumType   = 'sha512'
  url64bit       = 'https://github.com/mozilla/geckodriver/releases/download/v0.29.0/geckodriver-v0.29.0-win64.zip'
  checksum64     = 'B105178A2C89C60ACA2A79D9243D8364DC90F263BA0D51CD474FE2A1547ACBD7AADD85B0AC8644CA35B0D154462C351BB97967003A88EF3959C528DF6CD7D7DE'
  checksumType64 = 'sha512'
  unzipLocation  = $seleniumDir
}
Install-ChocolateyZipPackage @packageArgs

Uninstall-BinFile -Name 'geckodriver'
If ($parameters['SkipShim'] -ne 'true') {
  Install-BinFile -Name 'geckodriver' -Path $driverPath
}

$menuPrograms = [environment]::GetFolderPath([environment+specialfolder]::Programs)
$shortcutArgs = @{
  shortcutFilePath = "$menuPrograms\Selenium\Selenium Gecko Driver.lnk"
  targetPath       = $driverPath
  iconLocation     = "$toolsDir\icon.ico"
}
Install-ChocolateyShortcut @shortcutArgs

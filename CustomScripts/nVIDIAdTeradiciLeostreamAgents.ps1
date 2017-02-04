<# Install NVIDIA Drivers, PCOIP Agent and download Leostream Agent/OpendTect #>
<#param (
    [string]$leostreamAgentVer,
    [string]$teradiciAgentVer,
    [string]$nvidiaVer,	
    [string]$storageAcc,
    [string]$conName
)
#>
<#
$dest = "C:\Downloadinstallers"
$leostreamAgentVer = $Args[0]
$teradiciAgentVer = "2.7.0.3589"
$nvidiaVer = "369.71"
$storageAcc = "tdcm16sg112leo8193ls102"
$conName = "tdcm16sg112leo8193ls102"
#>
$dest = "C:\Downloadinstallers\"
$leostreamAgentVer = $args[0]
$teradiciAgentVer = $args[1]
$nvidiaVer = $args[2]
$storageAcc = $args[3]
$conName = $args[4]
$license = $args[5]
$registryPath = "HKLM:\Software\Teradici\PCoIP"
$Name = "pcoip_admin"
$value = "8"
$Date = Get-Date
<#
Write-Host "You inputs are '$leostreamAgentVer' and '$teradiciAgentVer' with '$nvidiaVer', '$storageAcc', '$conName', '$license'  on '$Date'"

New-Item -Path $dest -ItemType directory

wget https://teradicidemopackages.blob.core.windows.net/packages/Unigine_Heaven-4.0.zip -OutFile C:\Downloadinstallers\Unigine_Heaven-4.0.zip
wget https://teradicidemopackages.blob.core.windows.net/packages/Tetra4D.zip -OutFile C:\Downloadinstallers\Tetra4D.zip
wget https://teradicidemopackages.blob.core.windows.net/packages/Unity_Turbine.zip -OutFile C:\Downloadinstallers\Unity_Turbine.zip

wget https://$storageAcc.blob.core.windows.net/$conName/"$nvidiaVer"_grid_win10_server2016_64bit_international.exe -OutFile C:\Downloadinstallers\"$nvidiaVer"_grid_win10_server2016_64bit_international.exe
wget http://download.opendtect.org/relman/OpendTect_Installer_win64.exe -OutFile C:\Downloadinstallers\OpendTect_Installer_win64.exe
wget https://$storageAcc.blob.core.windows.net/$conName/PCoIP_agent_release_installer_"$teradiciAgentVer"_graphics.exe -OutFile C:\Downloadinstallers\PCoIP_agent_release_installer_"$teradiciAgentVer"_graphics.exe

wget https://$storageAcc.blob.core.windows.net/$conName/LeostreamAgentSetup$leostreamAgentVer.exe -OutFile C:\Downloadinstallers\LeostreamAgentSetup$leostreamAgentVer.exe


C:\Downloadinstallers\"$nvidiaVer"_grid_win10_server2016_64bit_international.exe /s
Start-Sleep -s 90
Set-Location "C:\NVIDIA\$nvidiaVer"
.\setup.exe -s
Start-Sleep -s 90
C:\Downloadinstallers\PCoIP_agent_release_installer_"$teradiciAgentVer"_graphics.exe /S
Start-Sleep -s 90
& 'C:\Program Files (x86)\Teradici\PCoIP Agent\bin\RestartAgent.bat'
net stop nvsvc
Start-Sleep -s 90
net start nvsvc
& 'C:\Program Files (x86)\Teradici\PCoIP Agent\licenses\appactutil.exe' appactutil.exe -served -comm soap -commServer https://teradici.flexnetoperations.com/control/trdi/ActivationService -entitlementID $license
#>
New-Item -Path $dest -ItemType directory
$nvidiaUrl = [System.String]::Format("https://{0}.blob.core.windows.net/{1}/{2}_grid_win10_server2016_64bit_international.exe", $storageAcc, $conName, $nvidiaVer)
$teradiciAgentUrl = [System.String]::Format("https://{0}.blob.core.windows.net/{1}/PCoIP_agent_release_installer_{2}_graphics.exe", $storageAcc, $conName, $teradiciAgentVer)
$leostreamAgentUrl = [System.String]::Format("https://{0}.blob.core.windows.net/{1}/LeostreamAgentSetup{2}.exe", $storageAcc, $conName, $leostreamAgentVer)
$nvidiaExeName = [System.IO.Path]::GetFileName($nvidiaUrl)
$teradiciExeName = [System.IO.Path]::GetFileName($teradiciAgentUrl)
$leostreamExeName = [System.IO.Path]::GetFileName($leostreamAgentUrl)
$nvidiaExePath = [System.String]::Format("{0}{1}", $dest, $nvidiaExeName)
$teradiciExePath = [System.String]::Format("{0}{1}", $dest, $teradiciExeName)
$leostreamExePath = [System.String]::Format("{0}{1}", $dest, $leostreamExeName)
Write-Host "The NVIDIA Driver exe Url  is '$nvidiaUrl'"
Write-Host "The NVIDIA exe name is '$nvidiaExeName'"
Write-Host "The Teradici Agent exe  Url  is '$teradiciAgentUrl'"
Write-Host "The Teradici Agent exe name is '$teradiciExeName'"
Write-Host "The Leostream Agent exe Url is '$leostreamAgentUrl'"
Write-Host "The Leostream Agent exe name is '$leostreamExeName'"
Write-Host "The NVIDIDA exe downloaded location is '$nvidiaExePath'"
Write-Host "The Teradici Agent exe downloaded location is '$teradiciExePath'"
Write-Host "The Leostream Agent exe downloaded location iss '$leostreamExePath'"
wget $nvidiaUrl -OutFile $nvidiaExePath
wget $teradiciAgentUrl -OutFile $teradiciExePath
wget $leostreamAgentUrl -OutFile $leostreamExePath
Start-Sleep -s 360
& $nvidiaExePath  /s
Start-Sleep -s 60
$NVIDIAfolder = [System.String]::Format("C:\NVIDIA\{0}", $nvidiaVer)
Write-Host "The NVIDIA Folder name is '$NVIDIAfolder'"
Set-Location $NVIDIAfolder
.\setup.exe -s -noreboot -clean
Start-Sleep -s 180
& $teradiciExePath /S /NoPostReboot
Start-Sleep -s 90 
Write-Host "teradiciagent install over"
cd 'C:\Program Files (x86)\Teradici\PCoIP Agent\licenses\'
Write-Host "pre-activate"
.\appactutil.exe -served -comm soap -commServer https://teradici.flexnetoperations.com/control/trdi/ActivationService -entitlementID $license
Write-Host "activation over"
if ($teradiciAgentVer -match "2.7.0.4060")
{
IF(!(Test-Path $registryPath))

  {
    New-Item -Path $registryPath -Force | Out-Null
    New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType DWORD -Force | Out-Null}

 ELSE {
     New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType DWORD -Force | Out-Null}
  }
else
{ 
  Write-Host  "No Registry entry required ."
}
<# Reboot in 60 seconds #>
C:\WINDOWS\system32\shutdown.exe -r -f -t 60
Write-Host "end script"
<# & 'C:\Program Files (x86)\Teradici\PCoIP Agent\bin\RestartAgent.bat' #>
<# cd 'C:\Program Files (x86)\Teradici\PCoIP Agent\bin'
.\RestartAgent.bat
.\pcoip_arbiter_win32.exe start

Write-Host "teradici arbiter on"
net stop nvsvc
Start-Sleep -s 90
Write-Host "Stopping NVIDIA Display Driver"
net start nvsvc
Write-Host "Starting NVIDIA Display Driver"
#>

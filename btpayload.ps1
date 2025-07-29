# BT Encounter Simulation Script
$desktop = [Environment]::GetFolderPath('Desktop')
$imgUrl = "https://tse1.mm.bing.net/th/id/OIP.zkXRoEI1bi_78vt4JfWjYgHaEK?r=0&rs=1&pid=ImgDetMain&o=7&rm=3"
$imgPath = "$desktop\chiral_log_α73.png"
$soundUrl = "https://www.101soundboards.com/sounds/24348530-kojima-pro-whistle"
$reportPath = "$desktop\DOOMS_Report.txt"

# Write fake DOOMS report
$report = @"
Chiral Density Report - Level 4
Subject ID: Porter_77
DOOMS Level: Latent Activation
Symptoms: Hallucinations, irregular heart rate, sensitivity to BT presence.
Chiralium spikes detected in surrounding area.

>> Urgent: Evacuation protocol advised.
"@
$report | Out-File -Encoding UTF8 $reportPath

# Download and drop image
Invoke-WebRequest -Uri $imgUrl -OutFile $imgPath

# Simulate Chiralium scan
Add-Type -AssemblyName PresentationFramework
[System.Windows.MessageBox]::Show("↑↑↑ Chiralium Spike Detected ↑↑↑`nPossible BT presence nearby.","DOOMS Warning",[System.Windows.MessageBoxButton]::OK,[System.Windows.MessageBoxImage]::Warning)

# Flicker effect
$original = Get-ItemProperty -Path 'HKCU:\Control Panel\Desktop\' -Name Wallpaper
$black = "$env:TEMP\black.jpg"
Add-Type -AssemblyName System.Drawing
$bmp = New-Object System.Drawing.Bitmap 1920,1080
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.Clear([System.Drawing.Color]::Black)
$bmp.Save($black, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$g.Dispose()
$code = @"
[DllImport(\"user32.dll\")]
public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
"@
Add-Type -MemberDefinition $code -Name WinAPI -Namespace Native
[Native.WinAPI]::SystemParametersInfo(20, 0, $black, 3)
Start-Sleep -Seconds 2
[Native.WinAPI]::SystemParametersInfo(20, 0, $original.Wallpaper, 3)

# Play sound
Start-Process $soundUrl

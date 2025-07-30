# === Death Stranding BT Encounter Payload ===

# Paths
$temp        = $env:TEMP
$desktop = [Environment]::GetFolderPath("Desktop")
$username    = $env:USERNAME

$imgUrl      = "https://raw.githubusercontent.com/10ZackT/FlipperBT/main/bt.png"
$imgPath     = "$temp\bt.png"
$bmpPath     = "$temp\bt_wall.bmp"

$soundUrl    = "https://raw.githubusercontent.com/10ZackT/FlipperBT/main/bt_whistle.wav"
$soundPath   = "$temp\bt_whistle.wav"

$reportPath  = "$desktop\DOOMS_Report.txt"

# Clean old files
Remove-Item $imgPath, $bmpPath, $soundPath, $reportPath -ErrorAction SilentlyContinue

# -------------------------------
# 1. Create DOOMS Report on Desktop
# -------------------------------

try {
    $desktop = [Environment]::GetFolderPath("Desktop")
    $reportPath = Join-Path $desktop "DOOMS_Report.txt"

    $doomsLevels = @(
        "Level 1 - Mild Sensitivity",
        "Level 2 - Visual Aura",
        "Level 3 - Reactive Pulse",
        "Level 4 - Partial Repatriation",
        "Level 5 - Full Repatriation",
        "Level 6 - Enhanced Chiral Perception"
    )
    $level = Get-Random -InputObject $doomsLevels

    $abilities = @(
        "Timefall Resistance",
        "Chiral Allergy",
        "Enhanced Odradek Sync",
        "Partial BT Detection",
        "Repatriation (Death Return)",
        "Fragile Jump (Short Range Teleport)",
        "Bridge Link Bond Sensitivity"
    )
    $selectedAbilities = ($abilities | Get-Random -Count (Get-Random -Minimum 1 -Maximum 4)) -join ", "
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $report = @"
-------------------------------------------
CONFIDENTIAL - BRIDGES MEDICAL DOSSIER
-------------------------------------------
Subject: $env:USERNAME
Scan Time: $timestamp
Chiral Field Intensity: Elevated

DOOMS Level: $level

Observed Traits:
$selectedAbilities

Symptoms:
- Tachycardia under Chiral exposure
- Subject exhibits abnormal neural oscillation
- Increased response to Beached Things (BT) proximity

NOTE:
Subject is under observation by Bridges Medical Division.
Unauthorized dissemination of this report is punishable by UCA Directive 0049A.

-------------------------------------------
"@

    # Force file write with logging
    Set-Content -Path $reportPath -Value $report -Encoding UTF8 -Force

    # Confirm it's actually there
    if (Test-Path $reportPath) {
        Write-Host "✅ DOOMS report created at: $reportPath"
    } else {
        Write-Host "❌ Set-Content claimed success, but file was not created."
    }
} catch {
    Write-Host "❌ DOOMS report failed: $($_.Exception.Message)"
}


# -------------------------------
# 2. Show Chiral Spike Warning
# -------------------------------
Add-Type -AssemblyName PresentationFramework
[System.Windows.MessageBox]::Show("↑↑↑ Chiralium Spike Detected ↑↑↑`nPossible BT presence nearby.","DOOMS Warning",[System.Windows.MessageBoxButton]::OK,[System.Windows.MessageBoxImage]::Warning)

# -------------------------------
# 3. Download Image, Convert to BMP, Set Wallpaper
# -------------------------------
Invoke-WebRequest -Uri $imgUrl -OutFile $imgPath -UseBasicParsing

Add-Type -AssemblyName System.Drawing
$bmp = [System.Drawing.Image]::FromFile($imgPath)
$bmp.Save($bmpPath, [System.Drawing.Imaging.ImageFormat]::Bmp)
$bmp.Dispose()

$code = @"
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
Add-Type -TypeDefinition $code
[Wallpaper]::SystemParametersInfo(20, 0, $bmpPath, 3) | Out-Null
Write-Host "✅ Wallpaper set from: $bmpPath"

# -------------------------------
# 4. Download and Play Sound
# -------------------------------
Invoke-WebRequest -Uri $soundUrl -OutFile $soundPath -UseBasicParsing
Add-Type -AssemblyName presentationCore
$player = New-Object system.media.soundplayer
$player.SoundLocation = $soundPath
$player.Load()
$player.PlaySync()
Write-Host "✅ BT whistle played from: $soundPath"

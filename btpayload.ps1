# === BT Encounter Payload ===

# Variables
$desktop = [Environment]::GetFolderPath('Desktop')
$username = $env:USERNAME
$imgUrl = "https://github.com/10ZackT/FlipperBT/blob/main/bt.png"
$imgPath = "$desktop\bt.png"
$soundUrl = "https://github.com/10ZackT/FlipperBT/blob/main/bt_whistle.mp3"
$soundPath = "$env:TEMP\bt_whistle.mp3"
$reportPath = "$desktop\DOOMS_Report.txt"

# -------------------------------
# 1. Create DOOMS Report (Randomized)
# -------------------------------

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
Subject: $username
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

try {
    $report | Out-File -Encoding UTF8 $reportPath
} catch {
    Write-Output "DOOMS report failed to write: $($_.Exception.Message)"
}

# -------------------------------
# 2. Chiralium Detection Popup
# -------------------------------
try {
    Add-Type -AssemblyName PresentationFramework
    [System.Windows.MessageBox]::Show("↑↑↑ Chiralium Spike Detected ↑↑↑`nPossible BT presence nearby.","DOOMS Warning",[System.Windows.MessageBoxButton]::OK,[System.Windows.MessageBoxImage]::Warning)
} catch {
    Write-Output "Popup failed: $($_.Exception.Message)"
}

# -------------------------------
# 3. Download and Set BT Wallpaper
# -------------------------------
try {
    Invoke-WebRequest -Uri $imgUrl -OutFile $imgPath -UseBasicParsing
    if (Test-Path $imgPath) {
        $code = @"
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
        Add-Type -TypeDefinition $code
        [Wallpaper]::SystemParametersInfo(20, 0, $imgPath, 3)
    } else {
        Write-Output "Wallpaper image not found after download."
    }
} catch {
    Write-Output "Wallpaper set failed: $($_.Exception.Message)"
}

# -------------------------------
# 4. Download and Play BT Sound
# -------------------------------
try {
    Invoke-WebRequest -Uri $soundUrl -OutFile $soundPath -UseBasicParsing
    Add-Type -AssemblyName presentationCore
    $player = New-Object system.media.soundplayer
    $player.SoundLocation = $soundPath
    $player.Load()
    $player.PlaySync()
} catch {
    Write-Output "Sound playback failed: $($_.Exception.Message)"
}

# === Death Stranding BT Encounter Payload ===

# Paths
$desktop     = [Environment]::GetFolderPath('Desktop')
$username    = $env:USERNAME
$imgUrl      = "https://raw.githubusercontent.com/10ZackT/FlipperBT/main/bt.png"
$imgPath     = "$desktop\bt.png"
$soundUrl    = "https://raw.githubusercontent.com/10ZackT/FlipperBT/main/bt_whistle.mp3"
$soundPath   = "$env:TEMP\bt_whistle.mp3"
$reportPath  = "$desktop\DOOMS_Report.txt"

# -------------------------------
# 1. Create DOOMS Report
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
    Write-Output "DOOMS report failed: $($_.Exception.Message)"
}

# -------------------------------
# 2. Chiralium Spike Warning
# -------------------------------

try {
    Add-Type -AssemblyName PresentationFramework
    [System.Windows.MessageBox]::Show("↑↑↑ Chiralium Spike Detected ↑↑↑`nPossible BT presence nearby.","DOOMS Warning",[System.Windows.MessageBoxButton]::OK,[System.Windows.MessageBoxImage]::Warning)
} catch {
    Write-Output "Popup failed: $($_.Exception.Message)"
}

# -------------------------------
# 3. Download and Set Wallpaper
# -------------------------------

try {
    Start-BitsTransfer -Source $imgUrl -Destination $imgPath
    $attempts = 0
    while (!(Test-Path $imgPath) -and ($attempts -lt 5)) {
        Start-Sleep -Milliseconds 500
        $attempts++
    }

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
# 4. Download and Play Sound
# -------------------------------

try {
    Start-BitsTransfer -Source $soundUrl -Destination $soundPath
    $attempts = 0
    while (!(Test-Path $soundPath) -and ($attempts -lt 5)) {
        Start-Sleep -Milliseconds 500
        $attempts++
    }

    if (Test-Path $soundPath) {
        Add-Type -AssemblyName presentationCore
        $player = New-Object system.media.soundplayer
        $player.SoundLocation = $soundPath
        $player.Load()
        $player.PlaySync()
    } else {
        Write-Output "Sound file not found after download."
    }
} catch {
    Write-Output "Sound playback failed: $($_.Exception.Message)"
}

# === Death Stranding BT Encounter Payload (Finalized) ===

# Hardcoded and direct paths (avoids inconsistent environment resolution)
$desktop     = "$env:USERPROFILE\Desktop"
$username    = $env:USERNAME
$imgUrl      = "https://raw.githubusercontent.com/10ZackT/FlipperBT/main/bt.png"
$imgPath     = "$desktop\bt.png"
$soundUrl    = "https://raw.githubusercontent.com/10ZackT/FlipperBT/main/bt_whistle.wav"
$soundPath   = "$env:TEMP\bt_whistle.wav"
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
    $report | Out-File -Encoding UTF8 -Force -FilePath $reportPath
    Write-Host "✅ DOOMS report written to $reportPath"
} catch {
    Write-Host "❌ Failed to write DOOMS report: $($_.Exception.Message)"
}

# -------------------------------
# 2. Chiralium Spike Warning
# -------------------------------

try {
    Add-Type -AssemblyName PresentationFramework
    [System.Windows.MessageBox]::Show("↑↑↑ Chiralium Spike Detected ↑↑↑`nPossible BT presence nearby.","DOOMS Warning",[System.Windows.MessageBoxButton]::OK,[System.Windows.MessageBoxImage]::Warning)
} catch {
    Write-Host "❌ Failed to show popup: $($_.Exception.Message)"
}

# -------------------------------
# 3. Download and Set Wallpaper (always overwrites)
# -------------------------------

try {
    Invoke-WebRequest -Uri $imgUrl -OutFile $imgPath -UseBasicParsing -ErrorAction Stop
    Write-Host "✅ Downloaded image to $imgPath"

    $code = @"
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
    Add-Type -TypeDefinition $code -ErrorAction Stop
    [Wallpaper]::SystemParametersInfo(20, 0, $imgPath, 3)
} catch {
    Write-Host "❌ Failed to download or set wallpaper: $($_.Exception.Message)"
}

# -------------------------------
# 4. Download and Play Sound (.wav only)
# -------------------------------

try {
    Invoke-WebRequest -Uri $soundUrl -OutFile $soundPath -UseBasicParsing -ErrorAction Stop
    Write-Host "✅ Downloaded sound to $soundPath"

    Add-Type -AssemblyName presentationCore -ErrorAction Stop
    $player = New-Object system.media.soundplayer
    $player.SoundLocation = $soundPath
    $player.Load()
    $player.PlaySync()
} catch {
    Write-Host "❌ Failed to download or play sound: $($_.Exception.Message)"
}

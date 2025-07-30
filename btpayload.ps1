# === Death Stranding BT Encounter Payload (Final Fixed Version) ===

# Define Paths
$desktop     = "$env:USERPROFILE\Desktop"
$username    = $env:USERNAME
$imgUrl      = "https://raw.githubusercontent.com/10ZackT/FlipperBT/main/bt.png"
$imgPath     = Join-Path $desktop "bt.png"
$soundUrl    = "https://raw.githubusercontent.com/10ZackT/FlipperBT/main/bt_whistle.wav"
$soundPath   = "$env:TEMP\bt_whistle.wav"
$reportPath  = Join-Path $desktop "DOOMS_Report.txt"

# Force delete any existing files (NO DEPENDENCIES)
Remove-Item $imgPath -ErrorAction SilentlyContinue
Remove-Item $soundPath -ErrorAction SilentlyContinue
Remove-Item $reportPath -ErrorAction SilentlyContinue

# -------------------------------
# 1. Create DOOMS Report (Always)
# -------------------------------
try {
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

    Set-Content -Path $reportPath -Value $report -Encoding UTF8 -Force
    Write-Host "✅ DOOMS report created at $reportPath"
} catch {
    Write-Host "❌ DOOMS report creation failed: $($_.Exception.Message)"
    pause
    exit 1
}

# -------------------------------
# 2. Warning Popup
# -------------------------------
try {
    Add-Type -AssemblyName PresentationFramework
    [System.Windows.MessageBox]::Show("↑↑↑ Chiralium Spike Detected ↑↑↑`nPossible BT presence nearby.","DOOMS Warning",[System.Windows.MessageBoxButton]::OK,[System.Windows.MessageBoxImage]::Warning)
} catch {
    Write-Host "❌ Popup failed: $($_.Exception.Message)"
}

# -------------------------------
# 3. Download + Force Wallpaper Set
# -------------------------------
try {
    Invoke-WebRequest -Uri $imgUrl -OutFile $imgPath -UseBasicParsing -ErrorAction Stop
    Write-Host "✅ Image downloaded to $imgPath"

    $code = @"
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@

    # Force use of 64-bit powershell context
    if ([Environment]::Is64BitProcess -eq $false) {
        Write-Host "❌ PowerShell is 32-bit. Wallpaper setting may fail."
    }

    Add-Type -TypeDefinition $code -ErrorAction Stop
    $result = [Wallpaper]::SystemParametersInfo(20, 0, $imgPath, 3)

    if (-not $result) {
        Write-Host "❌ Failed to set wallpaper. SystemParametersInfo returned false."
    } else {
        Write-Host "✅ Wallpaper set successfully."
    }
} catch {
    Write-Host "❌ Wallpaper setup failed: $($_.Exception.Message)"
}

# -------------------------------
# 4. Download and Play Sound
# -------------------------------
try {
    Invoke-WebRequest -Uri $soundUrl -OutFile $soundPath -UseBasicParsing -ErrorAction Stop
    Write-Host "✅ Sound downloaded to $soundPath"

    Add-Type -AssemblyName presentationCore -ErrorAction Stop
    $player = New-Object system.media.soundplayer
    $player.SoundLocation = $soundPath
    $player.Load()
    $player.PlaySync()
} catch {
    Write-Host "❌ Sound playback failed: $($_.Exception.Message)"
}

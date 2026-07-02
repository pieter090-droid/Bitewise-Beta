<#
    Bitewise – platform setup
    --------------------------
    Voegt de camera-permissies toe die mobile_scanner nodig heeft.
    Draai NA `flutter create .`, vanuit de projectroot:

        pwsh ./tool/setup_platform.ps1      (of: powershell ...)

    Idempotent: meermaals draaien is veilig.
#>

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot   # projectroot (tool/ zit één niveau diep)

function Info($m) { Write-Host "  $m" -ForegroundColor Cyan }
function Ok($m)   { Write-Host "  OK  $m" -ForegroundColor Green }
function Warn($m) { Write-Host "  !!  $m" -ForegroundColor Yellow }

if (-not (Test-Path (Join-Path $root 'pubspec.yaml'))) {
    throw "pubspec.yaml niet gevonden. Draai dit script vanuit de Bitewise-projectroot."
}

Write-Host "`nBitewise platform setup" -ForegroundColor White

# --- Android: CAMERA-permissie -------------------------------------------------
$manifest = Join-Path $root 'android/app/src/main/AndroidManifest.xml'
if (-not (Test-Path $manifest)) {
    Warn "android/ ontbreekt. Draai eerst: flutter create ."
} else {
    $xml = Get-Content $manifest -Raw
    if ($xml -match 'android\.permission\.CAMERA') {
        Ok "CAMERA-permissie al aanwezig in AndroidManifest.xml"
    } else {
        $perm = '    <uses-permission android:name="android.permission.CAMERA"/>' + "`n"
        # Voeg toe direct na de <manifest ...> openingstag.
        $xml = $xml -replace '(<manifest[^>]*>\s*)', ('$1' + $perm)
        Set-Content -Path $manifest -Value $xml -Encoding utf8
        Ok "CAMERA-permissie toegevoegd aan AndroidManifest.xml"
    }
}

# --- Android: minSdk >= 21 controleren ----------------------------------------
foreach ($g in @('android/app/build.gradle.kts', 'android/app/build.gradle')) {
    $gp = Join-Path $root $g
    if (Test-Path $gp) {
        $gradle = Get-Content $gp -Raw
        $m = [regex]::Match($gradle, 'minSdk(?:Version)?\s*=?\s*(\d+)')
        if ($m.Success) {
            $val = [int]$m.Groups[1].Value
            if ($val -lt 21) {
                Warn "$g heeft minSdk $val — mobile_scanner vereist minimaal 21. Handmatig bijwerken."
            } else {
                Ok "$g minSdk = $val (>= 21)"
            }
        } else {
            Info "$g gebruikt flutter.minSdkVersion (standaard >= 21) — niets te doen."
        }
        break
    }
}

# --- iOS: NSCameraUsageDescription --------------------------------------------
$plist = Join-Path $root 'ios/Runner/Info.plist'
if (-not (Test-Path $plist)) {
    Warn "ios/ ontbreekt. Draai eerst: flutter create ."
} else {
    $p = Get-Content $plist -Raw
    if ($p -match 'NSCameraUsageDescription') {
        Ok "NSCameraUsageDescription al aanwezig in Info.plist"
    } else {
        $entry = @'
	<key>NSCameraUsageDescription</key>
	<string>Bitewise gebruikt de camera om productbarcodes te scannen.</string>
'@
        # Voeg toe vlak voor de afsluitende </dict>.
        $p = $p -replace '(\s*</dict>\s*</plist>\s*)$', ("`n" + $entry + '$1')
        Set-Content -Path $plist -Value $p -Encoding utf8
        Ok "NSCameraUsageDescription toegevoegd aan Info.plist"
    }
}

Write-Host "`nKlaar. Vergeet niet: flutter pub get && dart run build_runner build`n" -ForegroundColor White

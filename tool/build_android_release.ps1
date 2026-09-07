param(
    [string]$FlutterCommand = "flutter"
)

$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent $PSScriptRoot
$tempRoot = [System.IO.Path]::GetTempPath()
$staging = Join-Path $tempRoot ("zhouji_android_build_" + [Guid]::NewGuid().ToString("N"))
$sourceDirectories = @("android", "lib", "test")
$sourceFiles = @(
    "pubspec.yaml",
    "pubspec.lock",
    "analysis_options.yaml",
    "README.md",
    ".metadata"
)

New-Item -ItemType Directory -Path $staging | Out-Null

try {
    foreach ($directory in $sourceDirectories) {
        Copy-Item `
            -LiteralPath (Join-Path $projectRoot $directory) `
            -Destination $staging `
            -Recurse
    }
    foreach ($file in $sourceFiles) {
        Copy-Item `
            -LiteralPath (Join-Path $projectRoot $file) `
            -Destination (Join-Path $staging $file)
    }

    Push-Location $staging
    try {
        & $FlutterCommand pub get
        if ($LASTEXITCODE -ne 0) {
            throw "flutter pub get 失败，退出码：$LASTEXITCODE"
        }

        & $FlutterCommand build apk --release
        if ($LASTEXITCODE -ne 0) {
            throw "flutter build apk --release 失败，退出码：$LASTEXITCODE"
        }
    }
    finally {
        Pop-Location
    }

    $sourceApk = Join-Path $staging "build\app\outputs\flutter-apk\app-release.apk"
    $targetDirectory = Join-Path $projectRoot "build\app\outputs\flutter-apk"
    $targetApk = Join-Path $targetDirectory "app-release.apk"
    New-Item -ItemType Directory -Path $targetDirectory -Force | Out-Null
    Copy-Item -LiteralPath $sourceApk -Destination $targetApk -Force
    Write-Host "Release APK 已生成：$targetApk"
}
finally {
    if (Test-Path -LiteralPath $staging) {
        $resolvedStaging = (Resolve-Path -LiteralPath $staging).Path
        $resolvedTempRoot = (Resolve-Path -LiteralPath $tempRoot).Path
        if ($resolvedStaging.StartsWith(
                $resolvedTempRoot,
                [System.StringComparison]::OrdinalIgnoreCase
            )) {
            Remove-Item -LiteralPath $resolvedStaging -Recurse -Force
        }
    }
}

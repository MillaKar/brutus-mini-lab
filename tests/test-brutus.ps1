$ErrorActionPreference = "Stop"

$brutus = Join-Path $PSScriptRoot "..\brutus\bin\brutus.exe"

Write-Host ""
Write-Host "=== Brutus Mini Lab Tests ===" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path $brutus)) {
    Write-Host "[FAIL] Brutus executable not found: $brutus" -ForegroundColor Red
    exit 1
}

$tests = @(
    @{
        Name = "SSH"
        Target = "127.0.0.1:2222"
        Protocol = "ssh"
        Credentials = "labuser:labpassword"
    },
    @{
        Name = "FTP"
        Target = "127.0.0.1:2121"
        Protocol = "ftp"
        Credentials = "labuser:labpassword"
    },
    @{
        Name = "Telnet"
        Target = "127.0.0.1:2323"
        Protocol = "telnet"
        Credentials = "user:password"
    }
)

$failed = 0

foreach ($test in $tests) {
    Write-Host "[*] Testing $($test.Name)..." -ForegroundColor Yellow

    & $brutus creds `
        --target $test.Target `
        --protocol $test.Protocol `
        -c $test.Credentials

    if ($LASTEXITCODE -eq 0) {
        Write-Host "[PASS] $($test.Name)" -ForegroundColor Green
    }
    else {
        Write-Host "[FAIL] $($test.Name)" -ForegroundColor Red
        $failed++
    }

    Write-Host ""
}

Write-Host "=== Test Summary ===" -ForegroundColor Cyan

if ($failed -eq 0) {
    Write-Host "All tests passed." -ForegroundColor Green
    exit 0
}
else {
    Write-Host "$failed test(s) failed." -ForegroundColor Red
    exit 1
}
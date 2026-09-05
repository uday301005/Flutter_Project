# $projectPath = Get-Location
# $exePath = Join-Path $projectPath "build\windows\x64\runner\Release\shopping.exe"

# Write-Host "Flutter Auto Build Watcher Started..." -ForegroundColor Green
# Write-Host "Watching lib/ and assets/ for changes..."
# Write-Host "Press Ctrl+C to stop."

# function Build-And-Run {
#     Write-Host ""
#     Write-Host "Change detected. Building Flutter app..." -ForegroundColor Yellow

#     Get-Process shopping -ErrorAction SilentlyContinue | Stop-Process -Force

#     flutter build windows --release

#     if ($LASTEXITCODE -ne 0) {
#         Write-Host "Build failed. Fix the error and save again." -ForegroundColor Red
#         return
#     }

#     if (Test-Path $exePath) {
#         Write-Host "Starting application..." -ForegroundColor Green
#         Start-Process $exePath
#     }
# }

# $watcher = New-Object System.IO.FileSystemWatcher
# $watcher.Path = $projectPath
# $watcher.Filter = "*.dart"
# $watcher.IncludeSubdirectories = $true
# $watcher.EnableRaisingEvents = $true

# $action = {
#     Start-Sleep -Milliseconds 500
#     Build-And-Run
# }

# Register-ObjectEvent $watcher "Changed" -Action $action | Out-Null

# while ($true) {
#     Wait-Event
# }
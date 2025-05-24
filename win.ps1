
# win.ps1 — Pumps Tweak Cloud Installer Script

function Require-Admin {
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Warning "Please run this script as Administrator!"
        exit
    }
}

function Show-Menu {
    Clear-Host
    Write-Host "====== PUMPS TWEAK ======" -ForegroundColor Cyan
    Write-Host "1. Apply Performance Tweaks"
    Write-Host "2. Apply USB/Controller Fix"
    Write-Host "3. Optimize Ping (Pump)"
    Write-Host "4. Activate UltraBoost Power Plan"
    Write-Host "5. Optimize Games (Fortnite/Roblox/CoD)"
    Write-Host "6. Launch Full GUI"
    Write-Host "7. Exit"
}

function Run-Tweaks {
    Write-Host "Applying Windows performance tweaks..."
    # You can add your registry/system tweaks here
}

function Run-USB {
    Write-Host "Applying USB/Controller tweaks..."
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\USB" /v DisableSelectiveSuspend /t REG_DWORD /d 1 /f
}

function Run-Ping {
    Write-Host "Optimizing ping..."
    ipconfig /flushdns
    netsh interface tcp set global autotuninglevel=disabled
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpAckFrequency /t REG_DWORD /d 1 /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TCPNoDelay /t REG_DWORD /d 1 /f
}

function Run-PowerPlan {
    Write-Host "Enabling UltraBoost Power Plan..."
    powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
}

function Optimize-Games {
    Write-Host "Optimizing game GPU profiles..."
    reg add "HKCU\Software\Microsoft\DirectX\UserGpuPreferences" /v "FortniteClient-Win64-Shipping.exe" /t REG_SZ /d "GpuPreference=2;" /f
    reg add "HKCU\Software\Microsoft\DirectX\UserGpuPreferences" /v "RobloxPlayerBeta.exe" /t REG_SZ /d "GpuPreference=2;" /f
    reg add "HKCU\Software\Microsoft\DirectX\UserGpuPreferences" /v "cod.exe" /t REG_SZ /d "GpuPreference=2;" /f
}

function Run-GUI {
    $url = "https://pumpstweak.com/download/PumpsTweak_GUI.exe"
    $out = "$env:TEMP\PumpsTweak_GUI.exe"
    Invoke-WebRequest -Uri $url -OutFile $out
    Start-Process $out
}

function Main {
    Require-Admin
    do {
        Show-Menu
        $choice = Read-Host "Choose an option"
        switch ($choice) {
            "1" { Run-Tweaks }
            "2" { Run-USB }
            "3" { Run-Ping }
            "4" { Run-PowerPlan }
            "5" { Optimize-Games }
            "6" { Run-GUI }
            "7" { exit }
            default { Write-Host "Invalid choice. Try again." }
        }
        Pause
    } while ($true)
}

Main

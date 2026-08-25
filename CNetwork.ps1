# ====================================================================
#  APPLICATION: CNetwork v1.0.0 (Official Stable Release)
#  DESCRIPTION: Universal Wi-Fi Parsing & Native OS Geolocation
# ====================================================================

[Console]::ForegroundColor = 'Green'
$ErrorActionPreference = 'SilentlyContinue'

# Force UTF-8 encoding for console screen rendering
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Clear-Host
Write-Host "[*] Launching CNetwork v1.0.0 stable release..."
Write-Host "[*] Fetching local parameters and native geolocation..."

# 1. Native Offline Geolocation (100% Automatic & Universal for GitHub)
$countryName = (Get-ItemProperty "HKCU:\Control Panel\International\Geo").Name
if (-not $countryName) { $countryName = (Get-Culture).Name.Split('-')[-1].ToUpper() }

# Automatically extract the primary city name from Windows native timezone registry
$rawZone = [System.TimeZoneInfo]::Local.DisplayName
$cleanCity = "Local"
if ($rawZone -match '\)\s+([^,\s\)]+)') { 
    $cleanCity = $Matches[1] 
}

$geoStr = "$countryName ($cleanCity)"

# High-reliability External WAN fetch using native curl.exe to get pure text only
$wanIP = "Offline"
$ipTriggers = @("https://ipify.org", "https://ifconfig.me", "https://icanhazip.com")
foreach ($trigger in $ipTriggers) {
    $response = & curl.exe -s --max-time 3 $trigger
    if ($response -and $response.Trim() -match "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$") { 
        $wanIP = $response.Trim()
        break 
    }
}

# 2. Fetch primary active network adapter details
$adapter = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' } | Select-Object -First 1
$ipInfo  = Get-NetIPAddress -InterfaceIndex $adapter.InterfaceIndex -AddressFamily IPv4 | Select-Object -First 1
$config  = Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object { $_.InterfaceIndex -eq $adapter.InterfaceIndex }

$ipAddress   = $ipInfo.IPAddress
$subnetMask  = $config.IPSubnet
$defaultGateway = $config.DefaultIPGateway
$macAddress  = $adapter.MacAddress

# 3. Extract Wi-Fi details (Language and Cyrillic Independent)
$wifiSSID = "N/A (Ethernet Cable)"
$wifiBSSID = "N/A (Ethernet Cable)"
$wifiAuth = "N/A"
$wifiKey = "N/A"

$wlanReport = netsh wlan show interfaces
if ($wlanReport -match "SSID") {
    # Bulletproof regex to extract ONLY the actual SSID name after the first colon
    if (($wlanReport | Where-Object { $_ -match "^\s+SSID" }) -match ":\s+(.+)$") {
        $wifiSSID = $Matches[1].Trim()
    }
    
    $wifiBSSID = (($wlanReport | Where-Object { $_ -match "BSSID" }) -split ":")[1..6] -join ":"
    $wifiBSSID = $wifiBSSID.Trim()
    
    if ($wifiSSID -and $wifiSSID -notlike "N/A*") {
        # Fetching profile details with raw output redirection via CMD to preserve Cyrillic encoding
        $cmdOutput = & cmd.exe /c "netsh wlan show profile name=""$wifiSSID"" key=clear"
        
        # Universal parsing using regex pattern matching instead of explicit words
        foreach ($line in $cmdOutput) {
            if ($line -match "Authentication|Аутентификация|Пользовательская|Тип|Шифрование") {
                if ($line -match ":\s+(.+)$") { $wifiAuth = $Matches[1].Trim() }
            }
            if ($line -match "Key Content|Содержимое ключа") {
                if ($line -match ":\s+(.+)$") { $wifiKey = $Matches[1].Trim() }
            }
        }
    }
}

if (-not $subnetMask) { $subnetMask = "255.255.255.0" }
if (-not $defaultGateway) { $defaultGateway = "Disconnected" }

# 4. Live dashboard loop
while ($true) {
    Clear-Host
    
    # Real-time ping test (Updates every second)
    $pingTime = "Error (Timeout)"
    $ping = Test-Connection -ComputerName 8.8.8.8 -Count 1 -ErrorAction SilentlyContinue
    if ($ping) {
        $pingTime = "$($ping.ResponseTime) ms"
    }

    # Your custom ultimate ASCII banner
    Write-Host '╔══╗╔╗─╔╗╔═══╗╔════╗╔╗╔╗╔╗╔══╗╔═══╗╔╗╔══╗'
    Write-Host '║╔═╝║╚═╝║║╔══╝╚═╗╔═╝║║║║║║║╔╗║║╔═╗║║║║╔═╝'
Write-Host '║║──║╔╗─║║╚══╗──║║──║║║║║║║║║║║╚═╝║║╚╝║──'
    Write-Host '║║──║║╚╗║║╔══╝──║║──║║║║║║║║║║║╔╗╔╝║╔╗║──'
    Write-Host '║╚═╗║║─║║║╚══╗──║║──║╚╝╚╝║║╚╝║║║║║─║║║╚═╗'
    Write-Host '╚══╝╚╝─╚╝╚═══╝──╚╝──╚═╝╚═╝╚══╝╚╝╚╝─╚╝╚══╝ v1.0.0'
    Write-Host "===================================================================="
    Write-Host " USERNAME:      user"
    Write-Host " TIME:          [ $(Get-Date -Format 'HH:mm:ss') ]"
    Write-Host "--------------------------------------------------------------------"
    Write-Host " [WIRELESS NETWORK CONFIGURATION]"
    Write-Host " SSID Name    : $wifiSSID"
    Write-Host " BSSID Name   : $wifiBSSID"
    Write-Host " Security Type: $wifiAuth"
    Write-Host " Network Key  : $wifiKey"
    Write-Host "--------------------------------------------------------------------"
    Write-Host " [LOCAL PARAMETERS]"
    Write-Host " IP (IPv4)    : $ipAddress"
    Write-Host " Subnet Mask  : $subnetMask"
    Write-Host " Gateway      : $defaultGateway"
    Write-Host " MAC Address  : $macAddress"
    Write-Host "--------------------------------------------------------------------"
    Write-Host " [GEOLOCATION & DIAGNOSTICS]"
    Write-Host " External WAN : $wanIP"
    Write-Host " Network Geo  : $geoStr"
    Write-Host " Live Ping    : $pingTime"
    Write-Host "===================================================================="
    Write-Host " Press Ctrl+C to exit."

    Start-Sleep -Seconds 1
}
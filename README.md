# CNetwork v1.0.0 🌐 

CNetwork (Control Network) is a powerful, standalone network intelligence dashboard and real-time diagnostic tool built natively for the Windows console. Featuring a high-performance matrix-green Text User Interface (TUI) that refreshes every second, it automates wireless profile analysis and maps critical networking parameters into a single, clean workspace.

## 🔥  Features
- **Matrix-Inspired TUI**: Fully green, cyber-styled standalone terminal window that updates dynamically without screen flickering.
- **Language-Independent Wi-Fi Decryptor**: Automatically processes raw Windows profile data (preserving Cyrillic encodings like `Tenda-шмэнда`) to instantly extract active SSID, hardware BSSID, encryption protocols, and cleartext **Network Passwords**.
- **Local Network Mapping**: Real-time retrieval of active IPv4 addresses, subnet masks, default gateways, and physical MAC addresses.
- **Robust WAN Intelligence**: Tracks your external WAN IP using multi-server redundancy backups, alongside integrated native offline OS geolocation (Country & Timezone mapping).
- **Continuous Live Ping**: Integrated 1-second interval latency monitor pointing directly to stable global DNS nodes to instantly track gaming lag or signal drops.

## 🚀  How to Run (.ps1)
1. Download the `CNetwork.ps1` script to your desktop.
2. Right-click the file and select **"Run with PowerShell"**.
3. *Note:* If your system execution policy blocks it, unblock your user scope by running this command in PowerShell once:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
   ```

## 🛠️  How to Compile into Standalone .exe (With Custom Icon)
You can easily build your own autonomous binary executable using the `ps2exe` compiler module. 

1. Place your target icon file (`icon.ico`) into the same directory as your script.
2. Open PowerShell, navigate to your workspace folder, and run:
   ```powershell
   Import-Module ps2exe; ps2exe -inputFile .\CNetwork.ps1 -outputFile .\CNetwork.exe -iconFile .\icon.ico -title "CNetwork Dashboard" -description "Network Control Intelligence" -version "1.0.0"
   ```
3. Your portable `CNetwork.exe` file is ready! It will run instantly on any Windows PC without any dependencies or administrative prompts.

## 📝  License
This project is open-source and available

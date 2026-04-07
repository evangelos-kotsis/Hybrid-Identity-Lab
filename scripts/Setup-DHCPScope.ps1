# ============================================================
# Setup-DHCPScope.ps1
# Hybrid Identity Lab — Module 6
# Installs DHCP role and configures a scope on SERVER02
# ============================================================

# Install DHCP Server role
Install-WindowsFeature -Name DHCP -IncludeManagementTools
Write-Host "[+] DHCP Server role installed." -ForegroundColor Green

# Authorize DHCP server in Active Directory
Add-DhcpServerInDC -DnsName "SERVER02.lab.hybrid.local" -IPAddress 192.168.10.20
Write-Host "[+] DHCP Server authorized in Active Directory." -ForegroundColor Green

# Create DHCP scope
Add-DhcpServerv4Scope `
    -Name        "HybridLab Scope" `
    -StartRange  192.168.10.100 `
    -EndRange    192.168.10.200 `
    -SubnetMask  255.255.255.0 `
    -State       Active

Write-Host "[+] DHCP scope created: 192.168.10.100 - 192.168.10.200" -ForegroundColor Green

# Set default gateway option
Set-DhcpServerv4OptionValue `
    -ScopeId  192.168.10.0 `
    -Router   192.168.10.1

# Set DNS server option
Set-DhcpServerv4OptionValue `
    -ScopeId    192.168.10.0 `
    -DnsServer  192.168.10.10

Write-Host "[+] DHCP options set (gateway: 192.168.10.1, DNS: 192.168.10.10)" -ForegroundColor Green
Write-Host "`n[✓] DHCP scope configured successfully." -ForegroundColor Cyan

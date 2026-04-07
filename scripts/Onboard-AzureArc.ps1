# ============================================================
# Onboard-AzureArc.ps1
# Hybrid Identity Lab — Module 10
# Onboards an on-premises server to Azure Arc
# Run as Administrator on the target server (DC01)
# ============================================================

# Parameters — update these before running
$subscriptionId = "<YOUR_SUBSCRIPTION_ID>"
$resourceGroup  = "sentinel-lab-rg"
$tenantId       = "<YOUR_TENANT_ID>"
$location       = "westeurope"

# Set execution policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine -Force
Write-Host "[+] Execution policy set to RemoteSigned." -ForegroundColor Green

# Create install directory
$installDir = "C:\Windows\AzureConnectedMachineAgent"
if (-not (Test-Path $installDir)) {
    New-Item -ItemType Directory -Path $installDir | Out-Null
}

# Download Azure Connected Machine Agent
$agentUrl  = "https://gbl.his.arc.azure.com/azcmagent/latest/AzureConnectedMachineAgent.msi"
$agentPath = "$installDir\temp\AzureConnectedMachineAgent.msi"

New-Item -ItemType Directory -Path "$installDir\temp" -Force | Out-Null
Invoke-WebRequest -Uri $agentUrl -OutFile $agentPath
Write-Host "[+] Agent package downloaded." -ForegroundColor Green

# Install the agent
msiexec /i $agentPath /l*v "$installDir\install.log" /qn
Write-Host "[+] Azure Connected Machine Agent installed." -ForegroundColor Green

# Connect the server to Azure Arc
& "$env:ProgramFiles\AzureConnectedMachineAgent\azcmagent.exe" connect `
    --subscription-id $subscriptionId `
    --resource-group  $resourceGroup `
    --tenant-id       $tenantId `
    --location        $location `
    --cloud           AzureCloud

Write-Host "`n[✓] Server successfully onboarded to Azure Arc." -ForegroundColor Cyan
Write-Host "    Check Azure Portal → Azure Arc → Machines to verify." -ForegroundColor Cyan

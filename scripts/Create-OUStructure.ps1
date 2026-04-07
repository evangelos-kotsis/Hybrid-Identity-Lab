# ============================================================
# Create-OUStructure.ps1
# Hybrid Identity Lab — Module 2
# Creates the OU structure under the HybridLab parent OU
# Domain: lab.hybrid.local
# ============================================================

Import-Module ActiveDirectory

$domain = "DC=lab,DC=hybrid,DC=local"

# Create parent OU
New-ADOrganizationalUnit -Name "HybridLab" -Path $domain -ProtectedFromAccidentalDeletion $false
Write-Host "[+] Created OU: HybridLab" -ForegroundColor Green

# Create child OUs under HybridLab
$childOUs = @("Users", "Computers", "Groups", "ServiceAccounts")

foreach ($ou in $childOUs) {
    New-ADOrganizationalUnit -Name $ou -Path "OU=HybridLab,$domain" -ProtectedFromAccidentalDeletion $false
    Write-Host "[+] Created OU: $ou" -ForegroundColor Green
}

Write-Host "`n[✓] OU structure created successfully." -ForegroundColor Cyan

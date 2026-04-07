# ============================================================
# Configure-PasswordPolicy.ps1
# Hybrid Identity Lab — Module 4
# Configures the Default Domain Password Policy
# Domain: lab.hybrid.local
# ============================================================

Import-Module ActiveDirectory

$domain = "lab.hybrid.local"

Set-ADDefaultDomainPasswordPolicy -Identity $domain `
    -MinPasswordLength      12 `
    -PasswordHistoryCount   10 `
    -MaxPasswordAge         (New-TimeSpan -Days 60) `
    -MinPasswordAge         (New-TimeSpan -Days 1) `
    -ComplexityEnabled      $true `
    -ReversibleEncryptionEnabled $false

Write-Host "[+] Password policy configured:" -ForegroundColor Green
Write-Host "    - Minimum length    : 12 characters"
Write-Host "    - Complexity        : Enabled"
Write-Host "    - Max age           : 60 days"
Write-Host "    - Password history  : 10 passwords"

# Configure Account Lockout Policy
Set-ADDefaultDomainPasswordPolicy -Identity $domain `
    -LockoutThreshold       5 `
    -LockoutDuration        (New-TimeSpan -Minutes 30) `
    -LockoutObservationWindow (New-TimeSpan -Minutes 30)

Write-Host "[+] Lockout policy configured:" -ForegroundColor Green
Write-Host "    - Lockout threshold : 5 attempts"
Write-Host "    - Lockout duration  : 30 minutes"

Write-Host "`n[✓] Password and lockout policies applied successfully." -ForegroundColor Cyan

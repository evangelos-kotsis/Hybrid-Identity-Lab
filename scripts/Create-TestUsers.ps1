# ============================================================
# Create-TestUsers.ps1
# Hybrid Identity Lab — Module 2
# Creates three test users in the HybridLab\Users OU
# Domain: lab.hybrid.local
# ============================================================

Import-Module ActiveDirectory

$domain     = "DC=lab,DC=hybrid,DC=local"
$ouPath     = "OU=Users,OU=HybridLab,$domain"
$upnSuffix  = "kotsvagg83gmail.onmicrosoft.com"
$password   = ConvertTo-SecureString "UserPass@2024!" -AsPlainText -Force

$users = @(
    @{ First = "Alice"; Last = "Johnson"; Sam = "alice.johnson" },
    @{ First = "Bob";   Last = "Smith";   Sam = "bob.smith"     },
    @{ First = "Carol"; Last = "White";   Sam = "carol.white"   }
)

foreach ($u in $users) {
    $upn  = "$($u.Sam)@$upnSuffix"
    $name = "$($u.First) $($u.Last)"

    New-ADUser `
        -GivenName        $u.First `
        -Surname          $u.Last `
        -Name             $name `
        -SamAccountName   $u.Sam `
        -UserPrincipalName $upn `
        -Path             $ouPath `
        -AccountPassword  $password `
        -Enabled          $true `
        -PasswordNeverExpires $false

    Write-Host "[+] Created user: $name ($upn)" -ForegroundColor Green
}

Write-Host "`n[✓] All test users created successfully." -ForegroundColor Cyan

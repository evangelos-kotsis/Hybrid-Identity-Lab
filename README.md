# 🔗 Hybrid Identity Lab

![Status](https://img.shields.io/badge/Status-In%20Progress-yellow?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Azure%20%2B%20On--Premise-0078D4?style=for-the-badge&logo=microsoftazure)
![Windows Server](https://img.shields.io/badge/Windows%20Server-2022-0078D4?style=for-the-badge&logo=windows)
![Active Directory](https://img.shields.io/badge/Active%20Directory-Hybrid-00B4D8?style=for-the-badge)

> A hands-on hybrid identity environment combining on-premises Active Directory with Microsoft Entra ID (Azure AD), covering real-world enterprise identity management, Group Policy, and cloud synchronization scenarios.

---

## 📋 Project Overview

This lab simulates a hybrid enterprise environment where on-premises Windows Server 2022 infrastructure integrates with Microsoft Azure Entra ID. The environment is built on VMware Workstation using two Windows Server 2022 VMs connected via an isolated Host-only network, with Azure Entra ID as the cloud identity platform.

The lab is designed to demonstrate skills relevant to the **AZ-800: Administering Windows Server Hybrid Core Infrastructure** certification and real-world enterprise administration.

---

## 🏗️ Architecture

```
lab.hybrid.local (192.168.10.0/24)
├── DC01 (192.168.10.10)
│   ├── Active Directory Domain Services
│   ├── DNS Server
│   ├── Group Policy Management
│   └── Entra Connect Sync (in progress)
└── SERVER02 (192.168.10.20)
    ├── Domain Member Server
    └── File and Storage Services (planned)

Cloud
└── Microsoft Entra ID (Azure AD)
    └── Hybrid Identity Sync (in progress)
```

---

## 🛠️ Technologies Used

| Technology | Purpose |
|---|---|
| VMware Workstation | Hypervisor for local lab VMs |
| Windows Server 2022 | On-premises infrastructure (DC01, SERVER02) |
| Active Directory Domain Services | Identity and authentication |
| DNS Server | Name resolution for domain |
| Group Policy (GPO) | Centralized policy management |
| Microsoft Entra ID | Cloud identity platform |
| Microsoft Entra Connect | Hybrid identity synchronization |
| PowerShell | Automation and configuration |

---

## 📁 Repository Structure

```
hybrid-identity-lab/
├── README.md
├── docs/
│   └── screenshots/
│       ├── 01-vmnet10-configured.png
│       ├── 02-dc01-vm-settings-iso.png
│       ├── 03-dc01-static-ip-configured.png
│       ├── 04-adds-role-installed.png
│       ├── 06-domain-controller-verified.png
│       ├── 07-ou-structure-created.png
│       ├── 08-test-users-created.png
│       ├── 09-server02-vm-created.png
│       ├── 10-server02-static-ip.png
│       ├── 11-server02-domain-join.png
│       ├── 12-server02-joined-domain.png
│       ├── 13-gpmc-opened.png
│       ├── 14-gpo-password-policy.png
│       ├── 15-gpo-lockout-policy.png
│       ├── 16-gpo-desktop-policy.png
│       ├── 17-gpresult-server02.png
│       ├── 18-gpmc-policies-overview.png
│       ├── 19-entra-tenant-domain.png
│       ├── 20-upn-suffix-added.png
│       ├── 21-users-upn-updated.png
│       ├── 23-aadconnect-installer-start.png
│       ├── 26-syncadmin-created.png
│       └── 27-aadconnect-signin-config.png
└── scripts/
    ├── dc01-initial-setup.ps1
    ├── create-ou-structure.ps1
    ├── create-test-users.ps1
    └── update-upn-suffix.ps1
```

---

## 🚀 Lab Progress

### ✅ Module 1 — VMware Environment Setup

Configured an isolated Host-only network (`VMnet10`, `192.168.10.0/24`) with DHCP disabled for manual IP management. Created the DC01 virtual machine with 2 vCPUs, 2GB RAM, and 60GB storage, attached to the Windows Server 2022 ISO.

| Screenshot | Description |
|---|---|
| ![01](docs/screenshots/01-vmnet10-configured.png) | VMnet10 Host-only network configured |
| ![02](docs/screenshots/02-dc01-vm-settings-iso.png) | DC01 VM settings with ISO attached |
| ![03](docs/screenshots/03-dc01-static-ip-configured.png) | Static IP 192.168.10.10 configured on DC01 |

---

### ✅ Module 2 — Active Directory Domain Services

Installed the AD DS role and promoted DC01 to Domain Controller for the `lab.hybrid.local` domain. Created a structured OU hierarchy and provisioned test users for later sync with Entra ID.

**Domain:** `lab.hybrid.local`
**NetBIOS Name:** `LAB`
**Domain Controller:** `DC01.lab.hybrid.local` (192.168.10.10)
**FSMO Roles:** All roles held by DC01 (SchemaMaster, DomainNamingMaster, PDCEmulator, RIDMaster, InfrastructureMaster)

**OU Structure:**
```
lab.hybrid.local
└── HybridLab
    ├── Users
    ├── Computers
    ├── Groups
    └── ServiceAccounts
```

**Test Users Created:**

| User | SAM Account | Department |
|---|---|---|
| Alice Johnson | alice.johnson | IT |
| Bob Smith | bob.smith | Finance |
| Carol White | carol.white | HR |

| Screenshot | Description |
|---|---|
| ![04](docs/screenshots/04-adds-role-installed.png) | AD DS role installation — Success |
| ![06](docs/screenshots/06-domain-controller-verified.png) | Domain controller verified via Get-ADDomain and Get-ADDomainController |
| ![07](docs/screenshots/07-ou-structure-created.png) | OU structure created in ADUC |
| ![08](docs/screenshots/08-test-users-created.png) | Test users created in OU=Users |

---

### ✅ Module 3 — SERVER02 Deployment and Domain Join

Created and configured a second Windows Server 2022 VM (SERVER02) as a domain member server. Assigned static IP `192.168.10.20` with DNS pointing to DC01, then joined the `lab.hybrid.local` domain.

| Screenshot | Description |
|---|---|
| ![09](docs/screenshots/09-server02-vm-created.png) | SERVER02 VM settings |
| ![10](docs/screenshots/10-server02-static-ip.png) | Static IP 192.168.10.20 assigned |
| ![11](docs/screenshots/11-server02-domain-join.png) | Domain join process |
| ![12](docs/screenshots/12-server02-joined-domain.png) | SERVER02 verified in AD — both DC01 and SERVER02 confirmed |

---

### ✅ Module 4 — Group Policy Objects (GPO)

Configured two GPOs to demonstrate centralized policy management across the domain. Verified GPO application on SERVER02 using `gpresult /r`.

**GPO 1 — Security-PasswordPolicy** (linked to domain root):

| Setting | Value |
|---|---|
| Minimum password length | 8 characters |
| Maximum password age | 90 days |
| Minimum password age | 1 day |
| Enforce password history | 5 passwords |
| Password complexity | Enabled |
| Account lockout threshold | 5 invalid attempts |
| Account lockout duration | 15 minutes |
| Reset lockout counter | 15 minutes |

**GPO 2 — User-DesktopPolicy** (linked to OU=HybridLab):

| Setting | Value |
|---|---|
| Prevent changing desktop background | Enabled |
| Screen saver timeout | 600 seconds |

| Screenshot | Description |
|---|---|
| ![13](docs/screenshots/13-gpmc-opened.png) | Group Policy Management Console |
| ![14](docs/screenshots/14-gpo-password-policy.png) | Password Policy settings |
| ![15](docs/screenshots/15-gpo-lockout-policy.png) | Account Lockout Policy settings |
| ![16](docs/screenshots/16-gpo-desktop-policy.png) | User Desktop Policy — Personalization settings |
| ![17](docs/screenshots/17-gpresult-server02.png) | GPO verification on SERVER02 — Security-PasswordPolicy applied |
| ![18](docs/screenshots/18-gpmc-policies-overview.png) | GPMC overview showing full GPO and OU structure |

---

### 🔄 Module 5 — Azure Entra ID Integration (In Progress)

Configured the Azure Entra ID tenant and began hybrid identity sync setup. Added the `onmicrosoft.com` UPN suffix to the on-premises AD forest and updated all user UPNs to match the cloud tenant domain, preparing them for synchronization.

**Tenant:** `kotsvagg83gmail.onmicrosoft.com`
**Sync Tool:** Microsoft Entra Connect Sync → migrating to Entra Cloud Sync
**Sync Method:** Password Hash Synchronization (PHS)

**UPN suffix added to AD forest:**
```
kotsvagg83gmail.onmicrosoft.com
```

**Users updated with cloud-compatible UPNs:**
```
alice.johnson@kotsvagg83gmail.onmicrosoft.com
bob.smith@kotsvagg83gmail.onmicrosoft.com
carol.white@kotsvagg83gmail.onmicrosoft.com
```

> ⚠️ **Note:** During Entra Connect Sync configuration, an `AADSTS700027` error was encountered — a known issue with expired service principal certificates on Entra Connect application registrations in free-tier tenants. Resolution: migrating to **Microsoft Entra Cloud Sync**, the modern recommended replacement for Connect Sync as of 2024. Cloud Sync configuration will be documented in the next update.

| Screenshot | Description |
|---|---|
| ![19](docs/screenshots/19-entra-tenant-domain.png) | Entra ID tenant overview — primary domain confirmed |
| ![20](docs/screenshots/20-upn-suffix-added.png) | UPN suffix added to AD forest |
| ![21](docs/screenshots/21-users-upn-updated.png) | All users updated with cloud-compatible UPN |
| ![23](docs/screenshots/23-aadconnect-installer-start.png) | Entra Connect Sync installer launched |
| ![26](docs/screenshots/26-syncadmin-created.png) | Dedicated sync admin account created in Entra ID |
| ![27](docs/screenshots/27-aadconnect-signin-config.png) | Sign-in configuration — UPN suffix mapping |

---

### 📋 Planned — Module 6 and Beyond

- [ ] Complete Entra Cloud Sync configuration and verify user sync
- [ ] Configure DHCP server role on DC01
- [ ] Deploy File Services role on SERVER02
- [ ] Configure DFS Namespace
- [ ] Deploy Hyper-V role on SERVER02
- [ ] Azure Arc integration for on-premises server management
- [ ] Azure Monitor / Defender for Cloud onboarding

---

## 🔑 Key Concepts Demonstrated

**Hybrid Identity** — Users exist simultaneously in on-premises AD and Azure Entra ID, synchronized via Entra Connect. This is the most common enterprise identity architecture for organizations in transition to the cloud.

**Domain Controller promotion** — Using `Install-ADDSForest` to configure a new AD forest, including DNS integration and FSMO role assignment.

**OU-based administration** — Organizing AD objects into Organizational Units to enable targeted Group Policy application and delegation of control.

**Group Policy** — Centralized enforcement of security baselines (password complexity, account lockout) and user experience settings across all domain-joined machines without touching them individually.

**UPN suffix alignment** — Ensuring on-premises user UPNs match the cloud tenant domain before sync — a critical prerequisite for hybrid identity to function correctly.

---

## ⚠️ Known Issues and Troubleshooting Notes

**AADSTS700027 — Expired certificate on Entra Connect application:**
During Entra Connect Sync setup, the installer failed with a service principal certificate expiry error. This is a known issue with specific versions of Connect Sync on free-tier tenants. Resolution: migrating to **Entra Cloud Sync**, which does not rely on the same certificate-based mechanism.

**Non-routable domain warning:**
The on-premises domain `lab.hybrid.local` uses a `.local` suffix which is non-routable and cannot be verified in Azure. This is expected in lab environments. Mitigation: add the `onmicrosoft.com` tenant domain as a UPN suffix in AD and update all user UPNs before sync.

---

## 🧰 PowerShell Scripts

### dc01-initial-setup.ps1
```powershell
# Rename computer and configure static IP
Rename-Computer -NewName "DC01" -Restart

New-NetIPAddress -InterfaceAlias "Ethernet0" -IPAddress 192.168.10.10 -PrefixLength 24 -DefaultGateway 192.168.10.1
Set-DnsClientServerAddress -InterfaceAlias "Ethernet0" -ServerAddresses 127.0.0.1
```

### create-ou-structure.ps1
```powershell
New-ADOrganizationalUnit -Name "HybridLab" -Path "DC=lab,DC=hybrid,DC=local"
New-ADOrganizationalUnit -Name "Users" -Path "OU=HybridLab,DC=lab,DC=hybrid,DC=local"
New-ADOrganizationalUnit -Name "Computers" -Path "OU=HybridLab,DC=lab,DC=hybrid,DC=local"
New-ADOrganizationalUnit -Name "Groups" -Path "OU=HybridLab,DC=lab,DC=hybrid,DC=local"
New-ADOrganizationalUnit -Name "ServiceAccounts" -Path "OU=HybridLab,DC=lab,DC=hybrid,DC=local"
```

### create-test-users.ps1
```powershell
$Users = @(
    @{Name="Alice Johnson"; SamAccount="alice.johnson"; Department="IT"},
    @{Name="Bob Smith"; SamAccount="bob.smith"; Department="Finance"},
    @{Name="Carol White"; SamAccount="carol.white"; Department="HR"}
)

$Password = ConvertTo-SecureString "UserPass@2024!" -AsPlainText -Force

foreach ($u in $Users) {
    New-ADUser `
        -Name $u.Name `
        -SamAccountName $u.SamAccount `
        -UserPrincipalName "$($u.SamAccount)@lab.hybrid.local" `
        -Path "OU=Users,OU=HybridLab,DC=lab,DC=hybrid,DC=local" `
        -Department $u.Department `
        -AccountPassword $Password `
        -Enabled $true `
        -PasswordNeverExpires $true
}
```

### update-upn-suffix.ps1
```powershell
# Add cloud UPN suffix to AD forest
Get-ADForest | Set-ADForest -UPNSuffixes @{Add="kotsvagg83gmail.onmicrosoft.com"}

# Update all users in HybridLab OU
$NewSuffix = "kotsvagg83gmail.onmicrosoft.com"
$Users = Get-ADUser -Filter * -SearchBase "OU=Users,OU=HybridLab,DC=lab,DC=hybrid,DC=local"

foreach ($user in $Users) {
    $NewUPN = $user.SamAccountName + "@" + $NewSuffix
    Set-ADUser $user -UserPrincipalName $NewUPN
}
```

---

*Part of my cybersecurity and infrastructure portfolio — [evangelos-kotsis.github.io/My-CV-Page](https://evangelos-kotsis.github.io/My-CV-Page/)*

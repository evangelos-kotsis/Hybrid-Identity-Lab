# Hybrid Identity Lab — On-Premises AD + Azure Entra ID

![Lab Status](https://img.shields.io/badge/Status-Completed-brightgreen)
![Azure](https://img.shields.io/badge/Azure-Entra%20ID-0078D4?logo=microsoft-azure)
![Windows Server](https://img.shields.io/badge/Windows%20Server-2022-0078D4?logo=windows)
![VMware](https://img.shields.io/badge/VMware-Workstation-607078?logo=vmware)

A hands-on hybrid identity and infrastructure lab combining on-premises Windows Server 2022 with Microsoft Azure Entra ID. Built to demonstrate enterprise-grade Active Directory, identity synchronization, networking, storage, virtualization, and cloud integration skills — aligned with **AZ-800** and **AZ-104** certification objectives.

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────┐
│              VMware Workstation (Host)               │
│                                                     │
│  ┌─────────────────┐    ┌─────────────────────────┐ │
│  │      DC01        │    │        SERVER02          │ │
│  │ 192.168.10.10   │    │    192.168.10.20         │ │
│  │                 │    │                          │ │
│  │ • AD DS         │◄──►│ • Domain Member          │ │
│  │ • DNS           │    │ • DHCP Server            │ │
│  │ • Group Policy  │    │ • File Services          │ │
│  │ • Entra Sync    │    │ • DFS Namespace          │ │
│  │ • Azure Arc     │    │ • Hyper-V Host           │ │
│  └────────┬────────┘    └──────────────────────────┘ │
│           │                VMnet10 (192.168.10.0/24)  │
└───────────┼─────────────────────────────────────────┘
            │ HTTPS
            ▼
┌─────────────────────────────────────────────────────┐
│                Microsoft Azure                       │
│                                                     │
│  • Entra ID (kotsvagg83gmail.onmicrosoft.com)       │
│  • Entra Cloud Sync                                 │
│  • Azure Arc (DC01 Connected)                       │
│  • Azure Monitor / Log Analytics                    │
│  • Microsoft Sentinel                               │
└─────────────────────────────────────────────────────┘
```

---

## Lab Environment

| Component | Details |
|-----------|---------|
| Hypervisor | VMware Workstation |
| OS | Windows Server 2022 Standard Evaluation |
| Domain | `lab.hybrid.local` |
| NetBIOS | `LAB` |
| DC01 IP | 192.168.10.10 |
| SERVER02 IP | 192.168.10.20 |
| Network | VMnet10 — Host-only (192.168.10.0/24) |
| Azure Tenant | kotsvagg83gmail.onmicrosoft.com |
| Azure Region | West Europe |

---

## Modules

| # | Module | Status |
|---|--------|--------|
| 1 | VMware Network & DC01 Setup | ✅ Complete |
| 2 | Active Directory Domain Services | ✅ Complete |
| 3 | SERVER02 Domain Join | ✅ Complete |
| 4 | Group Policy Objects | ✅ Complete |
| 5 | Azure Entra Cloud Sync | ✅ Complete |
| 6 | DHCP Server | ✅ Complete |
| 7 | File Services | ✅ Complete |
| 8 | DFS Namespace | ✅ Complete |
| 9 | Hyper-V | ✅ Complete |
| 10 | Azure Arc | ✅ Complete |
| 11 | Azure Monitor | ✅ Complete |

---

## Module 1 — VMware Network & DC01 Setup

Configured an isolated Host-only network (VMnet10) in VMware Workstation and deployed the first Windows Server 2022 VM (DC01) with a static IP.

**Key configurations:**
- VMnet10: 192.168.10.0/24, Host-only, DHCP disabled
- DC01: 4GB RAM, 60GB disk, static IP 192.168.10.10
- Windows Server 2022 Standard Evaluation

![VMnet10 Configured](docs/screenshots/01-vmnet10-configured.png)
![DC01 VM Settings](docs/screenshots/02-dc01-vm-settings-iso.png)
![DC01 Static IP](docs/screenshots/03-dc01-static-ip-configured.png)

---

## Module 2 — Active Directory Domain Services

Installed the AD DS role on DC01, promoted it to a domain controller, and built the OU structure with test users.

**Key configurations:**
- Domain: `lab.hybrid.local`
- OU Structure: `HybridLab > Users / Computers / Groups / ServiceAccounts`
- Test users: Alice Johnson, Bob Smith, Carol White
- UPN suffix: `kotsvagg83gmail.onmicrosoft.com`

![AD DS Role Installed](docs/screenshots/04-adds-role-installed.png)
![Domain Controller Verified](docs/screenshots/06-domain-controller-verified.png)
![OU Structure Created](docs/screenshots/07-ou-structure-created.png)
![Test Users Created](docs/screenshots/08-test-users-created.png)

---

## Module 3 — SERVER02 Domain Join

Deployed a second Windows Server 2022 VM (SERVER02) and joined it to the `lab.hybrid.local` domain.

**Key configurations:**
- SERVER02: Static IP 192.168.10.20
- Successfully joined to `lab.hybrid.local`
- Verified via `Get-ADComputer` on DC01

![SERVER02 VM Created](docs/screenshots/09-server02-vm-created.png)
![SERVER02 Static IP](docs/screenshots/10-server02-static-ip.png)
![SERVER02 Domain Join](docs/screenshots/11-server02-domain-join.png)
![SERVER02 Joined Domain](docs/screenshots/12-server02-joined-domain.png)

---

## Module 4 — Group Policy Objects

Created and linked two GPOs using Group Policy Management Console (GPMC) and verified policy application on SERVER02.

**GPOs created:**

| GPO | Linked To | Settings |
|-----|-----------|----------|
| Security-PasswordPolicy | Domain root | Min length 12, complexity, 60-day max age, 5 lockout attempts |
| User-DesktopPolicy | OU=HybridLab | Wallpaper, drive map, restricted Control Panel |

![GPMC Opened](docs/screenshots/13-gpmc-opened.png)
![GPO Password Policy](docs/screenshots/14-gpo-password-policy.png)
![GPO Lockout Policy](docs/screenshots/15-gpo-lockout-policy.png)
![GPO Desktop Policy](docs/screenshots/16-gpo-desktop-policy.png)
![GPResult SERVER02](docs/screenshots/17-gpresult-server02.png)
![GPMC Policies Overview](docs/screenshots/18-gpmc-policies-overview.png)

---

## Module 5 — Azure Entra Cloud Sync

Configured identity synchronization between on-premises Active Directory and Azure Entra ID using Microsoft Entra Cloud Sync (replacing the legacy Connect Sync due to certificate compatibility on free-tier tenants).

**Key configurations:**
- UPN suffix added: `kotsvagg83gmail.onmicrosoft.com`
- All user UPNs updated to match Azure tenant
- Sync admin account created: `syncadmin@kotsvagg83gmail.onmicrosoft.com`
- Entra Cloud Sync agent installed on DC01
- Sync configuration enabled and verified

![Entra Tenant Domain](docs/screenshots/19-entra-tenant-domain.png)
![UPN Suffix Added](docs/screenshots/20-upn-suffix-added.png)
![Users UPN Updated](docs/screenshots/21-users-upn-updated.png)
![Sync Admin Created](docs/screenshots/26-syncadmin-created.png)
![Cloud Sync Agents Empty](docs/screenshots/28-cloud-sync-agents-empty.png)
![Cloud Sync Agent Installer Start](docs/screenshots/29-cloud-sync-agent-installer-start.png)
![Cloud Sync Agent Confirm](docs/screenshots/30-cloud-sync-agent-confirm.png)
![Cloud Sync Agent Complete](docs/screenshots/31-cloud-sync-agent-complete.png)
![Cloud Sync Agent Active](docs/screenshots/32-cloud-sync-agent-active.png)
![Cloud Sync New Configuration](docs/screenshots/33-cloud-sync-new-configuration.png)
![Cloud Sync Configuration Created](docs/screenshots/34-cloud-sync-configuration-created.png)
![Cloud Sync Review Enable](docs/screenshots/35-cloud-sync-review-enable.png)
![Cloud Sync Configuration Enabled](docs/screenshots/36-cloud-sync-configuration-enabled.png)
![Cloud Sync Agent Service Running](docs/screenshots/37-cloud-sync-agent-service-running.png)
![Cloud Sync Network Adapters](docs/screenshots/38-cloud-sync-network-adapters.png)
![Cloud Sync Connectivity Test](docs/screenshots/39-cloud-sync-connectivity-test.png)

> **Note:** Microsoft Entra Connect Sync was initially attempted but failed with error AADSTS700027 (expired service principal certificate — known limitation on free-tier tenants). Entra Cloud Sync was used as the modern, lightweight alternative.

---

## Module 6 — DHCP Server

Installed the DHCP Server role on SERVER02 and configured a scope to serve IP addresses to lab clients.

**Key configurations:**
- DHCP role installed on SERVER02
- Scope: 192.168.10.100 – 192.168.10.200
- Subnet mask: 255.255.255.0
- Default gateway: 192.168.10.1

![DHCP Role Installed](docs/screenshots/40-dhcp-role-installed.png)
![DHCP Role Complete](docs/screenshots/41-dhcp-role-complete.png)
![DHCP Console](docs/screenshots/42-dhcp-console.png)
![DHCP Scope Created](docs/screenshots/43-dhcp-scope-created.png)

---

## Module 7 — File Services

Installed the File Services role on SERVER02 and created a shared folder accessible across the domain.

**Key configurations:**
- File and Storage Services role installed
- Shared folder: `SharedDocs`
- Share path: `\\SERVER02\SharedDocs`
- NTFS and Share permissions configured

![File Services Installed](docs/screenshots/44-file-services-installed.png)
![Shared Folder Created](docs/screenshots/45-shared-folder-created.png)
![Shared Folder Verified](docs/screenshots/46-shared-folder-verified.png)

---

## Module 8 — DFS Namespace

Configured a Distributed File System (DFS) Namespace to provide a unified path for shared resources across the domain.

**Key configurations:**
- DFS Namespace: `\\lab.hybrid.local\HybridLab`
- Namespace type: Domain-based
- Folder target: `\\SERVER02\SharedDocs` → mapped as `SharedDocs`

![DFS Management Console](docs/screenshots/47-dfs-management-console.png)
![DFS Namespace Created](docs/screenshots/48-dfs-namespace-created.png)
![DFS Folder Added](docs/screenshots/49-dfs-folder-added.png)

---

## Module 9 — Hyper-V

Enabled nested virtualization on SERVER02 within VMware Workstation and installed the Hyper-V role to demonstrate Windows Server virtualization capabilities.

**Key configurations:**
- VMware VT-x/EPT enabled on SERVER02 VM for nested virtualization
- Hyper-V role installed on SERVER02
- Virtual Switch created: `LabInternalSwitch` (Internal network)
- Nested VM created: `LabVM01` (Generation 1, 512MB RAM)

![Hyper-V VMware VTx Enabled](docs/screenshots/50-hyperv-vmware-vtx-enabled.png)
![Hyper-V Manager Open](docs/screenshots/51-hyperv-manager-open.png)
![Hyper-V Virtual Switch Created](docs/screenshots/52-hyperv-virtual-switch-created.png)
![Hyper-V VM Created](docs/screenshots/53-hyperv-vm-created.png)

---

## Module 10 — Azure Arc

Onboarded DC01 to Azure Arc, extending Azure management capabilities to the on-premises domain controller.

**Key configurations:**
- Azure Connected Machine Agent installed on DC01 via PowerShell script
- DC01 registered in Azure Arc as a connected machine
- Resource Group: `sentinel-lab-rg`, Region: West Europe
- Arc agent status: Connected
- FQDN: `DC01.lab.hybrid.local` visible in Azure portal

![Azure Arc Portal](docs/screenshots/54-azure-arc-portal.png)
![Azure Arc Agent Installing](docs/screenshots/55-azure-arc-agent-installing.png)
![Azure Arc DC01 Connected](docs/screenshots/56-azure-arc-dc01-connected.png)
![Azure Arc DC01 Details](docs/screenshots/57-azure-arc-dc01-details.png)

---

## Module 11 — Azure Monitor

Connected DC01 (via Azure Arc) to Azure Monitor and the existing Log Analytics Workspace, enabling hybrid cloud monitoring and telemetry collection from the on-premises domain controller.

**Key configurations:**
- Azure Monitor Agent configured on DC01 via Arc
- Log Analytics Workspace: `sentinel-lab-workspace`
- OpenTelemetry metrics enabled (CPU, memory, disk, network)
- Log-based metrics (classic) enabled
- Onboarding status: Successful

![Azure Arc DC01 Monitoring](docs/screenshots/58-azure-arc-dc01-monitoring.png)
![Azure Monitor Configure DC01](docs/screenshots/59-azure-monitor-configure-dc01.png)
![Azure Monitor Onboarding Successful](docs/screenshots/60-azure-monitor-onboarding-successful.png)

---

## Skills Demonstrated

| Category | Skills |
|----------|--------|
| Active Directory | AD DS installation, domain promotion, OU design, user management |
| Group Policy | GPO creation, linking, filtering, verification with gpresult |
| Hybrid Identity | UPN suffix configuration, Entra Cloud Sync, identity synchronization |
| Networking | Static IP configuration, DHCP scope management, DNS |
| File Services | SMB shares, NTFS permissions, DFS Namespace |
| Virtualization | VMware Workstation, Hyper-V nested virtualization, virtual switching |
| Azure Arc | On-premises server onboarding, connected machine agent |
| Azure Monitor | Log Analytics integration, metrics collection, hybrid monitoring |
| Security | Password policies, account lockout, GPO-based hardening |

---

## Repository Structure

```
Hybrid-Identity-Lab/
├── README.md
├── docs/
│   └── screenshots/          # 60 sequential lab screenshots
└── scripts/                  # PowerShell scripts used in lab
```

---

## Author

**Evangelos Kotsis**
System Administrator | Cloud Security Enthusiast

[![LinkedIn](https://img.shields.io/badge/LinkedIn-evangeloskotsis-0077B5?logo=linkedin)](https://linkedin.com/in/evangeloskotsis)
[![GitHub](https://img.shields.io/badge/GitHub-evangelos--kotsis-181717?logo=github)](https://github.com/evangelos-kotsis)
[![Portfolio](https://img.shields.io/badge/Portfolio-evank95.github.io-brightgreen)](https://evank95.github.io)

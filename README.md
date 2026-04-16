# 🚀 Microsoft Graph Group Membership Exporter

![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue)
![Microsoft Graph](https://img.shields.io/badge/Microsoft%20Graph-v1.0-green)
![License](https://img.shields.io/badge/License-MIT-yellow)
![Status](https://img.shields.io/badge/Status-Active-success)

## 📖 Overview

A powerful PowerShell script that exports **Microsoft Entra ID (Azure AD) group memberships** using the Microsoft Graph API.

This tool retrieves all groups in your tenant and exports their members into structured CSV reports for auditing, compliance, and analysis.

---

## ✨ Features

* 🔍 Retrieve **all groups** in your tenant
* 👥 Export **group members** (users, devices, service principals)
* 🔁 Support for **transitive (nested) memberships**
* 📊 Clean CSV outputs for reporting
* 📁 Auto-generated timestamped export folders
* ⚡ Built with Microsoft Graph PowerShell SDK
* 🛡️ Error handling for reliability

---

## 🛠️ Requirements

* PowerShell 5.1 or later
* Microsoft Graph PowerShell SDK:

```powershell
Install-Module Microsoft.Graph -Scope CurrentUser
```

### Required Permissions

* `Group.Read.All`
* `User.Read.All`

---

## 🔐 Authentication

The script uses Microsoft Graph authentication:

```powershell
Connect-MgGraph -Scopes "Group.Read.All","User.Read.All"
Select-MgProfile -Name "v1.0"
```

---

## ▶️ Usage

### Run Script

```powershell
.\Export-GraphGroups.ps1
```

### Custom Output Folder

```powershell
.\Export-GraphGroups.ps1 -OutputFolder "C:\Reports\Groups"
```

### Include Nested Group Members

```powershell
.\Export-GraphGroups.ps1 -TransitiveMembers
```

---

## 📂 Output Files

### 📄 GroupMembers.csv

| Column      | Description         |
| ----------- | ------------------- |
| GroupName   | Name of the group   |
| GroupId     | Unique group ID     |
| MemberId    | Member object ID    |
| DisplayName | Member display name |
| UPN         | User principal name |
| Type        | Object type         |

---

### 📄 Summary.csv

| Column    | Description       |
| --------- | ----------------- |
| GroupName | Name of the group |
| Count     | Total members     |

---

## 💡 Use Cases

* 🔐 Identity & access audits
* 📊 Compliance reporting
* 🛡️ Security reviews
* 🔄 Migration planning
* 📉 Group sprawl analysis

---

## ⚠️ Notes

* Transitive membership may increase runtime
* Some objects (devices/service principals) may not have UPN
* Ensure proper permissions for full data access

---

## 📸 Example Output Structure

```
GraphExport_20260416_120000/
│── GroupMembers.csv
│── Summary.csv
```

---

## 📈 Project Value

This project showcases:

* Microsoft Graph API integration
* Real-world automation use case
* Clean PowerShell scripting practices
* Enterprise-ready reporting solution

---

## 🤝 Contributing

Contributions are welcome! Feel free to fork the repo and submit a pull request.

---

## ⭐ Support

If you find this useful, consider giving it a star ⭐ on GitHub!

---

## 📜 License

MIT License

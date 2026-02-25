# Azure Landing Zone - Foundation ☁️

This repository contains the Bicep code for deploying a fundamental **Azure Landing Zone (ALZ)** hierarchy using a **centralized orchestrator** model.

## 🏗️ Architecture
Implementing a "Contoso" root structure with the following Management Groups:
- **Platform**: For shared services (Identity, Management, Connectivity).
- **Workload**: For business-specific applications.
- **Sandbox**: For testing and experimentation.

## ⚖️ Governance & Policy
Implemented automated guardrails to ensure cost control and compliance:
- **Allowed Regions**: Restricted to US and Canada to maintain data residency.
- **VM Size Restrictions**: Blocks expensive VM SKUs to optimize costs.
- **Centralized Logging**: A Log Analytics Workspace with a **31-day retention** policy for audit compliance.

## 🛠️ How to Deploy
Ensure you are authenticated via Azure CLI, then run:
```bash
az deployment tenant what-if \
  --location eastus \
  --template-file main.bicep \
  --parameters BasicSubscriptionId=$AZURE_SUBSCRIPTION_ID
 ```

## 🤖 CI/CD & Automation
Implemented a robust "Quality Gate" using GitHub Actions to ensure infrastructure reliability.
- **Passwordless Authentication (OIDC)**: Integrated Azure OpenID Connect to eliminate static secrets, enhancing security posture. 🔐
- **Automated Pre-flight Checks**: Every Pull Request triggers a validation workflow that checks for Bicep syntax and Azure policy compliance. ✅
- **Linting & Governance**: Ensures all code follows organizational standards before merging into the main branch. 🧹

## 🌐 Networking & Connectivity
This landing zone utilizes a **Hub-and-Spoke** topology to provide a scalable and secure network foundation.

### 🛰️ Architecture Details
* **Centralized Hub**: The `cloudcorp-hub-rg` contains the central connection point.
* **Azure Bastion**: Hosted within the Hub VNet on a dedicated `AzureBastionSubnet`. 🏰 It provides secure RDP/SSH access to VMs across the entire topology without exposing public IP addresses.
* **Isolated Spoke**: The `cloudcorp-workload-rg` hosts business applications. The spoke module is designed with `targetScope = 'resourceGroup'` for maximum reusability.
* **Dynamic Peering**: Connectivity is established via a custom bidirectional peering module. This module uses Bicep `outputs` to dynamically link networks across different Resource Groups, ensuring the Hub and Spoke are fully provisioned before linking. 🔗

### 🔡 IP Address Management (IPAM)
| Network | Address Space | Primary Subnet | Purpose |
| :--- | :--- | :--- | :--- |
| **Hub** | `10.0.0.0/16` | `10.0.1.0/24` | Management & Bastion |
| **Spoke** | `10.1.0.0/16` | `10.1.1.0/24` | Workload Applications |
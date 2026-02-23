# Azure Landing Zone - Foundation

This repository contains the Bicep code for deploying a fundamental **Azure Landing Zone (ALZ)** hierarchy. 

## 🏗️ Architecture
Implementing a "Contoso" root structure with the following Management Groups:
- **Platform**: For shared services (Identity, Management, Connectivity).
- **Workload**: For business-specific applications.
- **Sandbox**: For testing and experimentation.

## ⚖️ Governance & Policy
Implemented automated guardrails to ensure cost control and compliance:
- **Allowed Regions**: Restricted to US and Canada to maintain data residency.
- **VM Size Restrictions**: Blocks expensive VM SKUs to optimize costs.

## 🛠️ How to Deploy
Ensure you are authenticated via Azure CLI, then run:
```bash
az deployment tenant create --location EastUS --template-file main.bicep
 ```

## 🤖 CI/CD & Automation
Implemented a robust "Quality Gate" using GitHub Actions to ensure infrastructure reliability.
- **Passwordless Authentication (OIDC)**: Integrated Azure OpenID Connect to eliminate static secrets, enhancing security posture. 🔐
- **Automated Pre-flight Checks**: Every Pull Request triggers a validation workflow that checks for Bicep syntax and Azure policy compliance. ✅
- **Linting & Governance**: Ensures all code follows organizational standards before merging into the main branch. 🧹

## 🌐 Networking & Connectivity
This landing zone utilizes a **Hub-and-Spoke** topology to provide a scalable and secure network foundation.

### 🛰️ Architecture Details
* **Hub VNet (`vnet-hub-001`)**: Acts as the central connection point. It includes a dedicated **Azure Bastion** subnet for secure, seamless RDP/SSH access to resources without requiring public IP addresses.
* **Spoke VNet (`vnet-spoke-001`)**: Designed for isolated workloads. It communicates exclusively with the Hub, ensuring controlled and centralized traffic flow.
* **Automated Peering**: Connectivity is established via a custom bidirectional peering module. This module uses Bicep `outputs` to dynamically link the networks across different Resource Groups, removing the need for hard-coded resource names.

### 🔡 IP Address Management (IPAM)
| Network | Address Space | Primary Subnet | Purpose |
| :--- | :--- | :--- | :--- |
| **Hub** | `10.0.0.0/16` | `10.0.1.0/24` | Management & Bastion |
| **Spoke** | `10.1.0.0/16` | `10.1.1.0/24` | Workload Applications |
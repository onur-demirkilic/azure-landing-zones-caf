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

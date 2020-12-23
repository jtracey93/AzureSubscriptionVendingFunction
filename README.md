# Azure Subscription Vending Function - Azure Function (PowerShell Core)

This repository contains the below components:

| Component | Description | Path |
| --------- | ----------- | ---- |
| Terraform | IaC code used to deploy the required infrastructure to support the Azure Function. It also applies RBAC and deploys the Azure Function app from a the ZIP archive. | [terraform/](https://github.com/jtracey93/AzureSubscriptionVendingFunction/tree/master/terraform) |
| Azure Function Source Code | The source code for the Azure Function (PowerShell Core). The ZIP archive is built from these files | [CreateSubs/](https://github.com/jtracey93/AzureSubscriptionVendingFunction/tree/master/CreateSubs) & following files in the [root of the repository](https://github.com/jtracey93/AzureSubscriptionVendingFunction): '***.funcignore***', '***host.json***', '***profile.ps1***', '***proxies.json***' & '***requirements.psd1***'|
| Azure Function ZIP Archive | The ready to deploy ZIP archive of the Azure Function Source Code files as detailed above. This is used by Terraform local-exec. | [zipdeploy/](https://github.com/jtracey93/AzureSubscriptionVendingFunction/tree/master/zipdeploy) |

## Terraform Diagram
![Terraform Diagram](./terraform/tf-graph.svg)
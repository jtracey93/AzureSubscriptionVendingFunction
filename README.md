# Azure Subscription Vending Function - Azure Function (PowerShell Core)

This repository contains the below components:

| Component | Description | Path |
| :---------: | :-----------: | :----: |
| Terraform | IaC code used to deploy the required infrastructure to support the Azure Function. It also applies RBAC and deploys the Azure Function app from a the ZIP archive. | [terraform/](https://github.com/jtracey93/AzureSubscriptionVendingFunction/tree/master/terraform) |
| Azure Function Source Code | The source code for the Azure Function (PowerShell Core). The ZIP archive is built from these files | [CreateSubs/](https://github.com/jtracey93/AzureSubscriptionVendingFunction/tree/master/CreateSubs) & the following files in the [root of the repository](https://github.com/jtracey93/AzureSubscriptionVendingFunction): '***.funcignore***', '***host.json***', '***profile.ps1***', '***proxies.json***' & '***requirements.psd1***'|
| Azure Function ZIP Archive | The ready to deploy ZIP archive of the Azure Function Source Code files as detailed above. This is used by Terraform local-exec. | [zipdeploy/](https://github.com/jtracey93/AzureSubscriptionVendingFunction/tree/master/zipdeploy) |

## Pre-Requisites 

### Software/Packages

The below packages are required to be installed on the machine you will run this from, before trying to deploy this function:

1. [PowerShell Core](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.1#powershell)
2. [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
3. [Terraform](https://www.terraform.io/downloads.html)
4. [Git](https://git-scm.com/downloads)

If you are a [Chocolatey](https://chocolatey.org/) user then you can run the below commands to install these pre-requisites:

```
choco install powershell-core -y
choco install azure-cli -y
choco install terraform -y
choco install git -y
```

### Others

The other pre-requisites are as follows:

1. An Azure User account, **must be the same account**, that has access to the following:
   1. An Active Azure Subscription with the [Contributor RBAC role assigned](https://docs.microsoft.com/en-us/azure/role-based-access-control/role-assignments-portal#add-a-role-assignment)
       - This Subscription will be used to deploy the Azure Function into.
   2. An [Enterprise Agreement (EA) Account](https://docs.microsoft.com/en-us/azure/cost-management-billing/manage/ea-portal-administration#add-an-account) 
      - This will be the account that is used to deploy all the Subscriptions under on the EA by the Azure Function.

## Terraform Diagram

![Terraform Diagram](./terraform/tf-graph.png)

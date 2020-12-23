# Azure Subscription Vending Function - Azure Function (PowerShell Core)

This project hols everything you need to deploy and create an Azure Function, based on PowerShell Core, to assist in provisioning Azure EA (Enterprise Agreement) Subscriptions programmatically in an API style. This was born from working with customers primarily creating Enterprise Scale Landing Zones with Terraform as there is no resource for creating subscriptions within the Terraform AzureRM provider at this time.

> There is an open GitHub issue on the Terraform AzureRM provider repository to enable subscription creation via Terraform. [Issue Number 1216](https://github.com/terraform-providers/terraform-provider-azurerm/issues/1216)

> This only works for EA (Enterprise Agreement) Customers at this time. However the code could be amended for other supported subscription types like MCA or MPA. Please create a PR on this repo if you do use and amend this code :+1:

## Components

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
   1. An Active Azure Subscription with the [Contributor RBAC role assigned](https://docs.microsoft.com/en-gb/azure/role-based-access-control/role-assignments-portal#add-a-role-assignment)
       - This Subscription will be used to deploy the Azure Function into.
   2. An [Enterprise Agreement (EA) Account](https://docs.microsoft.com/en-gb/azure/cost-management-billing/manage/ea-portal-administration#add-an-account) 
      - This will be the account that is used to deploy all the Subscriptions under on the EA by the Azure Function.
      - This EA account should also have permissions to create EA Dev/Test Subscriptions. This can be done by following the process documented at: [Azure EA portal administration](https://docs.microsoft.com/en-gb/azure/cost-management-billing/manage/ea-portal-administration#enterprise-devtest-offer)
2. The Enrolment Account ID & Billing Account ID - See the [below section](#getting-ea-and-billing-ids) for details on how to get these
3. Login on the same local machine to the Azure CLI with the command: `az login`
   - To avoid SSO signing you in to the incorrect user account, open an InPrivate browser window and login to the [Azure Portal](https://portal.azure.com) as the required user account and then run `az login --use-device-code` to sign in as the correct user.
4. [Clone](https://docs.github.com/en/free-pro-team@latest/github/creating-cloning-and-archiving-repositories/cloning-a-repository) this git repo to the local machine where you wish to run this deployment from.

### Getting EA and Billing IDs

As you have seen from the second pre-requisite above, the EA Account ID & Billing Account ID are required to be passed in as inputs to terraform variables (either at runtime or by adding default values to the corresponding variables in the 'variables.tf' file.). To find these two ID's follow the below instructions:

1. Open an InPrivate browser window. (To avoid any SSO issues)
2. Login to the [Azure Portal](https://portal.azure.com) as the user account that meets the first pre-requisite requirement from above. (EA Account Owner & Access to Azure Subscription to deploy function too.)
3. Search for 'cost management' and open the 'Cost Management + Billing' blade:

![Cost Management](img/3.png)

4. You should be taken to the 'Billing scopes' blade within the 'Cost Management + Billing' blade, if not please select the 'Billing scopes' blade:

![Billing Scopes](img/4.png)

5. The Enrolment Account ID & Billing Account ID are shown on the 'Billing scopes' blade in the brackets "(xxx)" as shown in the screenshot below:
   - *The Enrolment Account ID is 6 digits & the Billing Account ID is 8 digits*

![IDs](img/5.png)

> Further information on this can be found in the Enterprise Scale documentation at [Enable Service Principal to create landing zones
](https://github.com/Azure/Enterprise-Scale/blob/main/docs/Deploy/enable-subscription-creation.md).
> The Enterprise Scale docs also walk through finding the above required IDs via PowerShell with the AZ module and also applying the RBAC permissions. However the RBAC assignment is handled by terraform in this repository, when the 2 required IDs are passed to it.

## Deployment Instructions

cd terraform
terraform apply
fill out variables using previous step information
use outputs

## Terraform Diagram

![Terraform Diagram](./terraform/tf-graph.png)

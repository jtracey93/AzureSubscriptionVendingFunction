variable "namePrefix" {
  type        = string
  description = "Resource Name Prefix"
}

variable "region" {
  type        = string
  description = "Region to deploy resources into. Use lowercase full names for regions e.g. 'northeurope'."
}

variable "defaultTags" {
  type = map
  default = {
    Service    = "Subscription Vending Machine"
    Version    = "2.0"
    Repoistory = "https://github.com/jtracey93/AzureSubscriptionVendingFunction"
    IaC-Tool   = "Terraform"
  }
}

variable "billingAccountID" {
  type        = string
  description = "Billing Account ID"
}

variable "enrolmentAccountID" {
  type        = string
  description = "Enrollment Account ID"
}

variable "managementGroupName" {
  type = string
  description = "Name (ID) of the Managmenent Group you wish this Azure Function to have permissions at to enable creating and placing subscription in your Management Group hierarchy. This is the ID of the Management Group as shown in the portal e.g. not the Display Name"
}

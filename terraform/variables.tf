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
    Version    = "1.0"
    Repoistory = "https://github.com/jtracey93/AzureSubscriptionVendingFunction"
    IaC-Tool   = "Terraform"
  }
}

variable "billingScopeResourceID" {
  type        = string
  description = "Resource ID of the Billing Scope for the Function App MSI to have access over."
}

variable "billingAccountID" {
  type        = string
  description = "Billing Account ID"
}

variable "enrolmentAccountID" {
  type        = string
  description = "Enrollment Account ID"
}

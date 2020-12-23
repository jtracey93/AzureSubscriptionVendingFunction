provider "azurerm" {
  features {}
  subscription_id = "a2de6e43-bd44-4dc1-85ff-4164522c66aa"
}

provider "null" {
}

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.40.0"
    }
    null = {
      source = "hashicorp/null"
      version = "3.0.0"
    }
  }
}
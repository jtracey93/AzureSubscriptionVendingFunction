provider "azurerm" {
  features {}
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
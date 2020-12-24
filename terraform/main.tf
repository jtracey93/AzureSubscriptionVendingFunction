resource "azurerm_resource_group" "sub-vending-rsg-001" {
  name     = "${var.namePrefix}-rsg-sub-vending-001"
  location = var.region
  tags     = var.defaultTags
}

resource "azurerm_storage_account" "sub-vending-sac-func-001" {
  name                     = "${var.namePrefix}sacfuncsubvending001"
  resource_group_name      = azurerm_resource_group.sub-vending-rsg-001.name
  location                 = var.region
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  account_replication_type = "LRS"
  tags                     = var.defaultTags
}

resource "azurerm_application_insights" "sub-vending-app-insi-001" {
  name                = "${var.namePrefix}-app-insi-sub-vending-001"
  resource_group_name = azurerm_resource_group.sub-vending-rsg-001.name
  location            = var.region
  tags                = var.defaultTags
  application_type    = "web"

}

resource "azurerm_app_service_plan" "sub-vending-app-svc-plan-001" {
  name                = "${var.namePrefix}-app-svc-plan-sub-vending-001"
  resource_group_name = azurerm_resource_group.sub-vending-rsg-001.name
  location            = var.region
  kind                = "FunctionApp"
  tags                = var.defaultTags

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "sub-vending-func-app-001" {
  name                = "${var.namePrefix}-func-app-sub-vending-001"
  resource_group_name = azurerm_resource_group.sub-vending-rsg-001.name
  location            = var.region

  storage_account_name       = azurerm_storage_account.sub-vending-sac-func-001.name
  storage_account_access_key = azurerm_storage_account.sub-vending-sac-func-001.primary_access_key

  app_service_plan_id = azurerm_app_service_plan.sub-vending-app-svc-plan-001.id

  version = "~3"

  tags = var.defaultTags

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME"       = "powershell"
    "FUNCTIONS_WORKER_RUNTIME_VERSION" = "~7"
    "FUNCTIONS_EXTENSION_VERSION" = "~3"
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.sub-vending-app-insi-001.instrumentation_key
  }

  lifecycle {
    ignore_changes = [app_settings]
  }
}

data "azurerm_function_app_host_keys" "sub-vending-func-app-001" {
  name                = azurerm_function_app.sub-vending-func-app-001.name
  resource_group_name = azurerm_resource_group.sub-vending-rsg-001.name
  
  depends_on = [
    azurerm_function_app.sub-vending-func-app-001
  ]
}

locals {
  roleAssignmentGUID = uuidv5(azurerm_function_app.sub-vending-func-app-001.identity[0].principal_id, "MSI")
}

resource "null_resource" "msi-rbac-assign" {
  depends_on = [azurerm_function_app.sub-vending-func-app-001]
  provisioner "local-exec" {
    command = <<EOT

      $roleAssignmentBody = '{"properties":{"principalId":"${azurerm_function_app.sub-vending-func-app-001.identity[0].principal_id}","roleDefinitionId":"/providers/Microsoft.Billing/billingAccounts/${var.billingAccountID}/enrollmentAccounts/${var.enrolmentAccountID}/billingRoleDefinitions/a0bcee42-bf30-4d1b-926a-48d21664ef71"}}'

      $roleAssignmentBodyParsed = $roleAssignmentBody | ConvertTo-Json -Depth 100

      az rest --method put --body $roleAssignmentBodyParsed --url https://management.azure.com/providers/Microsoft.Billing/billingAccounts/${var.billingAccountID}/enrollmentAccounts/${var.enrolmentAccountID}/billingRoleAssignments/${local.roleAssignmentGUID}?api-version=2019-10-01-preview

    EOT
    
    interpreter = ["pwsh", "-Command"]
  }
  
}

resource "null_resource" "deploy-function-app" {
  depends_on = [azurerm_function_app.sub-vending-func-app-001]
  provisioner "local-exec" {
    command = <<EOT

      az functionapp deployment source config-zip -g ${azurerm_resource_group.sub-vending-rsg-001.name} -n ${azurerm_function_app.sub-vending-func-app-001.name} --src ..\zipdeploy\Subscription-Vending-Function-v1.0.1.zip

    EOT
    
    interpreter = ["pwsh", "-Command"]
  }
  
}
output "sub-vending-func-app-001-host-default-key" {
    value = data.azurerm_function_app_host_keys.sub-vending-func-app-001.default_function_key
}

output "sub-vending-func-app-001-default-hostname" {
    value = azurerm_function_app.sub-vending-func-app-001.default_hostname
}
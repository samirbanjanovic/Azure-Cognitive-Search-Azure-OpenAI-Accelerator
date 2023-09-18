output "backendAppServicePlanName" {
  value = azurerm_app_service_plan.backend.name
}

output "backendWebAppName" {
  value = azurerm_linux_web_app.backend.name
}

output "botServiceName" {
  value = azurerm_bot_connection.backend.name
}

output "botDirectLineChannelKey" {
  value = azurerm_bot_connection.backend.direct_line_secret
}


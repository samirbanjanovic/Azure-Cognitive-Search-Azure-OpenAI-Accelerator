output "backendAppServicePlanName" {
  value = azurerm_service_plan.backend.name
}

output "backendWebAppName" {
  value = azurerm_linux_web_app.backend.name
}

output "botServiceName" {
  value = azurerm_bot_channels_registration.backend.name
}

output "botDirectLineChannelKey" {
  value     = ""
  sensitive = true
}

output "webAppName" {
    value = azurerm_linux_web_app.frontend.name
}

output "siteHost" {
    value = azurerm_linux_web_app.frontend.default_hostname
}

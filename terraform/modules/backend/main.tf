locals {
    botId = "bot-${random_string.random.result}"
    webAppName = "webApp-Backend-${local.botId}"
    siteHost = "${local.webAppName}.azurewebsites.net"
    botEndpoint = "https://${local.siteHost}/api/messages"
}

resource "random_string" "random" {
    length  = 5
    special = false
    upper   = false
    numeric = false
}

data "azurerm_search_service" "azureSearch" {
    name = var.azureSearchName
    resource_group_name = var.resourceGroupSearch
}
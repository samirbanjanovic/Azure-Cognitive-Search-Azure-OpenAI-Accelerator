output "azureSearchAPIKey" {
  value     = azurerm_search_service.datasource.primary_key
  sensitive = true
}

output "cosmosDBAccountName" {
  value = azurerm_cosmosdb_account.datasource.name
}

output "cosmosDBConnectionString" {
  value     = azurerm_cosmosdb_account.datasource.connection_strings[0]
  sensitive = true
}

output "blobStorageAccountName" {
  value = azurerm_storage_account.blobStorageAccount.name
}

output "blobStorageConnectionString" {
  value     = azurerm_storage_account.blobStorageAccount.primary_connection_string
  sensitive = true
}

output "blobSASToken" {
  value     = azurerm_storage_account.blobStorageAccount.primary_access_key
  sensitive = true
}

output "bingSearchEndpoint" {
  value = jsondecode(azapi_resource.bingSearchAccount.output).properties.endpoint
}

output "bingSearchName" {
  value = azapi_resource.bingSearchAccount.name
}

output "bingSearchAPIKey" {
  value     = jsondecode(data.azapi_resource_action.bingSearchAccount.output).key1
  sensitive = true
}

output "azureSearchName" {
  value = azurerm_search_service.datasource.name
}

output "azureSearchKey" {
  value     = azurerm_search_service.datasource.primary_key
  sensitive = true
}

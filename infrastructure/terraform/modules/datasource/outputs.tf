output "azureSearchAPIKey" {
  value     = azurerm_search_service.datasource.primary_key
  sensitive = true
}

output "cosmosDBAccountName" {
  value = azurerm_cosmosdb_account.datasource.name
}

output "cosmosDBConnectionString" {
  value     = azurerm_cosmosdb_account.datasource.connection_strings[0].connection_string
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

output "bingSearchAPIKey" {
  value     = azurerm_cognitive_account.bingSearchAccount.primary_access_key
  sensitive = true
}


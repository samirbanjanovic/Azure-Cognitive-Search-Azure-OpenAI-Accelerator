terraform {
  required_providers {
    azapi = {
      source = "azure/azapi"
    }
  }
}


resource "azurerm_search_service" "datasource" {
  name                          = var.azureSearchName
  resource_group_name           = var.resourceGroupName
  location                      = var.location
  sku                           = var.azureSearchSKU
  replica_count                 = var.azureSearchReplicaCount
  partition_count               = var.azureSearchPartitionCount
  hosting_mode                  = var.azureSearchHostingMode
  public_network_access_enabled = true
}

resource "azurerm_cognitive_account" "datasource" {
  name                = var.cognitiveServiceName
  location            = var.location
  resource_group_name = var.resourceGroupName
  sku_name            = var.cognitiveServiceSKU
  kind                = "CognitiveServices"

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_mssql_server" "datasource" {
  name                         = var.SQLServerName
  location                     = var.location
  resource_group_name          = var.resourceGroupName
  administrator_login          = var.SQLAdministratorLogin
  administrator_login_password = var.SQLAdministratorLoginPassword
  version                      = "12.0"
  minimum_tls_version          = "1.2"
}

resource "azurerm_mssql_firewall_rule" "allow_all_azure_ips" {
  name             = "AllowAllAzureIPs"
  server_id        = azurerm_mssql_server.datasource.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"

}

resource "azurerm_cosmosdb_account" "datasource" {
  name                = var.cosmosDBAccountName
  location            = var.location
  resource_group_name = var.resourceGroupName
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  capabilities {
    name = "EnableServerless"
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }


  consistency_policy {
    consistency_level       = "Session"
    max_interval_in_seconds = 5
    max_staleness_prefix    = 100
  }

  enable_free_tier                  = false
  enable_multiple_write_locations   = false
  is_virtual_network_filter_enabled = false
  enable_automatic_failover         = false
  public_network_access_enabled     = true
  analytical_storage_enabled        = false
}

resource "azurerm_cosmosdb_sql_database" "datasource" {
  name                = var.cosmosDBDatabaseName
  resource_group_name = var.resourceGroupName
  account_name        = azurerm_cosmosdb_account.datasource.name
}

resource "azurerm_cosmosdb_sql_container" "datasource" {
  name                = var.cosmosDBContainerName
  resource_group_name = var.resourceGroupName
  account_name        = azurerm_cosmosdb_account.datasource.name
  database_name       = azurerm_cosmosdb_sql_database.datasource.name
  partition_key_path  = "/user_id"
  default_ttl         = 1000
  conflict_resolution_policy {
    mode = "LastWriterWins"
  }
  lifecycle {
    ignore_changes = [
      conflict_resolution_policy[0].conflict_resolution_path
    ]
  }
}

resource "azapi_resource" "bingSearchAccount" {
  type                      = "Microsoft.Bing/accounts@2020-06-10"
  schema_validation_enabled = false
  name                      = var.bingSearchAPIName
  parent_id                 = var.resourceGroupId
  location                  = "global"
  body = jsonencode({
    sku = {
      name = "S1"
    }
    kind = "Bing.Search.v7"
  })
  response_export_values = ["*"]
}

# get the bing search api access keys
data "azapi_resource_action" "bingSearchAccount" {
  type        = "Microsoft.Bing/accounts@2020-06-10"
  resource_id = azapi_resource.bingSearchAccount.id
  action      = "listKeys"
  method      = "POST"
  response_export_values = ["*"]
}

resource "azurerm_cognitive_account" "formRecognizerAccount" {
  name                = var.formRecognizerName
  location            = var.location
  resource_group_name = var.resourceGroupName
  kind                = "FormRecognizer"
  sku_name            = "S0"
}

resource "azurerm_storage_account" "blobStorageAccount" {
  name                     = var.blobStorageAccountName
  location                 = var.location
  resource_group_name      = var.resourceGroupName
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


resource "azurerm_storage_container" "datasource" {
  for_each             = toset(["books", "cord19", "mixed"])
  name                 = each.key
  storage_account_name = azurerm_storage_account.blobStorageAccount.name
}

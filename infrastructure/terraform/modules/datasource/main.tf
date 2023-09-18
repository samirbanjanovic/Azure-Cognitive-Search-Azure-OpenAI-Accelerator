

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
  properties = {
    api_properties = {
      statistics_enabled = false
    }
  }
}

resource "azurerm_mssql_server" "datasource" {
  name                         = var.SQLServerName
  location                     = var.location
  resource_group_name          = var.resourceGroupName
  version                      = var.SQLVersion
  administrator_login          = var.SQLAdministratorLogin
  administrator_login_password = var.SQLAdministratorLoginPassword
}

resource "azurerm_sql_firewall_rule" "AllowAllAzureIPs" {
  name                = "AllowAllAzureIPs"
  resource_group_name = var.resourceGroupName
  server_name         = azurerm_mssql_server.datasource.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
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
  enable_public_network_access      = true
  enable_analytical_storage         = false
  enable_virtual_network            = false
}

resource "azurerm_cosmosdb_sql_database" "datasource" {
  name                = var.cosmosDBDatabaseName
  resource_group_name = var.resourceGroupName
  account_name        = azurerm_cosmosdb_account.datasource.name
  location            = var.location
  consistency_policy {
    consistency_level = "Session"
  }
}

resource "azurerm_cosmosdb_sql_container" "datasource" {
  name                = var.cosmosDBContainerName
  resource_group_name = var.resourceGroupName
  account_name        = azurerm_cosmosdb_account.datasource.name
  database_name       = azurerm_cosmosdb_sql_database.datasource.name
  partition_key_path  = ["/user_id"]
  default_ttl         = 1000
  conflict_resolution_policy {
    mode = "LastWriterWins"
  }
}

resource "azurerm_cognitive_account" "bingSearchAccount" {
  name                = var.bingSearchAPIName
  location            = "global"
  kind                = "Bing.Search.v7"
  sku_name            = "S1"
  resource_group_name = var.resourceGroupName
}

resource "azurerm_cognitive_account" "formRecognizerAccount" {
  name     = var.formRecognizerName
  location = var.location
  kind     = "FormRecognizer"

  sku {
    name = "S0"
  }
}

resource "azurerm_storage_account" "blobStorageAccount" {
  name                     = var.blobStorageAccountName
  location                 = var.location
  resource_group_name      = var.resourceGroupName
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_storage_account_blob_service_properties" "datasource" {
  storage_account_id = azurerm_storage_account.blobStorageAccount.id
  name               = "default"
}

resource "azurerm_storage_container" "datasource" {
  for_each             = toset(["books", "cord19", "mixed"])
  name                 = each.key
  storage_account_name = azurerm_storage_account.backend.name
}

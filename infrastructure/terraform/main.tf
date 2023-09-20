

locals {
  resourceGroupName      = "azureai-accelerate-${random_string.random.result}-rg"
  location               = "eastus"
  appName                = "azureai-accelerate"
  webAppName             = "azureai-accelerate-webapp-${random_string.random.result}"
  azureSearchName        = "azureai-accelerate-search-${random_string.random.result}"
  cognitiveServiceName   = "azureai-accelerate-cs-${random_string.random.result}"
  SQLServerName          = "sql-server-${random_string.random.result}"
  SQLServerDatabase      = "SampleDB"
  bingSearchAPIName      = "azureai-accelerate-bing-api-${random_string.random.result}"
  cosmosDBAccountName    = "azureai-accelerate-cosmosdb-${random_string.random.result}"
  cosmosDBDatabaseName   = "cosmosdb-database-${random_string.random.result}"
  cosmosDBContainerName  = "cosmosdb-container-${random_string.random.result}"
  formRecognizerName     = "azureai-accelerate-form-recognizer-${random_string.random.result}"
  blobStorageAccountName = "azaiaclrtblob${random_string.random.result}"
}

# create resource group for all resources
resource "azurerm_resource_group" "this" {
  name     = local.resourceGroupName
  location = local.location
}

# generate 5 character random lowercase string
resource "random_string" "random" {
  length  = 5
  special = false
  upper   = false
  numeric = false
}

data "azuread_client_config" "current" {}

# create application profile for the webapps
resource "azuread_application" "this" {
  display_name = local.webAppName
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_application_password" "this" {
  application_object_id = azuread_application.this.object_id
}

# create openai resource instance
module "openai" {
  source  = "Azure/openai/azurerm"
  version = "0.1.1"
  # insert the 2 required variables here
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  application_name    = local.appName
  deployment = {
    "gpt-35-turbo" = {
      name          = "gpt-35-turbo"
      model_format  = "OpenAI"
      model_name    = "gpt-35-turbo"
      model_version = "0613"
      scale_type    = "Standard"
    }
  }
  identity = {
    type = "SystemAssigned"
  }

  depends_on = [
    azurerm_resource_group.this
  ]
}



module "datasource" {
  source = "./modules/datasource"

  # resource placement 
  resourceGroupName = azurerm_resource_group.this.name
  resourceGroupId   = azurerm_resource_group.this.id
  location          = azurerm_resource_group.this.location

  # azure search
  azureSearchName           = local.azureSearchName
  azureSearchSKU            = "standard"
  azureSearchReplicaCount   = 1
  azureSearchHostingMode    = "default"
  azureSearchPartitionCount = 1

  # cognitive service
  cognitiveServiceName = local.cognitiveServiceName

  # sql server
  SQLServerName                 = local.SQLServerName
  SQLDBName                     = local.SQLServerDatabase
  SQLAdministratorLogin         = var.SQLAdministratorLogin
  SQLAdministratorLoginPassword = var.SQLAdministratorLoginPassword

  # bing search api
  bingSearchAPIName = local.bingSearchAPIName

  # cosmos db
  cosmosDBAccountName   = local.cosmosDBAccountName
  cosmosDBDatabaseName  = local.cosmosDBDatabaseName
  cosmosDBContainerName = local.cosmosDBContainerName

  # form recognizer
  formRecognizerName = local.formRecognizerName

  # blob storage
  blobStorageAccountName = local.blobStorageAccountName

  depends_on = [
    module.openai
  ]
}

module "backend" {
  source = "./modules/backend"

  # resource placement 
  resourceGroupName = azurerm_resource_group.this.name
  location          = azurerm_resource_group.this.location

  # identity
  appId       = azuread_application.this.application_id
  appPassword = azuread_application_password.this.value

  # blob storage
  blobSASToken = module.datasource.blobSASToken

  # azure search
  azureSearchName       = module.datasource.azureSearchName
  azureSearchKey        = module.datasource.azureSearchKey
  azureSearchAPIVersion = "2023-07-01-Preview"

  # openai
  azureOpenAIName   = local.appName
  azureOpenAIAPIKey = module.openai.openai_primary_key

  # bing search
  bingSearchName   = module.datasource.bingSearchName
  bingSearchAPIKey = module.datasource.bingSearchAPIKey

  # SQL
  SQLServerName     = local.SQLServerName
  SQLServerDatabase = local.SQLServerDatabase
  SQLServerUsername = var.SQLAdministratorLogin
  SQLServerPassword = var.SQLAdministratorLoginPassword

  # cosmos db
  cosmosDBAccountName      = local.cosmosDBAccountName
  cosmosDBContainerName    = local.cosmosDBContainerName
  cosmosDBConnectionString = module.datasource.cosmosDBConnectionString

  # bot
  botId = "${local.appName}-bot"

  # app service plan
  appServicePlanName = "${local.appName}-backend-sp"
  appServicePlanSKU  = "S3"

  depends_on = [
    module.datasource
  ]
}

module "frontend" {
  source = "./modules/frontend"

  # resource placement 
  resourceGroupName = azurerm_resource_group.this.name
  location          = azurerm_resource_group.this.location

  webAppName         = "${local.appName}-frontend"
  appServicePlanSKU  = "S3"
  appServicePlanName = "${local.appName}-frontend-sp"

  # bot service
  botServiceName          = module.backend.botServiceName
  botDirectLineChannelKey = module.backend.botDirectLineChannelKey

  # blob
  blobSASToken = module.datasource.blobSASToken

  # azure search
  azureSearchName       = module.datasource.azureSearchName
  azureSearchAPIVersion = "2023-07-01-Preview"
  azureSearchKey        = module.datasource.azureSearchAPIKey

  # open ai
  azureOpenAIName       = local.appName
  azureOpenAIAPIKey     = module.openai.openai_primary_key
  azureOpenAIModelName  = "gpt-35-turbo"
  azureOpenAIAPIVersion = "2023-05-15"

  depends_on = [
    module.datasource,
    module.backend
  ]

}

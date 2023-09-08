terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {
  features {

  }
}

locals {
  azureSearchName        = var.unique ? "${var.azureSearchName}-${random_string.random.result}" : var.azureSearchName
  cognitiveServiceName   = var.unique ? "${var.cognitiveServiceName}-${random_string.random.result}" : var.cognitiveServiceName
  SQLServerName          = var.unique ? "${var.SQLServerName}-${random_string.random.result}" : var.SQLServerName
  bingSearchAPIName      = var.unique ? "${var.bingSearchAPIName}-${random_string.random.result}" : var.bingSearchAPIName
  cosmosDBAccountName    = var.unique ? "${var.cosmosDBAccountName}-${random_string.random.result}" : var.cosmosDBAccountName
  cosmosDBDatabaseName   = var.unique ? "${var.cosmosDBDatabaseName}-${random_string.random.result}" : var.cosmosDBDatabaseName
  cosmosDBContainerName  = var.unique ? "${var.cosmosDBContainerName}-${random_string.random.result}" : var.cosmosDBContainerName
  formRecognizerName     = var.unique ? "${var.formRecognizerName}-${random_string.random.result}" : var.formRecognizerName
  blobStorageAccountName = var.unique ? "${var.blobStorageAccountName}-${random_string.random.result}" : var.blobStorageAccountName
}

# create resource group for all resources
resource "azurerm_resource_group" "this" {
  name     = var.resourceGroupName
  location = var.location
}

# generate 5 character random lowercase string
resource "random_string" "random" {
  length  = 5
  special = false
  upper   = false
  numeric = false
}

# create application profile for the webapps
resource "azuread_application" "app" {
  display_name = local.webAppName
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_application_password" "apppass" {
  application_object_id = azuread_application.example.object_id
}

# create openai resource instance
module "openai" {
  source  = "Azure/openai/azurerm"
  version = "0.1.1"
  # insert the 2 required variables here
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  application_name    = var.appName
  deployment = {
    "gpt-35-turbo" = {
      name          = "gpt-35-turbo"
      model_format  = "OpenAI"
      model_name    = "gpt-35-turbo"
      model_version = "0301"
      scale_type    = "Standard"
    }
  }
  identity = {
    type = "SystemAssigned"
  }
}

# create datasource module
module "datasource" {
  source = "./modules/datasource"

  # required parameters
  resourceGroupName = azurerm_resource_group.this.name
  location          = azurerm_resource_group.this.location

  # azure search
  azureSearchName         = local.azureSearchName
  azureSearchSKU          = "standard"
  azureSearchReplicaCount = 1
  azureSearchHostingMode  = "default"

  # cognitive service
  cognitiveServiceName = local.cognitiveServiceName

  # sql server
  SQLServerName                 = local.SQLServerName
  SQLDBName                     = var.SQLDBName
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
}

# create backend module
module "backend" {
  source = "./modules/backend"

  # required parameters
  resourceGroupName = azurerm_resource_group.this.name
  location          = azurerm_resource_group.this.location

  # identity
  appId       = azuread_application.app.application_id
  appPassword = azuread_application_password.apppass.value

  # blob storage
  blobSASToken = module.datasource.blobSASToken

  # azure search
  azureSearchName       = module.datasource.azureSearchName
  azureSearchKey        = module.datasource.azureSearchKey
  azureSearchAPIVersion = "2023-07-01-Preview"

  # openai
  azureOpenAIName   = var.appName
  azureOpenAIAPIKey = module.openai.openai_primary_key

  # bing search
  bingSearchName   = module.datasource.bingSearchName
  bingSearchAPIKey = module.datasource.bingSearchAPIKeyk

  # SQL
  SQLServerName     = local.SQLServerName
  SQLServerDatabase = var.SQLDBName
  SQLServerUsername = var.SQLAdministratorLogin
  SQLServerPassword = var.SQLAdministratorLoginPassword

  # cosmos db
  cosmosDBAccountName      = local.cosmosDBAccountName
  cosmosDBContainerName    = local.cosmosDBContainerName
  cosmosDBConnectionString = module.datasource.cosmosDBConnectionString

  # bot
  botId = "${var.appName}-bot"

  # app service plan
  appServicePlanName = var.appServicePlanName
  appServicePlanSKU  = var.appServicePlanSKU
}

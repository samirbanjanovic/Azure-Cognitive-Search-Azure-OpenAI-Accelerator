terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  azureSearchName =  var.unique ? "${var.azureSearchName}-${random_string.random.result}" : var.azureSearchName
  cognitiveServiceName =  var.unique ? "${var.cognitiveServiceName}-${random_string.random.result}" : var.cognitiveServiceName
  SQLServerName =  var.unique ? "${var.SQLServerName}-${random_string.random.result}" : var.SQLServerName
  bingSearchAPIName = var.unique ? "${var.bingSearchAPIName}-${random_string.random.result}" : var.bingSearchAPIName
  cosmosDBAccountName = var.unique ? "${var.cosmosDBAccountName}-${random_string.random.result}" : var.cosmosDBAccountName
  cosmosDBDatabaseName = var.unique ? "${var.cosmosDBDatabaseName}-${random_string.random.result}" : var.cosmosDBDatabaseName
  cosmosDBContainerName = var.unique ? "${var.cosmosDBContainerName}-${random_string.random.result}" : var.cosmosDBContainerName
  formRecognizerName = var.unique ? "${var.formRecognizerName}-${random_string.random.result}" : var.formRecognizerName
  blobStorageAccountName = var.unique ? "${var.blobStorageAccountName}-${random_string.random.result}" : var.blobStorageAccountName
}

# generate 5 character random lowercase string
resource "random_string" "random" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_resource_group" "rg" {
  name     = var.resourceGroupName
  location = var.location
}

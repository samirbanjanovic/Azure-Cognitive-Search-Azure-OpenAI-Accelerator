variable "resourceGroupName" {
  type        = string
  default     = "openai-rg"
  description = "Optional. The name of the resource group in which to create the resource. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  default     = "eastus"
  description = "Optional, defaults to eastus. The location of the resource group."
}

variable "azureSearchName" {
  type        = string
  default     = "openai-search"
  description = "Optional. Service name must only contain lowercase letters, digits or dashes, cannot use dash as the first two or last one characters, cannot contain consecutive dashes, and is limited between 2 and 60 characters in length."
  validation {
    condition     = length(var.azureSearchName) >= 2 && length(var.azureSearchName) <= 60 && can(regex("^[a-z0-9]+(-[a-z0-9]+)*$", var.azureSearchName))
    error_message = "Service name must only contain lowercase letters, digits or dashes, cannot use dash as the first two or last one characters, cannot contain consecutive dashes, and is limited between 2 and 60 characters in length."
  }
}

variable "azureSearchSKU" {
  type        = string
  default     = "standard"
  description = "Optional, defaults to standard. The pricing tier of the search service you want to create (for example, basic or standard)."
  validation {
    condition     = contains(["free", "basic", "standard", "standard2", "standard3", "storage_optimized_l1", "storage_optimized_l2"], var.azureSearchSKU)
    error_message = "Must be one of the following options: free, basic, standard, standard2, standard3, storage_optimized_l1, storage_optimized_l2"
  }
}

variable "azureSearchReplicaCount" {
  type        = number
  default     = 1
  description = "Optional, defaults to 1. Partitions allow for scaling of document count as well as faster indexing by sharding your index over multiple search units. Valid values are from 1 to 12 replicas."
  validation {
    condition     = var.azureSearchReplicaCount >= 1 && var.azureSearchReplicaCount <= 12
    error_message = "Must be a value between 1 and 12"
  }
}

variable "azureSearchHostingMode" {
  type        = string
  default     = "default"
  description = "Optional, defaults to default. Applicable only for SKUs set to standard3. You can set this property to enable a single, high density partition that allows up to 1000 indexes, which is much higher than the maximum indexes allowed for any other SKU."
  validation {
    condition     = contains(["default", "highDensity"], var.azureSearchHostingMode)
    error_message = "Must be one of the following options: default, highDensity"
  }
}

variable "cognitiveServiceName" {
  type        = string
  default     = "cognitive-service"
  description = "Optional. The name of our application. It has to be unique or use the unique flag to generate a random suffix."
}

variable "SQLServerName" {
  type        = string
  default     = "sql-server"
  description = "Optional. The name of the SQL logical server."
}

variable "SQLDBName" {
  type        = string
  default     = "SampleDB"
  description = "Optional. The name of the SQL database."
}

variable "SQLAdministratorLogin" {
  type        = string
  sensitive   = true
  description = "Required. The administrator username of the SQL logical server."
}

variable "SQLAdministratorLoginPassword" {
  type        = string
  sensitive   = true
  description = "Required. The administrator password of the SQL logical server."
}

variable "bingSearchAPIName" {
  type        = string
  default     = "bing-search-api"
  description = "Optional. The name of the Bing Search API resource."
}

variable "cosmosDBAccountName" {
  type        = string
  default     = "cosmosdb-account"
  description = "Optional. The name of the CosmosDB account."
  validation {
    condition     = length(var.cosmosDBAccountName) <= 44 && can(regex("^[a-z0-9]+(-[a-z0-9]+)*$", var.cosmosDBAccountName))
    error_message = "Must be lowercase and can only contain letters, numbers, and dashes. Max length is 44 characters."
  }
}

variable "cosmosDBDatabaseName" {
  type        = string
  default     = "cosmosdb-database"
  description = "Optional. The name of the CosmosDB database."
}

variable "cosmosDBContainerName" {
  type        = string
  default     = "cosmosdb-container"
  description = "Optional. The name of the CosmosDB container."
}

variable "formRecognizerName" {
  type        = string
  default     = "form-recognizer"
  description = "Optional. The name of the Form Recognizer resource."
}

variable "blobStorageAccountName" {
  type        = string
  default     = "blob-storage-account"
  description = "Optional. The name of the Blob Storage account."
}

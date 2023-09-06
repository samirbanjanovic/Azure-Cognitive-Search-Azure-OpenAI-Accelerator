variable "appId" {
  type        = string
  description = "Required. Active Directory App ID."
}

variable "appPassword" {
  type        = string
  sensitive   = true
  description = "Required. Active Directory App Secret Value."
}

variable "blobSASToken" {
  type        = string
  sensitive   = true
  description = "Required. The SAS token for the blob hosting your data."
}

variable "resourceGroupName" {
  type        = string
  description = "Required. Name of resource group."
}

variable "azureSearchName" {
  type        = string
  description = "Required. The name of the Azure Search service deployed previously."
}

variable "azureSearchKey" {
    type = string
    sensitive = true
    description = "Required. The API key for the Azure Search service deployed previously."
}

variable "azureSearchAPIVersion" {
  type    = string
  default = "2023-07-01-Preview"
}

variable "azureOpenAIName" {
  type        = string
  description = "Required. The name of the Azure OpenAI service deployed previously."
}

variable "azureOpenAIAPIKey" {
  type        = string
  sensitive   = true
  description = "Required. The API key for the Azure OpenAI service deployed previously."
}

variable "azureOpenAIModelName" {
  type        = string
  default     = "gpt-4"
  description = "'Optional. The model name for the Azure OpenAI service."
}

variable "azureOpenAIAPIVersion" {
  type    = string
  default = "2023-05-15"
}

variable "bingSearchUrl" {
  type        = string
  default     = "https://api.bing.microsoft.com/v7.0/search"
  description = "Optional. The URL for the Bing Search API."
}

variable "bingSearchAPIKey" {
  type = string
  sensitive = true
  description = "Required. The API key for the Bing Search API."
}

variable "bingSearchName" {
  type        = string
  description = "Required. The name of the Bing Search service deployed previously."
}

variable "SQLServerName" {
  type        = string
  description = "Required. The name of the SQL server deployed previously e.g. sqlserver.database.windows.net"
}

variable "SQLServerDatabase" {
  type        = string
  default     = "SampleDB"
  description = "Required. The name of the SQL database deployed previously. Defaults to SampleDB"
}

variable "SQLServerUsername" {
  type        = string
  sensitive   = true
  description = "Required. The username for the SQL Server."
}

variable "SQLServerPassword" {
  type        = string
  sensitive   = true
  description = "Required. The password for the SQL Server."
}

variable "cosmosDBAccountName" {
  type        = string
  description = "Required. The name of the Azure CosmosDB."
}

variable "cosmosDBContainerName" {
  type        = string
  description = "Required. The name of the Azure CosmosDB container."
}

variable "cosmosDBConnectionString" {
  type        = string
  sensitive   = true
  description = "Required. The connection string for the Azure CosmosDB."
}

variable "botId" {
  type        = string
  default = "BotId"
  description = "Required. The ID of the bot, a unique suffix will be appended during creation."
}

variable "botSKU" {
    type        = string
    default = "F0"
    description = "Optional, defaults to F0. The pricing tier of the Bot Service Registration. Acceptable values are F0 and S1."
    validation {
        condition = contains(["F0", "S1"], var.botSKU)
        error_message = "The pricing tier of the Bot Service Registration must be F0 or S1."
    }
}

variable "appServicePlanName" {
    type        = string
    default = "AppServicePlan-Backend-${random_string.random.result}"
    description = "Optional. The name of the App Service Plan."
}

variable "appServicePlanSKU" {
    type = string
    default = "S3"
    description = "Optional, defaults to S3. The SKU of the App Service Plan. Acceptable values are B3, S3 and P2v3."
    validation {
        condition = contains(["B3", "S3", "P2v3"], var.appServicePlanSKU)
        error_message = "The SKU of the App Service Plan must be B3, S3 or P2v3."
    }
}

variable "location" {
    type        = string
    default     = "eastus"
    description = "Optional, defaults to eastus. The location of the resources."
}

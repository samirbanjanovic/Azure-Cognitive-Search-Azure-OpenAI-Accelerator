variable "webAppName" {
  type        = string
  description = "Optional. Web app name must be between 2 and 60 characters."
  validation {
    condition     = length(var.webAppName) >= 2 && length(var.webAppName) <= 60
    error_message = "Web app name must be between 2 and 60 characters."
  }
}

variable "appServicePlanSKU" {
  type        = string
  default     = "S3"
  description = "Optional. The SKU of the App Service Plan. Acceptable values are B3, S3, or P2V3."
  validation {
    condition     = contains(["B3", "S3", "P2V3"], var.appServicePlanSKU)
    error_message = "The SKU of the App Service Plan must be B3, S3, or P2V3."
  }
}

variable "appServicePlanName" {
  type        = string
  default     = "AppServicePlan-Backend"
  description = "Optional. The name of the App Service Plan."
}

variable "botServiceName" {
  type        = string
  description = "Required. The name of the Bot Service."
}

variable "botDirectLineChannelKey" {
  type        = string
  sensitive   = true
  description = "Required. The Direct Line channel key."
}

variable "blobSASToken" {
  type        = string
  sensitive   = true
  description = "Required. The SAS token for the blob storage account hosting your data."
}

variable "resourceGroupName" {
  type        = string
  description = "Required. The name of the resource group where the resources (Azure Search etc.) where deployed previously."
}

variable "azureSearchName" {
  type        = string
  description = "Required. The name of the Azure Search instance."
}

variable "azureSearchAPIVersion" {
  type        = string
  default     = "2023-07-01-Preview"
  description = "Optional. The API version of the Azure Search instance."
}

variable "azureSearchKey" {
    type        = string
    sensitive   = true
    description = "Required. The API key for the Azure Search instance."
}

variable "azureOpenAIName" {
  type        = string
  description = "Required. The name of the Azure OpenAI resource deployed previously."
}
  
variable "azureOpenAIAPIKey" {
    type        = string
    sensitive   = true
    description = "Required. The API key for the Azure OpenAI resource deployed previously."
}

variable "azureOpenAIModelName" {
    type        = string
    default     = "gpt-4"
    description = "Optional. The model name for the Azure OpenAI resource."
}

variable "azureOpenAIAPIVersion" {
    type        = string
    default     = "2023-05-15"
    description = "Optional. The API version of the Azure OpenAI resource."
}

variable "location" {
    type        = string
    default     = "eastus"
    description = "Optional. The location of the resource group."
}


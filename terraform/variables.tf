variable "unique" {
  type = bool
  default = false
}
  
variable "azureSearchName" {
  type = string
  default = "openai-search"
  # validate the string is between 2 and 60 characters and that it's only lowercase letters, digits or dashes. Cannot use dash as the first two or last one characters, cannot contain consecutive dashes
    validation {
        condition = length(var.azureSearchName) >= 2 && length(var.azureSearchName) <= 60 && can(regex("^[a-z0-9]+(-[a-z0-9]+)*$", var.azureSearchName))
        error_message = "Optional. Service name must only contain lowercase letters, digits or dashes, cannot use dash as the first two or last one characters, cannot contain consecutive dashes, and is limited between 2 and 60 characters in length."
    }
}

variable "azureSearchSKU" {
  type = string
  default = "standard"
  validation {
    condition = contains(["free", "basic", "standard", "standard2", "standard3", "storage_optimized_l1", "storage_optimized_l2"], var.azureSearchSKU)
    error_message = "Optional, defaults to standard. The pricing tier of the search service you want to create (for example, basic or standard)."
  }
}

variable "azureSearchReplicaCount" {
  type = number
  default = 1
  validation {
    condition = var.azureSearchReplicaCount >= 1 && var.azureSearchReplicaCount <= 12
    error_message = "Optional, defaults to 1. Partitions allow for scaling of document count as well as faster indexing by sharding your index over multiple search units. Valid values are from 1 to 12 replicas."
  }
}

variable "azureSearchHostingMode" {
    type = string
    default = "default"
    validation {
        condition = contains(["default", "highDensity"], var.azureSearchHostingMode)
        error_message = "Optional, defaults to default. Applicable only for SKUs set to standard3. You can set this property to enable a single, high density partition that allows up to 1000 indexes, which is much higher than the maximum indexes allowed for any other SKU."
    }  
}



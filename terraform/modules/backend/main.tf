locals {
  botId       = "bot-${random_string.random.result}"
  webAppName  = "webApp-Backend-${local.botId}"
  siteHost    = "${local.webAppName}.azurewebsites.net"
  botEndpoint = "https://${local.siteHost}/api/messages"
}

resource "random_string" "random" {
  length  = 5
  special = false
  upper   = false
  numeric = false
}

# create a new linux app service plan for the supplied plan name and sku
resource "azurerm_app_service_plan" "appserviceplan" {
  name                = var.appServicePlanName
  location            = var.location
  resource_group_name = var.resourceGroupName
  os_type             = "Linux"
  sku_name            = var.appServicePlanSKU

  
}

# create a new web app with the supplied name and plan
resource "azurerm_linux_web_app" "webApp" {
  name                = local.webAppName
  location            = var.location
  resource_group_name = var.resourceGroupName
  app_service_plan_id = azurerm_app_service_plan.appserviceplan.id
  enabled                    = true
  client_affinity_enabled    = false
  client_certificate_enabled = false
    
  

  site_config {
    always_on = true
    use_32_bit_worker = true
    remote_debugging_enabled = false
    
    application_stack {
      python_version = "3.10"        
    }    
    load_balancing_mode = "LeastRequests"
    auto_heal_enabled = false
    minimum_tls_version = "1.2"
    ftps_state = "AllAllowed"
    websockets_enabled = false
    
    default_documents = [ 
      "Default.htm",
      "Default.html",
      "Default.asp",
      "index.htm",
      "index.html",
      "iisstart.htm",
      "default.aspx",
      "index.php",
      "hostingstart.html"
    ]
    app_command_line = "gunicorn --bind 0.0.0.0 --worker-class aiohttp.worker.GunicornWebWorker --timeout 600 app:APP"
    
    cors {
        allowed_origins = [
            "https://botservice.hosting.portal.azure.net",
            "https://hosting.onecloud.azure-test.net/"
        ]
    }        
  }

  app_settings = {
    MicrosoftAppId = var.appId
    MicrosoftAppPassword = var.appPassword
    BLOB_SAS_TOKEN = var.blobSASToken
    AZURE_SEARCH_ENDPOINT = "https://${var.azureSearchName}.search.windows.net"
    AZURE_SEARCH_KEY = var.azureSearchKey
    AZURE_SEARCH_API_VERSION = var.azureSearchAPIVersion
    AZURE_OPENAI_ENDPOINT = "https://${var.azureOpenAIName}.openai.azure.com"
    AZURE_OPENAI_KEY = var.azureOpenAIAPIKey
    AZURE_OPENAI_MODEL_NAME = var.azureOpenAIModelName
    AZURE_OPENAI_API_VERSION = var.azureOpenAIAPIVersion
    BING_SEARCH_URL = var.bingSearchUrl
    BING_SUBSCRIPTION_KEY = var.bingSearchAPIKey
    SQL_SERVER_NAME = var.SQLServerName
    SQL_SERVER_DATABASE_NAME = var.SQLServerDatabaseName
    SQL_SERVER_USERNAME = var.SQLServerUsername
    SQL_SERVER_PASSWORD = var.SQLServerPassword
    AZURE_COSMOSDB_ENDPOINT = "https://${var.cosmosDBAccountName}.documents.azure.com:443/"
    AZURE_COSMOSDB_NAME = var.cosmosDBAccountName
    AZURE_COSMOS_CONTAINER_NAME = var.cosmosDBContainerName
    AZURE_COSMOSDB_CONNECTION_STRING = var.cosmosDBConnectionString
    SCM_DO_BUILD_DURING_DEPLOYMENT = true
}

resource "azurerm_service_plan" "frontend" {
  name                = var.appServicePlanName
  location            = var.location
  resource_group_name = var.resourceGroupName
  os_type             = "Linux"
  sku_name            = var.appServicePlanSKU
}


# create a new web app with the supplied name and plan
resource "azurerm_linux_web_app" "frontend" {
  name                       = var.webAppName
  location                   = var.location
  resource_group_name        = var.resourceGroupName
  service_plan_id            = azurerm_service_plan.frontend.id
  enabled                    = true
  client_affinity_enabled    = false
  client_certificate_enabled = false



  site_config {
    always_on                = true
    use_32_bit_worker        = true
    remote_debugging_enabled = false
    app_command_line         = "python -m streamlit run Home.py --server.port 8000 --server.address 0.0.0.0"
    application_stack {
      python_version = "3.10"
    }
    load_balancing_mode = "LeastRequests"

    minimum_tls_version = "1.2"
    ftps_state          = "AllAllowed"
    websockets_enabled  = false
  }

  app_settings = {
    BOT_SERVICE_NAME               = var.botServiceName
    BOT_DIRECTLINE_SECRET_KEY      = var.botDirectLineChannelKey
    BLOB_SAS_TOKEN                 = var.blobSASToken
    AZURE_SEARCH_ENDPOINT          = "https://${var.azureSearchName}.search.windows.net"
    AZURE_SEARCH_KEY               = var.azureSearchKey
    AZURE_SEARCH_API_VERSION       = var.azureSearchAPIVersion
    AZURE_OPENAI_ENDPOINT          = "https://${var.azureOpenAIName}.openai.azure.com"
    AZURE_OPENAI_KEY               = var.azureOpenAIAPIKey
    AZURE_OPENAI_MODEL_NAME        = var.azureOpenAIModelName
    AZURE_OPENAI_API_VERSION       = var.azureOpenAIAPIVersion
    SCM_DO_BUILD_DURING_DEPLOYMENT = true
  }
}

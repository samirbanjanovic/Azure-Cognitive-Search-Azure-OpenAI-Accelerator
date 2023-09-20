output "bing_key" {
  value     = module.datasource.bingSearchAPIKey
  sensitive = true
}

output "bing_endpoint" {
  value = module.datasource.bingSearchEndpoint
}

###########################################
# Stock - Terraform #
###########################################

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.24.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "#{Project.Multi-Tenant.RandomQuotes.ResourceGroup.Name}"
    storage_account_name = "#{Project.Multi-Tenant.RandomQuotes.StorageAccount.Name}"
    container_name       = "#{Project.Multi-Tenant.RandomQuotes.StorageContainer.Name}"
    key                  = "terraform.tfstate"
  }
}
provider "azurerm" {
  features {}
}

###########################################
# Azure SQL #
###########################################

# SQL Server #

resource "azurerm_mssql_server" "asorkin_rq_mssql_server" {
  name                         = "#{Project.Multi-Tenant.RandomQuotes.MSSQL.Server}"
  resource_group_name             = "#{Project.Multi-Tenant.RandomQuotes.ResourceGroup.Name}"
  location                        = "#{Project.Multi-Tenant.PrimaryLocation.Name}"
  version                      = "12.0"
  administrator_login          = "#{Project.Multi-Tenant.RandomQuotes.DB.User}"
  administrator_login_password = "#{Project.Multi-Tenant.RandomQuotes.DB.Password}"
  minimum_tls_version             = "1.2"
  public_network_access_enabled   = true
}

resource "azurerm_mssql_firewall_rule" "allow-octopus-server" {
  depends_on = [ azurerm_mssql_server.asorkin_rq_mssql_server ]
  name                = "allow-octopus-server"
  server_id         = azurerm_mssql_server.asorkin_rq_mssql_server.id
  start_ip_address = "4.227.214.210"
  end_ip_address   = "4.227.214.210"
}

resource "azurerm_mssql_firewall_rule" "allow-azure-resources" {
  depends_on = [ azurerm_mssql_server.asorkin_rq_mssql_server ]
  name                = "allow-azure-resources"
  server_id         = azurerm_mssql_server.asorkin_rq_mssql_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}


# SQL Databases #

resource "azurerm_mssql_database" "RandomQuotes_Customer1_Production" {
  depends_on = [ azurerm_mssql_server.asorkin_rq_mssql_server ]
  name           = "RandomQuotes_MT_Customer1_Production"
  server_id      = azurerm_mssql_server.asorkin_rq_mssql_server.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 1
  read_scale     = false
  sku_name       = "S0"
  zone_redundant = false
  tags = {
    tenant      = "Customer1"
    environment = "Production"    	
  }
}

resource "azurerm_mssql_database" "RandomQuotes_Customer2_Production" {
  depends_on = [ azurerm_mssql_server.asorkin_rq_mssql_server ]
  name           = "RandomQuotes_MT_Customer2_Production"
  server_id      = azurerm_mssql_server.asorkin_rq_mssql_server.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 1
  read_scale     = false
  sku_name       = "S0"
  zone_redundant = false
  tags = {
    tenant      = "Customer2"  
    environment = "Production"    	
  }
}

resource "azurerm_mssql_database" "RandomQuotes_Customer3_Production" {
  depends_on = [ azurerm_mssql_server.asorkin_rq_mssql_server ]
  name           = "RandomQuotes_MT_Customer3_Production"
  server_id      = azurerm_mssql_server.asorkin_rq_mssql_server.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 1
  read_scale     = false
  sku_name       = "S0"
  zone_redundant = false
  tags = {
    tenant      = "Customer3"
    environment = "Production"    	
  }
}

resource "azurerm_mssql_database" "RandomQuotes_Internal_Development" {
  depends_on = [ azurerm_mssql_server.asorkin_rq_mssql_server ]
  name           = "RandomQuotes_MT_Internal_Development"
  server_id      = azurerm_mssql_server.asorkin_rq_mssql_server.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 1
  read_scale     = false
  sku_name       = "S0"
  zone_redundant = false
  tags = {
    tenant      = "Internal"
    environment = "Development"    	
  }
}

resource "azurerm_mssql_database" "RandomQuotes_Internal_QA" {
  depends_on = [ azurerm_mssql_server.asorkin_rq_mssql_server ]
  name           = "RandomQuotes_MT_Internal_QA"
  server_id      = azurerm_mssql_server.asorkin_rq_mssql_server.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 1
  read_scale     = false
  sku_name       = "S0"
  zone_redundant = false
  tags = {
    tenant      = "Internal"
    environment = "QA"    	
  }
}

resource "azurerm_mssql_database" "RandomQuotes_Internal_Staging" {
  depends_on = [ azurerm_mssql_server.asorkin_rq_mssql_server ]
  name           = "RandomQuotes_MT_Internal_Staging"
  server_id      = azurerm_mssql_server.asorkin_rq_mssql_server.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 1
  read_scale     = false
  sku_name       = "S0"
  zone_redundant = false
  tags = {
    tenant      = "Internal"
    environment = "Staging"    	
  }
}

###########################################
# Azure Service Plan #
###########################################

resource "azurerm_service_plan" "asorkin_rq_sp" {
  name                         = "#{Project.Multi-Tenant.RandomQuotes.ServicePlan.Name}"
  resource_group_name          = "#{Project.Multi-Tenant.RandomQuotes.ResourceGroup.Name}"
  location                     = "#{Project.Multi-Tenant.PrimaryLocation.Name}"
  os_type                      = "Linux"
  sku_name = "B1"
}
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
    resource_group_name  = "#{Project.Azure.RandomQuotes.ResourceGroup.Name}"
    storage_account_name = "#{Project.Azure.RandomQuotes.StorageAccount.Name}"
    container_name       = "#{Project.Azure.RandomQuotes.StorageContainer.Name}"
    key                  = "terraform.tfstate"
  }
}
provider "azurerm" {
  features {}
}

###########################################
# Resource Group #
###########################################

resource "azurerm_resource_group" "asorkin-rg1" {
  name     = "#{Project.Azure.RandomQuotes.ResourceGroup.Name}"
  location = "#{Project.Azure.PrimaryLocation.Name}"
  tags = {
    environment = "#{Octopus.Environment.Name}"    	
  }
}

###########################################
# Storage Account #
###########################################

resource "azurerm_storage_account" "asorkinsa1" {
  name                            = "#{Project.Azure.RandomQuotes.StorageAccount.Name}"
  resource_group_name             = "#{Project.Azure.RandomQuotes.ResourceGroup.Name}"
  location                        = "#{Project.Azure.PrimaryLocation.Name}"
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  tags = {
    environment = "#{Octopus.Environment.Name}"    	
  }
}

###########################################
# Azure SQL #
###########################################

# SQL Server #

  resource "azurerm_mssql_server" "asorkin_rq_mssql_server" {
    name                         = "asorkin_rq_mssql_server"
    resource_group_name          = azurerm_resource_group.asorkin-rg1.name
    location                     = azurerm_resource_group.asorkin-rg1.location
    version                      = "12.0"
    administrator_login          = "#{Project.Azure.RandomQuotes.DB.User}"
    administrator_login_password = "#{Project.Azure.RandomQuotes.DB.Password}"
    minimum_tls_version             = "1.2"
    public_network_access_enabled   = true
    tags = {
      environment = "#{Octopus.Environment.Name}"    	
    }
  }

# SQL Database #

  resource "azurerm_mssql_database" "asorkin_rq_database" {
    name           = "#{Project.Azure.RandomQuotes.DB.Name}"
    server_id      = azurerm_mssql_server.asorkin_rq_mssql_server.id
    collation      = "SQL_Latin1_General_CP1_CI_AS"
    license_type   = "LicenseIncluded"
    max_size_gb    = 1
    read_scale     = false
    sku_name       = "S0"
    zone_redundant = false
    tags = {
        environment = "#{Octopus.Environment.Name}"    	
    }
  }

###########################################
# Azure Service Plan #
###########################################

  resource "azurerm_service_plan" "asorkin_rq_sp" {
    name                         = "asorkin_rq_sp"
    resource_group_name          = azurerm_resource_group.asorkin-rg1.name
    location                     = azurerm_resource_group.asorkin-rg1.location
    sku {
      tier = "Standard"
      size = "S1"
    tags = {
      environment = "#{Octopus.Environment.Name}"    	
    }  
  }
}

###########################################
# Azure Windows Web App #
###########################################

  resource "azurerm_windows_web_app" "asorkin_rq_web_app" {
    name                = "asorkin_rq_web_app"
    resource_group_name          = azurerm_resource_group.asorkin-rg1.name
    location                     = azurerm_resource_group.asorkin-rg1.location
    service_plan_id     = azurerm_app_service_plan.asorkin_rq_sp.id
  
    site_config {}

    tags = {
      octopus-environment = "#{Octopus.Environment.Name}"
    	octopus-space = "#{Octopus.Space.Name}"
    	octopus-role = "#{Project.Azure.RandomQuotes.Role}"
    }
  }

###########################################
# Azure Windows Web App Slot #
###########################################

 resource "azurerm_windows_web_app_slot" "staging" {
  name           = "staging"
  app_service_id = azurerm_windows_web_app.asorkin_rq_web_app.id

  site_config {}
}

 resource "azurerm_windows_web_app_slot" "production" {
  name           = "production"
  app_service_id = azurerm_windows_web_app.asorkin_rq_web_app.id

  site_config {}
}
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.21.1"
    }
  }

  backend "azurerm" {
    resource_group_name  = "#{Project.RandomQuotes.Azure.ResourceGroupName}"
    storage_account_name = "#{Project.RandomQuotes.Azure.StorageAccount.Name}"
    container_name       = "#{Project.RandomQuotes.Azure.StorageContainer.Name}"
    key                  = "markh-rq-#{Octopus.Environment.Name | ToLower}-terraform.tfstate"
  }
}
provider "azurerm" {
  features {}
}

locals {

  // Azure Variables
  resourceGroupName     = "#{Project.RandomQuotes.Azure.ResourceGroupName}"
  resourceGroupLocation = "#{Azure.US.Primary.Location.Name}"
  
  // Az WebApp details
  azAppServicePlanName = "#{Project.RandomQuotes.AzureServicePlan.Name}"
  azWebAppName         = "#{Project.RandomQuotes.AzureWebApp.Name}"
  
  // Octopus tags
  resourceOwner        = "mark.harrison@octopus.com"
  octopusTargetRole    = "randomquotes-azwebapp"
  octopusEnvironment   = "#{Octopus.Environment.Name | ToLower}"
}

resource "azurerm_service_plan" "randomquotes-azure-appserviceplan" {
  name                = local.azAppServicePlanName
  location            = local.resourceGroupLocation
  resource_group_name = local.resourceGroupName

  os_type  = "Linux"
  sku_name = "B1"
  
  tags = {
    "owner" = local.resourceOwner
  }
}

resource "azurerm_linux_web_app" "rq-azwebapp-#{Octopus.Environment.Name | ToLower}" {
  name                = local.azWebAppName
  location            = local.resourceGroupLocation
  resource_group_name = local.resourceGroupName
  service_plan_id     = azurerm_service_plan.randomquotes-azure-appserviceplan.id

  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
  }

  tags = {
    "octopus-environment" = local.octopusEnvironment
    "octopus-role"        = local.octopusTargetRole
    "owner"               = local.resourceOwner
  }
}
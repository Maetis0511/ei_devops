locals {
  env = {
    default = {
      vm_size = "Standard_B1s"
      cidr    = "10.0.0.0/16"
    }
    dev = {
      vm_size = "Standard_B1s"
      cidr    = "10.1.0.0/16"
    }
    prod = {
      vm_size = "Standard_D2s_v3"
      cidr    = "10.2.0.0/16"
    }
  }

  workspace_config = local.env[terraform.workspace]

  project_name = "ei-devops-${terraform.workspace}"
}

resource "azurerm_resource_group" "rg" {
  name     = "${local.project_name}-rg"
  location = var.location
}

module "network" {
  source = "./modules/network"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  vnet_name           = "${local.project_name}-vnet"
  vm_name             = "${local.project_name}-vm"

  address_space       = local.workspace_config.cidr
}

module "compute" {
  source = "./modules/compute"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  vm_name             = "${local.project_name}-vm"

  subnet_id           = module.network.subnet_id

  vm_size             = local.workspace_config.vm_size
}

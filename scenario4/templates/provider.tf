terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.76"
    }

    http = {
      source  = "hashicorp/http"
      version = "3.1.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    virtual_machine_scale_set {
      roll_instances_when_required = false
    }
  }
}
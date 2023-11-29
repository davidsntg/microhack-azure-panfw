variable "location" {
  type    = string
  default = "West Europe"
}

variable "resource_group_name" {
  type    = string
  default = "rg-panfw-scenario2"
}

variable "vnet_hub_name" {
  type    = string
  default = "hub-vnet"
}

variable "vnet_hub_address_space" {
  type    = string
  default = "10.0.0.0/24"
}

variable "vnet_spoke01_name" {
  type    = string
  default = "spoke01-vnet"
}

variable "vnet_spoke01_address_space" {
  type    = string
  default = "10.0.1.0/24"
}

variable "vnet_spoke02_name" {
  type    = string
  default = "spoke02-vnet"
}

variable "vnet_spoke02_address_space" {
  type    = string
  default = "10.0.2.0/24"
}

variable "firewall_vm_name" {
  type    = string
  default = "panfw-vm"
}

variable "allow_inbound_mgmt_ips" {
  default = ""
  type    = string
}

variable "common_vmseries_sku" {
  description = "VM-Series SKU - list available with `az vm image list -o table --all --publisher paloaltonetworks`"
  default     = "byol"
  type        = string
}

variable "common_vmseries_version" {
  description = "VM-Series PAN-OS version - list available with `az vm image list -o table --all --publisher paloaltonetworks`"
  default     = "latest"
  type        = string
}

variable "common_vmseries_vm_size" {
  description = "Azure VM size (type) to be created. Consult the *VM-Series Deployment Guide* as only a few selected sizes are supported."
  default     = "Standard_D3_v2"
  type        = string
}

variable "username" {
  description = "Initial administrative username to use for all systems."
  default     = "panadmin"
  type        = string
}

variable "password" {
  description = "Initial administrative password to use for all systems. Set to null for an auto-generated password."
  default     = "Microsoft=1Microsoft=1"
  type        = string
}

variable "avzones" {
  type    = list(string)
  default = ["1", "2", "3"]
}

variable "enable_zones" {
  type    = bool
  default = false
}

variable "vm_size" {
  type        = string
  default     = "Standard_DS1_v2"
  description = "VM Size"
}

variable "vm_os_publisher" {
  type        = string
  default     = "canonical"
  description = "VM OS Publisher"
}

variable "vm_os_offer" {
  type = string
  #default = "UbuntuServer"
  default     = "0001-com-ubuntu-server-jammy"
  description = "VM OS Offer"
}

variable "vm_os_sku" {
  type        = string
  default     = "22_04-lts-gen2"
  description = "VM OS Sku"
}

variable "vm_os_version" {
  type        = string
  default     = "latest"
  description = "VM OS Version"
}

locals {
  custom_script_spoke01 = <<CUSTOM_DATA
  #cloud-config
  package_upgrade: true
  runcmd:
    - while true; do ping -c 1 10.0.2.4; sleep 20; done  
  CUSTOM_DATA

  custom_script_spoke02 = <<CUSTOM_DATA
  #cloud-config
  package_upgrade: true
  runcmd:
    - while true; do ping -c 1 10.0.1.4; sleep 20; done  
  CUSTOM_DATA
}


output "paloalto_vmseries_01_dns" {
  value = "https://${azurerm_public_ip.fw_mgmt_pip.fqdn}"
}

output "paloalto_username" {
  value = var.username
}

# Use "terraform output paloalto_password" to get the password after terraform apply
output "paloalto_password" {
  value     = coalesce(var.password, random_password.password.result)
  sensitive = true
}
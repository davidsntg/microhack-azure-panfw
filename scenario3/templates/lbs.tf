# Internal Load Balancer - Trusted

resource "azurerm_lb" "trusted_ilb" {
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  name                = "panfw-trusted-ilb"
  sku                 = "Standard"
  frontend_ip_configuration {
    name      = "panfw-trusted-ilb-ip"
    subnet_id = azurerm_subnet.subnet_pan_trusted.id
  }
  depends_on = [module.paloalto_vmseries_01, module.paloalto_vmseries_02]
}

resource "azurerm_lb_backend_address_pool" "trusted_ilb_backendpool" {
  name            = "trusted_ilb_backend-pool"
  loadbalancer_id = azurerm_lb.trusted_ilb.id
}

resource "azurerm_network_interface_backend_address_pool_association" "trusted_01" {
  network_interface_id    = module.paloalto_vmseries_01.interfaces["${var.firewall_vm_name}-01-trusted"].id
  ip_configuration_name   = "primary"
  backend_address_pool_id = azurerm_lb_backend_address_pool.trusted_ilb_backendpool.id
}

resource "azurerm_network_interface_backend_address_pool_association" "trusted_02" {
  network_interface_id    = module.paloalto_vmseries_02.interfaces["${var.firewall_vm_name}-02-trusted"].id
  ip_configuration_name   = "primary"
  backend_address_pool_id = azurerm_lb_backend_address_pool.trusted_ilb_backendpool.id
}

resource "azurerm_lb_probe" "trusted_ilb_probe" {
  loadbalancer_id     = azurerm_lb.trusted_ilb.id
  name                = "trusted-ilb-probe"
  port                = 443
  protocol            = "Https"
  request_path        = "/php/login.php"
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_lb_rule" "trusted_ilb_rules" {
  name                           = "all-ports"
  loadbalancer_id                = azurerm_lb.trusted_ilb.id
  protocol                       = "All"
  frontend_port                  = 0
  backend_port                   = 0
  frontend_ip_configuration_name = "panfw-trusted-ilb-ip"
  idle_timeout_in_minutes        = 5
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.trusted_ilb_backendpool.id]
  probe_id                       = azurerm_lb_probe.trusted_ilb_probe.id
}

# External Load Balancer - Untrusted

resource "azurerm_lb" "untrusted_elb" {
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  name                = "panfw-untrusted-elb"
  sku                 = "Standard"
  frontend_ip_configuration {
    name                 = "panfw-untrusted-elb-ip"
    public_ip_address_id = azurerm_public_ip.fws_untrusted_pip.id
  }
  depends_on = [module.paloalto_vmseries_01, module.paloalto_vmseries_02]
}

resource "azurerm_lb_backend_address_pool" "untrusted_elb_backendpool" {
  name            = "untrusted_elb_backend-pool"
  loadbalancer_id = azurerm_lb.untrusted_elb.id
}

resource "azurerm_network_interface_backend_address_pool_association" "untrusted_01" {
  network_interface_id    = module.paloalto_vmseries_01.interfaces["${var.firewall_vm_name}-01-untrusted"].id
  ip_configuration_name   = "primary"
  backend_address_pool_id = azurerm_lb_backend_address_pool.untrusted_elb_backendpool.id
}

resource "azurerm_network_interface_backend_address_pool_association" "untrusted_02" {
  network_interface_id    = module.paloalto_vmseries_02.interfaces["${var.firewall_vm_name}-02-untrusted"].id
  ip_configuration_name   = "primary"
  backend_address_pool_id = azurerm_lb_backend_address_pool.untrusted_elb_backendpool.id
}

resource "azurerm_lb_probe" "untrusted_elb_probe" {
  loadbalancer_id     = azurerm_lb.untrusted_elb.id
  name                = "untrusted-elb-probe"
  port                = 22
  protocol            = "Tcp"
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_lb_rule" "untrusted_elb_rules" {
  name                           = "TCP-22"
  loadbalancer_id                = azurerm_lb.untrusted_elb.id
  protocol                       = "Tcp"
  frontend_port                  = 22
  backend_port                   = 22
  frontend_ip_configuration_name = "panfw-untrusted-elb-ip"
  idle_timeout_in_minutes        = 5
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.untrusted_elb_backendpool.id]
  probe_id                       = azurerm_lb_probe.untrusted_elb_probe.id
  disable_outbound_snat          = true
}

resource "azurerm_lb_outbound_rule" "untrusted_elb_outbound_rules" {
  name            = "untrusted-elb-outbound-rule"
  loadbalancer_id = azurerm_lb.untrusted_elb.id
  frontend_ip_configuration {
    name = "panfw-untrusted-elb-ip"
  }
  allocated_outbound_ports = 1000
  idle_timeout_in_minutes  = 5
  protocol                 = "All"
  backend_address_pool_id  = azurerm_lb_backend_address_pool.untrusted_elb_backendpool.id
}

resource "azurerm_resource_group" "rg" {
  name     = "spark"
  location = var.location
  tags = var.tags
}

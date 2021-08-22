variable "storage_account_name" {
  type = string
  default = "tfeastus2tfusecase"
}
variable "resource_group_name" {
  type = string
  default = "tfstate"
}

variable "location" {
  type = string
  default = "eastus2"
}
variable "tags" {
  description = "tags to be applied to resources"
  type        = map(string)
  default     = {
    Location    = "eastus2"
    Environment = "Production"
    Provider    = "Azure"


  }
}
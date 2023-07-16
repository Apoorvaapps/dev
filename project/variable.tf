variable "resource_group_location" {
   description = "Location of the resource group"
    type        = string 
}

variable "resource_group_name" {
    description = "name of the resource group"
    type        = string
}

variable "instance_count" {
    description = "Number of instance to provision."
    type        = number
}

variable "databaseserver_count" {
    description = "Number of database server to provision."
    type        = number
}

variable "admin_username" {
  type        = string
  description = "The administrator username of the SQL logical server."
  #default     = "azureadmin"
}

variable "admin_password" {
  type        = string
  description = "The administrator password of the SQL logical server."
  sensitive   = true
  #default     = "password@123"
}
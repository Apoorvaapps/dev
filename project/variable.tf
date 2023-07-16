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

variable "vmadmin_username" {
  type        = string
  description = "The administrator username of the SQL logical server."
  #default    = "vmuser123"
}

variable "vmadmin_password" {
  type        = string
  description = "The administrator password of the SQL logical server."
  sensitive   = true
  #default    = "password@768954"
}

variable "sqladmin_username" {
  type        = string
  description = "The administrator username of the SQL logical server."
  #default     = "sqladmin123"
}

variable "sqladmin_password" {
  type        = string
  description = "The administrator password of the SQL logical server."
  sensitive   = true
  #default     = "password@14532"
}
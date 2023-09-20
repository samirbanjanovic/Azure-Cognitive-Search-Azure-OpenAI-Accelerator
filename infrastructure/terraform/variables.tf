variable "SQLAdministratorLogin" {
    type        = string
    sensitive   = true
    description = "Required. The administrator username of the SQL logical server."
}

variable "SQLAdministratorLoginPassword" {
    type        = string
    sensitive   = true
    description = "Required. The administrator password of the SQL logical server."
}
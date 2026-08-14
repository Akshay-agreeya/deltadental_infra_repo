variable "server_dbs" {}

variable "db_admin_password" {
  description = "Administrator password for the MSSQL server. Mark as sensitive to prevent exposure in logs and state."
  type        = string
  sensitive   = true
}

variable "servers_dbs" {
  description = "Map of MSSQL server configurations. The administrator_login_password field is intentionally absent; use the db_admin_password variable instead."
  type        = any
}

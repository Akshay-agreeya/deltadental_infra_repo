variable "subscription_id" {
  description = "Azure Subscription ID. Supply via TF_VAR_subscription_id or a secrets-managed tfvars file — never hardcode this value."
  type        = string
  sensitive   = true
}

variable "dev_acrs" {}
variable "dev_aks" {}
variable "servers_dbs" {}

variable "db_admin_password" {
  description = "Administrator password for the MSSQL server. Supply via TF_VAR_db_admin_password or a secrets-managed tfvars file — never hardcode this value."
  type        = string
  sensitive   = true
}



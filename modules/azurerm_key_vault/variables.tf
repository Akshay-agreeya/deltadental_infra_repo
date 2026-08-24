variable "key_vaults" {
  description = "Azure Key Vault configurations keyed by deployment name."
  type        = map(any)
}

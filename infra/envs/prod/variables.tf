variable "subscription_id" {
  description = "Azure subscription this environment is deployed to. Set it with TF_VAR_subscription_id or a terraform.tfvars file kept out of Git."
  type        = string
}

variable "location" {
  description = "Azure region for every resource in this environment."
  type        = string
  default     = "westeurope"
}

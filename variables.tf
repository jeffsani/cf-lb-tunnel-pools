variable "cloudflare_api_token" {
  description = "Cloudflare API Token with permissions for Zero Trust, Zone, and Load Balancing."
  type        = string
  sensitive   = true
}

variable "cloudflare_account_id" {
  description = "The Cloudflare Account ID."
  type        = string
}

variable "cloudflare_zone_id" {
  description = "The Cloudflare Zone ID where the Load Balancer will be created."
  type        = string
}

variable "lb_hostname" {
  description = "The FQDN for the Load Balancer (e.g., app.example.com)."
  type        = string
}

variable "primary_tunnel_name" {
  description = "Name of the primary tunnel."
  type        = string
  default     = "lb-tunnel-primary"
}

variable "primary_tunnel_cidr" {
  description = "CIDR range for the primary tunnel private route."
  type        = string
  default     = "10.0.1.0/24"
}

variable "failover_tunnel_name" {
  description = "Name of the failover tunnel."
  type        = string
  default     = "lb-tunnel-failover"
}

variable "failover_tunnel_cidr" {
  description = "CIDR range for the failover tunnel private route."
  type        = string
  default     = "10.0.2.0/24"
}

variable "CLOUDFLARE_API_KEY" {
  description = "Your Cloudflare API Token with appropriate permissions."
  type        = string
}

variable "CLOUDFLARE_EMAIL" {
  description = "Your Cloudflare account email."
  type        = string
}

variable "terraform_cloud_org" {
  description = "Terraform Cloud Organization name."
  type        = string
}

variable "terraform_cloud_workspace" {
  description = "Terraform Cloud Workspace name."
  type        = string
}
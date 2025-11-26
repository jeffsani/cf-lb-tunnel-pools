# Helper locals to construct the token manually
locals {
  primary_token = base64encode(jsonencode({
    a = var.cloudflare_account_id
    t = cloudflare_zero_trust_tunnel_cloudflared.primary.id
    s = random_id.tunnel_secret.b64_std
  }))

  failover_token = base64encode(jsonencode({
    a = var.cloudflare_account_id
    t = cloudflare_zero_trust_tunnel_cloudflared.failover.id
    s = random_id.tunnel_secret.b64_std
  }))
}

output "primary_tunnel_id" {
  value = cloudflare_zero_trust_tunnel_cloudflared.primary.id
}

output "primary_tunnel_token" {
  description = "Token to connect the Primary Tunnel daemon"
  value       = local.primary_token
  sensitive   = true
}

output "failover_tunnel_id" {
  value = cloudflare_zero_trust_tunnel_cloudflared.failover.id
}

output "failover_tunnel_token" {
  description = "Token to connect the Failover Tunnel daemon"
  value       = local.failover_token
  sensitive   = true
}

output "load_balancer_hostname" {
  value = var.lb_hostname
}
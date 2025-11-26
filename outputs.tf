# Requirement #8: Output tunnel IDs and tokens

output "primary_tunnel_id" {
  description = "ID of the Primary Tunnel"
  value       = cloudflare_zero_trust_tunnel_cloudflared.primary.id
}

output "primary_tunnel_token" {
  description = "Token to connect the Primary Tunnel daemon"
  value       = cloudflare_zero_trust_tunnel_cloudflared.primary.tunnel_token
  sensitive   = true
}

output "failover_tunnel_id" {
  description = "ID of the Failover Tunnel"
  value       = cloudflare_zero_trust_tunnel_cloudflared.failover.id
}

output "failover_tunnel_token" {
  description = "Token to connect the Failover Tunnel daemon"
  value       = cloudflare_zero_trust_tunnel_cloudflared.failover.tunnel_token
  sensitive   = true
}

output "load_balancer_hostname" {
  value = var.lb_hostname
}
//Use terraform output -raw primary_tunnel_token to get the token value without quotes from the cli
//Use terraform output -raw primary_tunnel_id to get the tunnel ID value without quotes from the cli
//Use terraform output -raw failover_tunnel_token to get the token value without quotes from the cli
//Use terraform output -raw failover_tunnel_id to get the tunnel ID value without quotes from the cli

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
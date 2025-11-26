

# --- 0. Helper: Generate Tunnel Secrets ---
# Tunnels require a 32-byte base64 encoded secret. We generate this automatically.
resource "random_id" "tunnel_secret" {
  byte_length = 32
}

# --- 1. Create Cloudflare Tunnels (Requirement #3) ---

resource "cloudflare_zero_trust_tunnel_cloudflared" "primary" {
  account_id = var.cloudflare_account_id
  name       = var.primary_tunnel_name
  secret     = random_id.tunnel_secret.b64_std
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "failover" {
  account_id = var.cloudflare_account_id
  name       = var.failover_tunnel_name
  secret     = random_id.tunnel_secret.b64_std
}

# --- 2. Create Tunnel Routes (Requirement #4) ---

resource "cloudflare_zero_trust_tunnel_cloudflared_route" "primary_route" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.primary.id
  network    = var.primary_tunnel_cidr
  comment    = "Route for Primary LB Tunnel"
}

resource "cloudflare_zero_trust_tunnel_cloudflared_route" "failover_route" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.failover.id
  network    = var.failover_tunnel_cidr
  comment    = "Route for Failover LB Tunnel"
}

# --- 3. Create LB Monitor (Requirement #7) ---

resource "cloudflare_load_balancer_monitor" "http_monitor" {
  account_id     = var.cloudflare_account_id
  type           = "http"
  method         = "GET"
  path           = "/"
  expected_codes = "2xx"
  timeout        = 5
  interval       = 60
  retries        = 2
  description    = "Basic HTTP Monitor for Tunnels"
}

# --- 4. Create LB Pools (Requirement #2 & #5) ---

resource "cloudflare_load_balancer_pool" "primary_pool" {
  account_id = var.cloudflare_account_id
  name       = "${var.primary_tunnel_name}-pool"
  monitor    = cloudflare_load_balancer_monitor.http_monitor.id

  origins {
    name    = "primary-tunnel-origin"
    # Logic: {tunnel-id}.cfargotunnel.com
    address = "${cloudflare_zero_trust_tunnel_cloudflared.primary.id}.cfargotunnel.com"
    weight  = 1
    enabled = true
  }
}

resource "cloudflare_load_balancer_pool" "failover_pool" {
  account_id = var.cloudflare_account_id
  name       = "${var.failover_tunnel_name}-pool"
  monitor    = cloudflare_load_balancer_monitor.http_monitor.id

  origins {
    name    = "failover-tunnel-origin"
    # Logic: {tunnel-id}.cfargotunnel.com
    address = "${cloudflare_zero_trust_tunnel_cloudflared.failover.id}.cfargotunnel.com"
    weight  = 1
    enabled = true
  }
}

# --- 5. Create Load Balancer (Requirement #1 & #6) ---

resource "cloudflare_load_balancer" "lb" {
  zone_id          = var.cloudflare_zone_id
  name             = var.lb_hostname
  
  # Requirement: Configure 1 pool as primary
  default_pool_ids = [cloudflare_load_balancer_pool.primary_pool.id]
  
  # Requirement: Configure the other pool as failover
  fallback_pool_id = cloudflare_load_balancer_pool.failover_pool.id
  
  description      = "LB with Tunnel Backends"
  proxied          = true
  steering_policy  = "off" # Use default pool order (Failover logic)
}
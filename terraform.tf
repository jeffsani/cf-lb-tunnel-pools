terraform {

  cloud {
    organization = var.terraform_cloud_org
    workspaces {
      name = var.terraform_cloud_workspace
    }
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.13.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "cloudflare" {
    email = var.CLOUDFLARE_EMAIL
    api_key = var.CLOUDFLARE_API_KEY
}

# Helper locals to construct the token manually
# These calculate the tokens based on resources defined in main.tf.

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
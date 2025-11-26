![Cloudflare logo](https://imagedelivery.net/EdT7o-fMhJAc7fBSjFjrJQ/aa4e77f8-4845-4551-771e-91ac54342e00/square "Cloudflare")

<H1>Terraform Scripts to Automate the Deployment of Cloudflare Load Balancer, HA Pools, Pool Monitor and CF Tunnels as Endpoints</H1>
<H2>Description</H2>
This set of terraform files and linux script automates the setup of a Cloudflare Load Balancer, Primary and Failover LB Pools, Pool Monitor, Cloudflare Tunnel, and Tunnel Routes.  The outputs include the public URL to access the Load Balancer, the tunnel ids and tokens which you will pass to a linux script/command line used to install a Cloudflare Tunnel instance or replica.  An example shell script to use on the target host is also provided. 

<H2>Prerequisites:</H2>
 - You must have an active Cloudflare Zone (domain)
 - Install Terraform (or use Terraform Cloud)
 - Set your Cloudflare API Token/API Key/Email Address as an environment variables

<H2>Configure Terraform:</H2>
 - Place all .tf files in a new directory.
 - Copy terraform.tfvars.example to terraform.tfvars.
 - Edit terraform.tfvars with your specific values (Account ID, Zone ID, hostname, etc.).
 - add *.tfvars to your .gitignore (or equivalent) if using version control

<H2>Apply Terraform:</H2>
 - Run terraform init to initialize the provider.
 - Run terraform apply to create the Cloudflare resources.
 - Review the plan and type yes when prompted.
 - After it completes, Terraform will output the primary and secondary tunnel tokens as well as the lb host name

<H2>Install Tunnel on Linux Host:</H2>
 - Copy the install_fips_tunnel.sh script to your Linux server (the one running your private web app).
 - Make the script executable: chmod +x install_fips_tunnel.sh.
 - Run the script with sudo, passing the token from the Terraform output:
 - Bash
   sudo ./install_tunnel.sh <PASTE_YOUR_TUNNEL_TOKEN_HERE>

<H2>Verify:</H2>
 - On your Linux host, check the service status: sudo systemctl status cloudflared.
 - In your Cloudflare Zero Trust dashboard, check that your tunnel is "Healthy".
 - Open a browser and navigate to your lb hostname (e.g., https://tunnel-lb.yourdomain.com). Your request should be routed to a resource that is accessible over the configured tunnel

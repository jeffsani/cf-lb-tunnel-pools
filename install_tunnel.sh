#!/bin/bash
set -e

# --- Configuration ---
# This version is used as an example.
# Please check for the latest FIPS-compliant version from:
# https://github.com/cloudflare/cloudflared/releases
CLOUDFLARED_VERSION="2025.11.1"
# ---------------------

# Select the appropriate verison for your OS/Platform
# STD Versions"
FILENAME="cloudflared-amd64.pkg"
#FILENAME="cloudflared-arm64.pkg"
#FILENAME="cloudflared-darwin-amd64.tgz"
#FILENAME="cloudflared-darwin-arm64.tgz"
#FILENAME="cloudflared-linux-386"
#FILENAME="cloudflared-linux-386.deb"
#FILENAME="cloudflared-linux-386.rpm"

# FIPS Versions
#FILENAME="cloudflared-fips-linux-amd64"
#FILENAME="cloudflared-fips-linux-amd64.deb"
#FILENAME="cloudflared-fips-linux-x86_64.rpm"

DOWNLOAD_URL="https://github.com/cloudflare/cloudflared/releases/download/${CLOUDFLARED_VERSION}/${FILENAME}"

# Check if token is provided as an argument
if [ -z "$1" ]; then
  echo "Error: Missing tunnel token."
  echo "Usage: sudo $0 <CLOUDFLARED_TOKEN>"
  exit 1
fi

TOKEN="$1"

# Check for root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script with sudo."
  exit 1
fi

echo "Downloading FIPS-compliant cloudflared (version ${CLOUDFLARED_VERSION})..."
curl -L --output "${FILENAME}" "${DOWNLOAD_URL}"

if [ ! -f "$FILENAME" ]; then
    echo "Error: Download failed. File not found: $FILENAME"
    exit 1
fi

echo "Installing package..."
apt-get update
# The -y flag automatically answers "yes" to prompts
# ./ specifies that we are installing from a local file
apt-get install -y ./"${FILENAME}"

echo "Installing cloudflared service with your token..."
# This command installs the service and configures it to run
# with the provided token.
cloudflared service install "${TOKEN}"

echo "Cleaning up installer..."
rm "${FILENAME}"

echo "---"
echo "Done."
echo "The cloudflared service is installed and should start automatically."
echo "Run 'sudo systemctl status cloudflared' to check its status."
echo "It may take a few minutes for the tunnel to become healthy in your Cloudflare dashboard."
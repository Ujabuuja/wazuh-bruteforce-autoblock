#!/usr/bin/env bash
# Prepare the Ubuntu 24.04 victim VM and install the Wazuh agent.
# LAB USE ONLY: creates a deliberately weak account and enables SSH password login.
set -euo pipefail

WAZUH_MANAGER="${WAZUH_MANAGER:-10.0.2.10}"
AGENT_NAME="${AGENT_NAME:-victim-ubuntu}"
AGENT_VERSION="${AGENT_VERSION:-4.14.10-1}"   # must match the manager version

sudo apt-get update
sudo apt-get -y install openssh-server iptables

# Lab-only target account (set a weak password interactively)
id labuser >/dev/null 2>&1 || sudo adduser --gecos "" labuser

# Allow SSH password authentication so the brute force has something to hit
sudo sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo systemctl restart ssh

# Wazuh agent
cd /tmp
wget -q "https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_${AGENT_VERSION}_amd64.deb"
sudo WAZUH_MANAGER="$WAZUH_MANAGER" WAZUH_AGENT_NAME="$AGENT_NAME" dpkg -i "./wazuh-agent_${AGENT_VERSION}_amd64.deb"
sudo systemctl daemon-reload
sudo systemctl enable --now wazuh-agent
systemctl is-active wazuh-agent ssh

#!/bin/bash

# Prompt user for SNMP contact details
read -p "Enter SNMP Contact Name: " CONTACT_NAME
read -p "Enter SNMP Contact Email: " CONTACT_EMAIL
read -p "Enter SNMP Location: " LOCATION

# Detect OS
OS="$(. /etc/os-release; echo $ID)"
VERSION_ID="$(. /etc/os-release; echo $VERSION_ID)"

# Install SNMP and SNMP Trap packages
if [[ "$OS" == "ubuntu" ]]; then
    sudo apt update && sudo apt install -y snmp snmpd
elif [[ "$OS" == "centos" || "$OS" == "rhel" ]]; then
    sudo yum install -y net-snmp net-snmp-utils
else
    echo "Unsupported OS"
    exit 1
fi

# Configure SNMP
SNMP_CONF="/etc/snmp/snmpd.conf"
sudo cp "$SNMP_CONF" "$SNMP_CONF.bak"
echo "rocommunity public" | sudo tee "$SNMP_CONF"
echo "trapcommunity public" | sudo tee -a "$SNMP_CONF"
echo "trapsink 10.161.144.47" | sudo tee -a "$SNMP_CONF" 
echo "syslocation $LOCATION" | sudo tee -a "$SNMP_CONF"
echo "syscontact $CONTACT_NAME <$CONTACT_EMAIL>" | sudo tee -a "$SNMP_CONF"

# Restart SNMP Service
sudo systemctl restart snmpd
sudo systemctl enable snmpd

echo "SNMP and SNMP traps configured with community 'public' and SNMP server 10.161.144.47."

#!/usr/bin/env bash
# Run on the Wazuh manager after an attack to show detection and containment.
sudo /var/ossec/bin/agent_control -l
sudo grep -E "Rule: (5763|651) " -B2 /var/ossec/logs/alerts/alerts.log | grep -E "^20|Rule" | tail -n 6
# On the victim, while a block is active:
#   sudo iptables -L -n | grep DROP
#   sudo tail /var/ossec/logs/active-responses.log

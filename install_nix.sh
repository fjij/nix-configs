#!/usr/bin/env bash
set -euo pipefail
echo 'Installing Nix via Determinate Systems installer...'
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
echo 'Installation complete'

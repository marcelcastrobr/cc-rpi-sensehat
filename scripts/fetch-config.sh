#!/bin/bash
# Fetch configuration files from Raspberry Pi
# Usage: ./scripts/fetch-config.sh

set -e

PI_HOST="pi@sensehat"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

echo "Fetching configuration from $PI_HOST..."

# Fetch MagicMirror config
echo "  <- ~/MagicMirror/config/config.js -> config/config.js"
scp "$PI_HOST:~/MagicMirror/config/config.js" "$REPO_DIR/config/config.js"

# Fetch systemd service
echo "  <- /etc/systemd/system/magicmirror.service -> config/magicmirror.service"
scp "$PI_HOST:/etc/systemd/system/magicmirror.service" "$REPO_DIR/config/magicmirror.service"

# Fetch SenseHat files
echo "  <- ~/show_hour.py -> sensehat/show_hour.py"
scp "$PI_HOST:~/show_hour.py" "$REPO_DIR/sensehat/show_hour.py"

echo "  <- ~/.config/sense_hat/RTIMULib.ini -> sensehat/RTIMULib.ini"
scp "$PI_HOST:~/.config/sense_hat/RTIMULib.ini" "$REPO_DIR/sensehat/RTIMULib.ini"

# Fetch manual-holdings example if it exists
echo "  <- ~/MagicMirror/modules/MMM-Fintech/manual-holdings.example.json -> config/manual-holdings.example.json"
scp "$PI_HOST:~/MagicMirror/modules/MMM-Fintech/manual-holdings.example.json" "$REPO_DIR/config/manual-holdings.example.json" 2>/dev/null || echo "    (manual-holdings.example.json not found, skipping)"

echo ""
echo "Fetch complete!"
echo ""
echo "WARNING: config.js may contain real API tokens."
echo "Before committing, ensure you sanitize credentials:"
echo "  - Netatmo: clientId, clientSecret, refresh_token"
echo "  - Tibber: tibberToken, homeId"

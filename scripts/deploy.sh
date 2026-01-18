#!/bin/bash
# Deploy configuration files to Raspberry Pi
# Usage: ./scripts/deploy.sh [--restart]

set -e

PI_HOST="pi@sensehat"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

echo "Deploying configuration to $PI_HOST..."

# Deploy MagicMirror config
echo "  -> config/config.js -> ~/MagicMirror/config/config.js"
scp "$REPO_DIR/config/config.js" "$PI_HOST:~/MagicMirror/config/config.js"

# Deploy SenseHat files
echo "  -> sensehat/show_hour.py -> ~/show_hour.py"
scp "$REPO_DIR/sensehat/show_hour.py" "$PI_HOST:~/show_hour.py"

echo "  -> sensehat/RTIMULib.ini -> ~/.config/sense_hat/RTIMULib.ini"
ssh "$PI_HOST" "mkdir -p ~/.config/sense_hat"
scp "$REPO_DIR/sensehat/RTIMULib.ini" "$PI_HOST:~/.config/sense_hat/RTIMULib.ini"

# Optionally restart MagicMirror
if [[ "$1" == "--restart" ]]; then
    echo "Restarting MagicMirror service..."
    ssh "$PI_HOST" "sudo systemctl restart magicmirror"
    echo "MagicMirror restarted."
fi

echo "Deployment complete!"

# Raspberry Pi SenseHat & MagicMirror Configuration

Configuration files for a Raspberry Pi running MagicMirror with a SenseHat display.

## Directory Structure

```
cc-rpi-sensehat/
├── config/
│   ├── config.js                    # MagicMirror config (sanitized)
│   ├── magicmirror.service          # Systemd service file
│   └── manual-holdings.example.json # Example holdings for MMM-Fintech
├── sensehat/
│   ├── show_hour.py                 # SenseHat hour display script
│   └── RTIMULib.ini                 # SenseHat IMU calibration
├── scripts/
│   ├── deploy.sh                    # Deploy configs to Pi
│   └── fetch-config.sh              # Fetch configs from Pi
└── README.md
```

## MagicMirror Modules

- **clock** - Current time (top left)
- **calendar** - Norwegian holidays
- **weather** - OpenMeteo weather for Kongsberg, Norway
- **newsfeed** - NRK and VG news feeds
- **netatmo** - Netatmo weather station data
- **MMM-Tibber** - Tibber electricity prices
- **MMM-Fintech** - Stock portfolio tracker

## Setup

### 1. Clone and Configure

```bash
git clone https://github.com/marcelcastrobr/cc-rpi-sensehat.git
cd cc-rpi-sensehat
```

### 2. Add Your Credentials

Edit `config/config.js` and replace the placeholders:

```javascript
// Netatmo module
clientId: "YOUR_NETATMO_CLIENT_ID",
clientSecret: "YOUR_NETATMO_CLIENT_SECRET",
refresh_token: "YOUR_NETATMO_REFRESH_TOKEN"

// Tibber module
tibberToken: "YOUR_TIBBER_TOKEN",
homeId: "YOUR_TIBBER_HOME_ID"
```

### 3. Deploy to Pi

```bash
./scripts/deploy.sh           # Deploy config files
./scripts/deploy.sh --restart # Deploy and restart MagicMirror
```

## Scripts

### deploy.sh

Deploys configuration files to the Raspberry Pi:
- `config/config.js` → `~/MagicMirror/config/config.js`
- `sensehat/show_hour.py` → `~/show_hour.py`
- `sensehat/RTIMULib.ini` → `~/.config/sense_hat/RTIMULib.ini`

Use `--restart` flag to restart MagicMirror after deployment.

### fetch-config.sh

Fetches current configuration from the Pi for backup or review.

**Warning:** The fetched `config.js` will contain real API tokens. Sanitize before committing!

## SenseHat

The `show_hour.py` script displays the current hour on the SenseHat LED matrix.

## Systemd Service

The `magicmirror.service` file can be used to run MagicMirror as a systemd service:

```bash
# On the Pi
sudo cp config/magicmirror.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable magicmirror
sudo systemctl start magicmirror
```

## Security

The following files are excluded from version control:
- `*.enc` - Encrypted credential files
- `.mmm-fintech-key` - Encryption key
- `token.json` - OAuth tokens
- `*-credentials.*` - Any credential files
- `config/config.local.js` - Local config with real credentials

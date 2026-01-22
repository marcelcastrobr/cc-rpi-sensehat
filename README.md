# Raspberry Pi SenseHat + MagicMirror Configuration

This repository contains the configuration and scripts for a Raspberry Pi with SenseHat running MagicMirror with custom modules for home automation display.

## 🖥️ Setup Overview

- **Device**: Raspberry Pi with SenseHat
- **Display**: MagicMirror² v2.34.0
- **Location**: Kongsberg, Norway
- **Language**: Norwegian Bokmål (nb-NO)

## 📦 Installed Modules

### Core Modules
- **Clock** - Time and date display
- **Calendar** - Norwegian holidays
- **Weather** - OpenMeteo weather (Kongsberg coordinates)
- **Newsfeed** - NRK and VG news feeds  
- **Compliments** - Rotating messages

### Custom Modules
- **[MMM-Tibber](https://github.com/ottopaulsen/MMM-Tibber)** - Electricity prices (top center)
- **[MMM-Fintech](https://github.com/sonnyb9/MMM-Fintech)** - Stock tracker (bottom right)
  - Tracks: AMZN, AAPL, SNOW, NVDA
- **[Netatmo](https://github.com/CFenner/MMM-Netatmo)** - Weather station data (bottom left)

### SenseHat
- **show_hour.py** - Displays current hour on SenseHat LED matrix

## 🚀 Installation

### Prerequisites
- Raspberry Pi running Debian 13 (trixie)
- Node.js v22+ (upgraded from v20)
- npm 10.9.4+
- Git
- X display server (for Electron/GUI)

### Quick Start

1. **Clone this repository**
```bash
git clone https://github.com/marcelcastrobr/cc-rpi-sensehat.git
cd cc-rpi-sensehat
```

2. **Install MagicMirror**
```bash
cd ~
git clone https://github.com/MagicMirrorOrg/MagicMirror.git
cd MagicMirror
npm run install-mm
```

3. **Install Custom Modules**
```bash
cd ~/MagicMirror/modules

# Tibber
git clone https://github.com/ottopaulsen/MMM-Tibber
cd MMM-Tibber && npm install && cd ..

# Fintech
git clone https://github.com/sonnyb9/MMM-Fintech
cd MMM-Fintech && npm install && cd ..

# Netatmo (if not included)
git clone https://github.com/CFenner/MMM-Netatmo netatmo
cd netatmo && npm install && cd ..
```

4. **Configure Credentials**

Copy `config/config.js.sample` to `config/config.js` and add your credentials:

- **Tibber**: Get token from https://developer.tibber.com/
- **Netatmo**:
  - Create app at https://dev.netatmo.com/apps/
  - Get Client ID, Client Secret, and Refresh Token
- **TwelveData** (for stocks): Get free API key from https://twelvedata.com/

5. **Deploy Configuration**
```bash
# Copy config to Pi
scp config/config.js pi@sensehat:~/MagicMirror/config/

# Copy systemd service
sudo cp config/magicmirror.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable magicmirror.service
sudo systemctl start magicmirror.service
```

## 🔄 Auto-Update System

The system includes automatic weekly updates for MagicMirror and all modules.

### Features
- Runs every Sunday at 3:00 AM
- Updates MagicMirror core
- Updates all git-based modules (MMM-Tibber, MMM-Fintech, Netatmo)
- Only restarts service if updates were installed
- Logs all activity to `/home/pi/magicmirror-updates.log`

### Manual Update
```bash
/home/pi/update-magicmirror.sh
```

### Check Update Log
```bash
tail -30 /home/pi/magicmirror-updates.log
```

### Cron Schedule
```
0 3 * * 0 /home/pi/update-magicmirror.sh
```

## 📁 Repository Structure

```
cc-rpi-sensehat/
├── config/
│   ├── config.js              # MagicMirror config (sanitized)
│   ├── config.js.sample       # Template with placeholders
│   ├── magicmirror.service    # Systemd service file
│   └── manual-holdings.example.json
├── sensehat/
│   ├── show_hour.py           # SenseHat LED display script
│   └── RTIMULib.ini           # SenseHat IMU calibration
├── scripts/
│   ├── deploy.sh              # Deploy configs to Pi
│   ├── fetch-config.sh        # Fetch configs from Pi
│   ├── update-magicmirror.sh  # Auto-update script
│   └── crontab.txt            # Cron configuration
├── .gitignore
└── README.md
```

## 🔐 Security Notes

**Never commit these files:**
- Files with actual API tokens/credentials
- `.mmm-fintech-key`
- `*-credentials.enc`
- `token.json`
- `cache.json`, `history.json`

The repository uses sanitized configs with placeholders like:
- `YOUR_TIBBER_TOKEN`
- `YOUR_NETATMO_CLIENT_ID`
- `YOUR_NETATMO_CLIENT_SECRET`
- `YOUR_NETATMO_REFRESH_TOKEN`

## 🛠️ Maintenance

### Service Management
```bash
# Status
sudo systemctl status magicmirror.service

# Restart
sudo systemctl restart magicmirror.service

# Logs
sudo journalctl -u magicmirror.service -f

# Stop
sudo systemctl stop magicmirror.service
```

### Module-Specific

#### MMM-Fintech
- Manual holdings: `~/MagicMirror/modules/MMM-Fintech/manual-holdings.json`
- TwelveData API setup required for stock prices
- Cache cleared automatically on updates

#### MMM-Tibber
- Get Home ID: `node get-homes.js YOUR_TOKEN`
- Located in `~/MagicMirror/modules/MMM-Tibber/`

#### SenseHat
- Hour display runs independently
- IMU config at `~/.config/sense_hat/RTIMULib.ini`

## 📊 Display Layout

```
┌─────────────────────────────────────┐
│ Clock/Date │  Tibber   │   Weather  │
│ Calendar   │ (center)  │  Forecast  │
├────────────┴───────────┴────────────┤
│                                      │
│          Compliments                 │
│                                      │
├──────────────────┬───────────────────┤
│    Netatmo       │    Stocks         │
│  (weather stn)   │  (AMZN,AAPL,etc) │
├──────────────────┴───────────────────┤
│            News Feed                 │
└──────────────────────────────────────┘
```

## 🐛 Troubleshooting

### MagicMirror won't start
```bash
# Check config syntax
cd ~/MagicMirror
npm run config:check

# Check service logs
sudo journalctl -u magicmirror.service -n 50
```

### Module not loading
- Check module is installed in `~/MagicMirror/modules/`
- Verify credentials are configured
- Check module-specific logs in browser console

### Update failures
- Check network connectivity
- Verify git credentials
- Review `/home/pi/magicmirror-updates.log`

### Display issues
- Ensure X display is running: `echo $DISPLAY`
- Check systemd service has `Environment=DISPLAY=:0`

## 📝 License

Configuration files are provided as-is for personal use. Individual modules are subject to their respective licenses.

## 🤝 Contributing

This is a personal configuration repository. Feel free to fork and adapt for your own use.

## 📧 Contact

Repository: https://github.com/marcelcastrobr/cc-rpi-sensehat

# StayAwake

A lightweight macOS menu bar app that prevents your Mac from sleeping.

When running, a **moon icon** appears in your menu bar. Click it to quit and let your Mac sleep again.

## Prerequisites

- macOS 13 (Ventura) or later
- Xcode Command Line Tools (`xcode-select --install`)

## Install

```bash
git clone https://github.com/elmiomar/stay-awake.git
cd stay-awake
make install
```

The app is installed to `~/Applications/`.

## Usage

- Open **StayAwake** from `~/Applications/` or Spotlight
- A moon icon appears in the menu bar while your Mac stays awake
- Click the icon, then select **Turn Off & Quit** to stop

## Other Commands

```bash
make build     # Compile the app into build/
make run       # Build and launch
make uninstall # Remove from ~/Applications
make clean     # Delete build directory
```

## How It Works

StayAwake is a single-file Swift app that:
1. Runs `caffeinate -d` to prevent display sleep
2. Shows an SF Symbol (`moon.zzz.fill`) in the menu bar
3. Kills `caffeinate` when you quit

No background daemons, no login items. Just open and close.

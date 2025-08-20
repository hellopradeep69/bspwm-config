
# 🪴 BSPWM Rice Setup

This repository contains my **BSPWM rice (dotfiles)** and a setup script that will  
**restore configs** and **install all required software** automatically on most Linux distros.  
It’s designed to get my exact setup running in just a few minutes 🚀

---

## 📦 Features

- 🖥️ Installs all required software:
  - **Window Manager & Hotkeys** → `bspwm`, `sxhkd`
  - **Bar & Launcher** → `polybar`, `rofi`
  - **Compositor** → `picom`
  - **File Manager** → `ranger`
  - **Terminals** → `kitty`, `wezterm`, `alacritty`
  - **Shell & Prompt** → `fish`, `starship`
  - **Editor** → `neovim`
  - **Wallpaper Tools** → `nitrogen`, `feh`
  - **Notifications** → `dunst`
  - **Utilities** → `git`, `curl`, `wget`, `fzf`, `bat`, `neofetch`

- ⚡ Works on **Arch, Debian/Ubuntu, Fedora, openSUSE** (auto-detects distro).  
- 🎨 Restores configs for:
  - `bspwm`, `sxhkd`, `polybar`, `picom`, `rofi`
  - `ranger`, `kitty`, `wezterm`, `alacritty`
  - `fish`, `starship`, `neovim`
  - `nitrogen`, `dunst`
- 🔧 Copies **custom scripts** to `~/.local/bin/`
- ⚙️ Handles special configs:
  - `starship.toml` → `~/.config/starship.toml`
  - `.wezterm.lua` → `~/.wezterm.lua`

---

## 📂 Repository Structure

---

### 📑 Description of Folders & Files

| Path / File       | Description |
|-------------------|-------------|
| `bspwm/`          | Configuration for the **BSPWM window manager** |
| `sxhkd/`          | Hotkeys and keybinding settings |
| `polybar/`        | **Polybar** status bar configuration |
| `rofi/`           | **Rofi** themes and launcher settings |
| `picom/`          | Compositor configuration (transparency, shadows, etc.) |
| `ranger/`         | File manager (ranger) configuration |
| `kitty/`          | Kitty terminal configuration |
| `wezterm/`        | Wezterm terminal configuration |
| `alacritty/`      | Alacritty terminal configuration |
| `nvim/`           | Neovim editor configuration |
| `fish/`           | Fish shell configuration |
| `nitrogen/`       | Wallpaper manager configuration |
| `dunst/`          | Notification daemon (dunst) configuration |
| `scripts/`        | Custom scripts (installed to `~/.local/bin/`) |
| `starship.toml`   | Starship prompt configuration file |
| `.wezterm.lua`    | Global wezterm config file |
| `setup.sh`        | Installation / restore script |
| `README.md`       | This documentation file |

## 🛠️ Requirements
- **Linux (Arch, Ubuntu/Debian, Fedora, or openSUSE)**
- **git**
- **Internet connection (for package installation)**

## 🚀 Installation

### 1. Clone the repo
```bash
git clone https://github.com/hellopradeep69/bspwm-config
cd bspwm-config
```

### 2. Run the setup script
```bash
chmod +x setup.sh
./setup.sh
```

## this script will :
- **Detect your distro.**
- **Install required packages using the correct package manager.**
- **Copy dotfiles to ~/.config.**
- **Copy scripts to ~/.local/bin.**
- **Place special configs in the right location.**

## ⚠️ Warnings / Notes
- The wallpaper (`cyper.jpg`) is only copied to `~/Pictures`.  
  You must manually set it depending on your wallpaper tool:
  - For **feh**: add this line to your `~/.config/bspwm/bspwmrc`  
    ```bash
    feh --bg-scale ~/Pictures/cyper.jpg
    ```
  - For **nitrogen**: run `nitrogen ~/Pictures` and pick the wallpaper.


# 🪴 BSPWM Rice Setup

This repository contains my **BSPWM rice (dotfiles)** and a setup script that will  
**restore configs** and **install all required software** automatically on most Linux distros.  
It’s designed to get my exact setup running in just a few minutes 🚀

---

## 🌐 Zen Browser

For the best browsing experience in your bspwm setup, it is **highly recommended to use [Zen Browser](https://zen-browser.app/)**.

**Download Zen Browser:** [https://zen-browser.app/](https://zen-browser.app/)

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

### 🔧 Extra Dependencies

Some configs and scripts may require additional tools not included in the main package list, such as:

- `playerctl` (for media controls)
- `xrandr` (for monitor management)
- `brightnessctl` (for brightness keys)
- `i3lock` (for screen lock)

Install them via your package manager if features don’t work as expected.

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

| Path / File     | Description                                            |
| --------------- | ------------------------------------------------------ |
| `bspwm/`        | Configuration for the **BSPWM window manager**         |
| `sxhkd/`        | Hotkeys and keybinding settings                        |
| `polybar/`      | **Polybar** status bar configuration                   |
| `rofi/`         | **Rofi** themes and launcher settings                  |
| `picom/`        | Compositor configuration (transparency, shadows, etc.) |
| `ranger/`       | File manager (ranger) configuration                    |
| `kitty/`        | Kitty terminal configuration                           |
| `wezterm/`      | Wezterm terminal configuration                         |
| `alacritty/`    | Alacritty terminal configuration                       |
| `nvim/`         | Neovim editor configuration                            |
| `fish/`         | Fish shell configuration                               |
| `nitrogen/`     | Wallpaper manager configuration                        |
| `dunst/`        | Notification daemon (dunst) configuration              |
| `scripts/`      | Custom scripts (installed to `~/.local/bin/`)          |
| `starship.toml` | Starship prompt configuration file                     |
| `.wezterm.lua`  | Global wezterm config file                             |
| `setup.sh`      | Installation / restore script                          |
| `README.md`     | This documentation file                                |

# ⌨️ BSPWM Keybindings

This document lists all custom **bspwm + sxhkd** keybindings in a clean table format.

---

## 🖥️ Terminals

| Keys             | Action                        |
| ---------------- | ----------------------------- |
| `super + Return` | Open **WezTerm**              |
| `super + w`      | Open **Kitty**                |
| `Pause`          | Kill apps via `rofi-pkill.sh` |

---

## 🌐 Browsers & Apps

| Keys                | Action                            |
| ------------------- | --------------------------------- |
| `super + y`         | Open **YouTube app** in Brave     |
| `super + b`         | Open **Zen browser** (or Firefox) |
| `super + shift + b` | Open **Brave browser**            |
| `super + o`         | Open **Obsidian Notes App**       |

---

## 🪟 Window Management

| Keys                        | Action                                |
| --------------------------- | ------------------------------------- |
| `super + q`                 | Close window                          |
| `super + shift + q`         | Logout / Kill session                 |
| `super + ctrl + q`          | Quit **bspwm**                        |
| `super + shift + r`         | Reload **bspwm** and **sxhkd**        |
| `super + {h,j,k,l}`         | Focus move (west, south, north, east) |
| `super + shift + {h,j,k,l}` | Swap/move window to direction         |
| `super + {1-9}`             | Switch to desktop                     |
| `super + shift + {1-9}`     | Move window to desktop                |
| `super + 0`                 | Switch to desktop 0                   |
| `super + shift + 0`         | Move window to desktop 0              |
| `super + f`                 | Toggle fullscreen                     |
| `super + shift + space`     | Toggle floating/tiling mode           |
| `super + x`                 | Hide focused window                   |
| `super + shift + x`         | Unhide last hidden window             |

---

## 🖱️ Resize Windows

| Keys                      | Action               |
| ------------------------- | -------------------- |
| `super + alt + {h,j,k,l}` | Resize with vim keys |
| `super + alt + {←,↓,↑,→}` | Resize with arrows   |

---

## 📦 Rofi / Launcher

| Keys                | Action                    |
| ------------------- | ------------------------- |
| `ctrl + space`      | Launch **Rofi drun** menu |
| `super + Tab`       | Switch windows with Rofi  |
| `super + n`         | Rofi Notes menu           |
| `super + shift + n` | Alternate Notes menu      |
| `super + a`         | Rofi Music Player         |
| `Menu`              | Rofi Clipboard Manager    |

---

## 🖼️ System & Media

| Keys                    | Action                                      |
| ----------------------- | ------------------------------------------- |
| `Print`                 | Screenshot full screen (`gnome-screenshot`) |
| `Shift + Print`         | Screenshot selection                        |
| `XF86MonBrightnessUp`   | Increase brightness                         |
| `XF86MonBrightnessDown` | Decrease brightness                         |
| `XF86AudioRaiseVolume`  | Increase volume                             |
| `XF86AudioLowerVolume`  | Decrease volume                             |
| `XF86AudioMute`         | Toggle mute                                 |
| `XF86AudioMicMute`      | Toggle mic mute                             |
| `XF86RFKill`            | Toggle airplane mode (rfkill)               |
| `super + p`             | Toggle Polybar visibility                   |
| `super + shift + s`     | Lock screen (i3lock)                        |
| `super + shift + z`     | Lock + suspend                              |
| `Scroll_Lock`           | Toggle keyboard layout                      |
| `alt + space`           | Run `internet.sh`                           |

---

## 🗂️ Scratchpads

| Keys            | Action                                   |
| --------------- | ---------------------------------------- |
| `super + m`     | Open **Kew** scratchpad (kitty terminal) |
| `super + space` | Ranger in WezTerm floating window        |
| `super + s`     | Quick notes scratchpad (WezTerm + nvim)  |

---

## 🔧 Extra Configs

- Pointer modifier: **Super key**
- Drag floating windows with mouse:
  - **LMB** = Move
  - **RMB** = Resize

---

✨ That’s it! Now you have a **clear reference** to all custom keybindings.

---

## 🛠️ Requirements

- **Linux (Arch, Ubuntu/Debian, Fedora, or openSUSE)**
- **git**
- **Internet connection (for package installation)**

### Before installation recommended to

- install required fonts such as jetbrain and terminess.

1. jetbrain font

```bash
wget -O JetBrainsMono.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip JetBrainsMono.zip -d ~/.local/share/fonts
fc-cache -fv
```

2.

```bash
wget -O Terminess.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Terminus.zip
unzip Terminess.zip -d ~/.local/share/fonts
fc-cache -fv
```

- fastfetch [recommended]

```bash
git clone https://github.com/fastfetch-cli/fastfetch.git
cd fastfetch
mkdir -p build
cd build
cmake ..
cmake --build . --target fastfetch
```

3. starship toml for terminal

```bash
curl -sS https://starship.rs/install.sh | sh
```

4. brightnessctl permission

```bash
sudo usermod -aG video $USER
```

5. rofi/pywal

```bash
rofi-theme-selector

```

6. zen browser [download and setup]

- download zen browser
  **Download Zen Browser:** [https://zen-browser.app/](https://zen-browser.app/)

```bash
mkdir -p ~/.local/opt
mv ~/Downloads/zen*.tar.gz ~/.local/opt/
cd ~/.local/opt
tar -xvzf zen*.tar.gz
sudo ln -s ~/.local/opt/zen-browser/zen /usr/local/bin/zen

```

- run

```bash
zen
```

## ``

````

## 🚀 Installation

### 1. Clone the repo
```bash
git clone https://github.com/hellopradeep69/bspwm-config
cd bspwm-config
````

### 2. Run the setup script

```bash
chmod +x setup.sh
./setup.sh
```

### 3.run bspwmrc

```bash
chmod +x ~/.config/bspwm/bspwmrc
chmod +x ~/.config/polybar/launch.sh --colorblocks
```

---

### Packages ( if script fail to install )

---

## this script will :

- **Detect your distro.**
- **Install required packages using the correct package manager.**
- **Copy dotfiles to ~/.config.**
- **Copy scripts to ~/.local/bin.**
- **Place special configs in the right location.**

## ⚠️ Warnings / Notes

- Orginal created for linux mint user ! be aware if you use other distos
- Running the setup will **overwrite existing configs** in `~/.config/`. Backups are created, but double-check before proceeding.
- Some apps (e.g., `wezterm`) may not exist in your distro’s repos. You might need to install them manually.
- Scripts from `scripts/` are copied into `~/.local/bin` and may **replace existing scripts** with the same name.
- `starship.toml` and `.wezterm.lua` in your home directory will be **overwritten**. Backup your own configs first if needed.
- Always run the script from the repository root (`cd bspwm-config`) to avoid path issues.
- After installation, ensure you select **bspwm** in your login manager or configure `startx` properly.

### 🖼 Wallpaper Setup

- The wallpaper (`cyper.jpg`) is copied to `~/Pictures`.  
  You must manually set it depending on your wallpaper tool:
  - For **feh**: add this line to your `~/.config/bspwm/bspwmrc`
    ```bash
    feh --bg-scale ~/Pictures/cyper.jpg
    ```
  - For **nitrogen**: run
    ```bash
    nitrogen ~/Pictures
    ```
    then pick the wallpaper from the UI.

#!/bin/bash

# === CONFIG ===
BACKUP_DIR="$(pwd)" # run from backup repo root
CONFIG_DIR="$HOME/.config"
LOCAL_BIN="$HOME/.local/bin"
BACKUP_DEST="$HOME/config_backup/$(date +%Y-%m-%d_%H-%M-%S)"

# Full list of packages (generic names)
PACKAGES=(
    bspwm
    sxhkd
    polybar
    picom
    rofi
    ranger
    kitty
    wezterm
    alacritty
    fish
    starship
    neovim
    nitrogen
    feh
    dunst
    git
    curl
    wget
    fzf
    bat
    neofetch
)

# === FUNCTIONS ===
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    else
        echo "unknown"
    fi
}

install_packages() {
    distro=$(detect_distro)
    echo "==> Detected distro: $distro"
    case "$distro" in
    arch | manjaro | endeavouros)
        sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"
        ;;
    debian | ubuntu | linuxmint)
        sudo apt update
        sudo apt install -y "${PACKAGES[@]}"
        ;;
    fedora)
        sudo dnf install -y "${PACKAGES[@]}"
        ;;
    opensuse* | suse)
        sudo zypper install -y "${PACKAGES[@]}"
        ;;
    *)
        echo "⚠️ Unsupported distro: $distro"
        echo "Please install these packages manually: ${PACKAGES[*]}"
        ;;
    esac
}

backup_config() {
    src="$1"
    dest="$CONFIG_DIR/$src"

    if [ -d "$dest" ]; then
        echo "📦 Backing up $src -> $BACKUP_DEST/$src"
        mkdir -p "$BACKUP_DEST"
        cp -r "$dest" "$BACKUP_DEST/"
        rm -rf "$dest"
    fi
}

install_config() {
    src="$1"
    dest="$CONFIG_DIR/$src"

    echo "-> Installing config for $src"
    mkdir -p "$CONFIG_DIR"
    cp -r "$BACKUP_DIR/$src" "$dest"
}

# === MAIN ===
echo "⚡ Starting full bspwm rice setup..."
echo "📦 Backups will be stored in: $BACKUP_DEST"

# Step 1: Install all packages
install_packages

# Step 2: Backup + Restore configs
for dir in bspwm fish kitty alacritty nitrogen nvim picom polybar ranger rofi sxhkd dunst; do
    if [ -d "$BACKUP_DIR/$dir" ]; then
        backup_config "$dir"
        install_config "$dir"
    fi
done

# Step 3: starship.toml -> ~/.config
if [ -f "$BACKUP_DIR/starship.toml" ]; then
    echo "-> Backing up old starship.toml (if any)"
    [ -f "$CONFIG_DIR/starship.toml" ] && mkdir -p "$BACKUP_DEST" && mv "$CONFIG_DIR/starship.toml" "$BACKUP_DEST/"
    echo "-> Installing starship.toml"
    cp "$BACKUP_DIR/starship.toml" "$CONFIG_DIR/starship.toml"
fi

# Step 4: Wezterm config -> ~/.wezterm.lua
if [ -f "$BACKUP_DIR/.wezterm.lua" ]; then
    echo "-> Backing up old wezterm config (if any)"
    [ -f "$HOME/.wezterm.lua" ] && mkdir -p "$BACKUP_DEST" && mv "$HOME/.wezterm.lua" "$BACKUP_DEST/"
    echo "-> Installing wezterm config (~/.wezterm.lua)"
    cp "$BACKUP_DIR/.wezterm.lua" "$HOME/.wezterm.lua"
fi

# Step 5: Scripts -> ~/.local/bin
if [ -d "$BACKUP_DIR/scripts" ]; then
    echo "-> Installing scripts into $LOCAL_BIN"
    mkdir -p "$LOCAL_BIN"
    cp -r "$BACKUP_DIR/scripts/"* "$LOCAL_BIN"
fi

# Step 6: Wallpapers -> ~/Pictures/Wallpapers
WALL_DIR="$HOME/Pictures/Wallpapers"
mkdir -p "$WALL_DIR"

# Copy single "red cyber.jpg" if exists
if [ -f "$BACKUP_DIR/red cyber.jpg" ]; then
    echo "🖼️ Installing wallpaper -> $WALL_DIR/red cyber.jpg"
    cp "$BACKUP_DIR/red cyber.jpg" "$WALL_DIR/"
fi

# Copy entire Wallpapers/ folder if exists
if [ -d "$BACKUP_DIR/Wallpapers" ]; then
    echo "🖼️ Installing Wallpapers -> $WALL_DIR/"
    cp -r "$BACKUP_DIR/Wallpapers/"* "$WALL_DIR/"
fi

# Step 7: Desktop shortcuts -> ~/.local/share/applications
if [ -d "$BACKUP_DIR/desktop" ]; then
    echo "🖥️ Installing desktop shortcuts -> ~/.local/share/applications"
    mkdir -p "$HOME/.local/share/applications"
    cp -r "$BACKUP_DIR/desktop/"* "$HOME/.local/share/applications/"
fi
echo "✅ Setup complete!"
echo "📦 Backups saved in: $BACKUP_DEST"
echo "👉 Log out and choose bspwm in your login manager, or run 'startx' if using xinit."

#!/bin/bash

# === CONFIG ===
BACKUP_DIR="$(pwd)" # run from backup repo root
CONFIG_DIR="$HOME/.config"
LOCAL_BIN="$HOME/.local/bin"

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

install_config() {
    src="$1"
    dest="$CONFIG_DIR/$src"

    echo "-> Installing config for $src"
    mkdir -p "$CONFIG_DIR"
    rm -rf "$dest"
    cp -r "$BACKUP_DIR/$src" "$dest"
}

# === MAIN ===
echo "⚡ Starting full bspwm rice setup..."

# Step 1: Install all packages
install_packages

# Step 2: Restore configs
for dir in bspwm fish kitty alacritty nitrogen nvim picom polybar ranger rofi sxhkd dunst; do
    if [ -d "$BACKUP_DIR/$dir" ]; then
        install_config "$dir"
    fi
done

# Step 3: starship.toml -> ~/.config
if [ -f "$BACKUP_DIR/starship.toml" ]; then
    echo "-> Installing starship.toml"
    cp "$BACKUP_DIR/starship.toml" "$CONFIG_DIR/starship.toml"
fi

# Step 4: Wezterm config -> ~/.wezterm.lua
if [ -f "$BACKUP_DIR/.wezterm.lua" ]; then
    echo "-> Installing wezterm config (~/.wezterm.lua)"
    cp "$BACKUP_DIR/.wezterm.lua" "$HOME/.wezterm.lua"
fi

# Step 5: Scripts -> ~/.local/bin
if [ -d "$BACKUP_DIR/scripts" ]; then
    echo "-> Installing scripts into $LOCAL_BIN"
    mkdir -p "$LOCAL_BIN"
    cp -r "$BACKUP_DIR/scripts/"* "$LOCAL_BIN"
fi

echo "✅ Setup complete!"
echo "👉 Log out and choose bspwm in your login manager, or run 'startx' if using xinit."

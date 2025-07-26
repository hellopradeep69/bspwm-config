if status is-interactive
    # === Locale Fix for btop ===
    set -x LANG en_IN.UTF-8
    set -x LANGUAGE en_IN.UTF-8:en_US.UTF-8
    set -x LC_ALL en_IN.UTF-8

    # Starship prompt
    starship init fish | source

    # Run fastfetch without logo
    fastfetch --config ~/.config/fastfetch/config2.jsonc --logo-type none

    # Alias for Brave browser
    alias brave="brave-browser"

    # Alias for Telegram
    alias telegram="/opt/telegram/Telegram"
end

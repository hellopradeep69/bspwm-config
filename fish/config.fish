if status is-interactive

    # Locale fix for UTF-8 and tools like btop
    set -x LANG en_IN.UTF-8
    set -x LANGUAGE en_IN.UTF-8:en_US.UTF-8
    set -x LC_ALL en_IN.UTF-8

    # Enable Vim keybindings in Fish shell
    fish_vi_key_bindings

    # Map 'jj' in insert mode to escape to normal mode
    function fish_user_key_bindings
        bind -M insert jj 'set fish_bind_mode default; commandline -f repaint'
    end

    function ff
        fzf --bind=j:down,k:up,q:abort \
            --preview "batcat --style=numbers --color=always {}"
    end

    # Initialize Starship prompt
    starship init fish | source

    # Run Fastfetch on shell start without logo
    fastfetch --config ~/.config/fastfetch/config2.jsonc --logo-type none

    # Alias to launch Brave browser
    alias brave="brave-browser"

    # Alias to launch Telegram
    alias telegram="/opt/telegram/Telegram"

    # 👉 Alias to exit shell using :q (like in Vim)
    alias :q="exit"
end

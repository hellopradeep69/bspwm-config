if status is-interactive

    function cd:
        # Use the first argument as starting directory, or "." if none
        set start_dir (or $argv[1] .)

        # Find directories and fuzzy select one with fzf
        set dir (find $start_dir -type d 2>/dev/null | fzf --bind=j:down,k:up,q:abort --preview "ls --color=always {}")

        # If a directory was chosen, cd into it
        if test -n "$dir"
            cd "$dir"
        end
    end

    # fzf change setting
    # set -x FZF_DEFAULT_OPTS '--bind j:down,k:up,ctrl-j:page-down,ctrl-k:page-up,q:abort '

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
    # cat anime.txt

    # Alias to eza as ls 
    # alias ls="eza --icons --group-directories-first"

    # Alias to launch Brave browser
    alias brave="brave-browser"

    # Alias to launch Telegram
    alias telegram="/opt/telegram/Telegram"

    # 👉 Alias to exit shell using :q (like in Vim)
    alias :q="exit"

    alias lh="ls -a"

end

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

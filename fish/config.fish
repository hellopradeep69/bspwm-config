if status is-interactive
    # Commands to run in interactive sessions can go here
    # Starship prompt
        starship init fish | source
    # Run fastfetch without logo
       # fastfetch --logo none
       fastfetch --config ~/.config/fastfetch/config2.jsonc --logo-type none
     # Alias for Brave browser
        alias brave="brave-browser"
    # alias for telegram
        alias telegram="/opt/telegram/Telegram"    
end

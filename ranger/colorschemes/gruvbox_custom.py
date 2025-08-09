from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import *

class gruvbox_custom(ColorScheme):
    progress_bar_color = 142  # green

    def use(self, context):
        fg, bg, attr = default_colors

        # Gruvbox 256-color codes
        bg0     = 235  # #282828
        bg1     = 236  # #3c3836
        bg2     = 237
        fg1     = 223  # #ebdbb2
        gray    = 244  # #928374
        red     = 167  # #cc241d
        green   = 142  # #98971a
        yellow  = 214  # #d79921
        blue    = 109  # #458588
        purple  = 175  # #b16286
        aqua    = 108  # #689d6a

        if context.reset:
            return default_colors

        if context.in_browser:
            fg = fg1
            bg = bg0
            if context.selected:
                attr |= reverse
            if context.directory:
                fg = blue
            elif context.executable and not context.directory:
                fg = green
                attr |= bold
            elif context.link:
                fg = aqua
            if context.media:
                fg = purple
            if context.tag_marker:
                attr |= bold
                fg = yellow if context.good else red

        elif context.in_titlebar:
            attr |= bold
            fg = yellow
            bg = bg1

        elif context.in_statusbar:
            fg = fg1
            bg = bg1

        if context.marked:
            attr |= bold
            fg = yellow

        if context.message:
            if context.bad:
                fg = red
            else:
                fg = green

        if context.in_taskview:
            if context.title:
                fg = yellow
            if context.selected:
                attr |= reverse

        return fg, bg, attr


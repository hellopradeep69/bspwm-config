from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import *

class Mocha(ColorScheme):
    progress_bar_color = cyan
    def use(self, context):
        fg, bg, attr = default_colors

        if context.reset:
            return default_colors

        bg = 235  # hex #1e1e2e
        fg = 189  # hex #cdd6f4

        if context.in_browser:
            attr = normal
            if context.selected:
                attr = reverse
            if context.directory:
                fg = cyan
            if context.executable:
                fg = red
            if context.link:
                fg = magenta
            if context.inactive_pane:
                fg = 241

        return fg, bg, attr

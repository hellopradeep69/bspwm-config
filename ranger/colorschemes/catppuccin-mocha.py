from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import *

class ColorScheme(ColorScheme):
    progress_bar_color = 5

    def use(self, context):
        fg, bg, attr = default_colors

        mocha = {
            'base': 235,
            'mantle': 236,
            'text': 252,
            'blue': 117,
            'green': 114,
            'yellow': 180,
            'peach': 209,
            'pink': 175,
            'red': 203,
            'lavender': 141,
            'subtext0': 245,
        }

        if context.reset:
            return default_colors
        if context.in_browser:
            fg = mocha['text']
            bg = mocha['base']
            if context.selected:
                attr |= reverse
            if context.empty:
                fg = mocha['subtext0']
            if context.error:
                fg = mocha['red']
            if context.media:
                fg = mocha['yellow']
            if context.image:
                fg = mocha['peach']
            if context.container:
                fg = mocha['lavender']
            if context.directory:
                fg = mocha['blue']
                attr |= bold
            if context.executable and not context.directory:
                fg = mocha['green']
                attr |= bold
            if context.socket:
                fg = mocha['pink']
                attr |= bold
            if context.fifo or context.device:
                fg = mocha['peach']
            if context.link:
                fg = mocha['lavender'] if context.good else mocha['red']
        elif context.in_titlebar:
            attr |= bold
            fg = mocha['lavender']
        elif context.in_statusbar:
            fg = mocha['subtext0']
            bg = mocha['mantle']
        if context.marked:
            attr |= bold
            fg = mocha['yellow']
        if context.message:
            if context.bad:
                fg = mocha['red']
        return fg, bg, attr

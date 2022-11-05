from libqtile import layout

layouts = [
        layout.MonadTall(
            margin = 5,
            border_focus = '#89dceb',
            border_width=2,
        ),
        layout.Max(),
]

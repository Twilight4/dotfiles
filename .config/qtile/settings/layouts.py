from libqtile import layout

layouts = [
        layout.MonadThreeCol(
            margin = 20,
            border_focus = '#89dceb',
            ),
        layout.Tile(),
        layout.Matrix(),
        layout.Floating(),
        ]

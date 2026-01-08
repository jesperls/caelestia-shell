{ ... }:
{
  bind = [
    "$mainMod, T, exec, $terminal"
    "$mainMod, E, exec, thunar"
    "$mainMod, A, exec, caelestia-shell ipc --any-display call drawers toggle launcher"
    "$mainMod, D, exec, vesktop"
    "$mainMod, B, exec, $browser"

    "$mainMod, Q, killactive,"
    "$mainMod, W, togglefloating"
    "$mainMod, F, fullscreen"
    "$mainMod, P, pseudo"
    "$mainMod, J, togglesplit"
    "$mainMod, M, exit,"

    "$mainMod SHIFT, W, exec, wallpaper-manager"

    "$mainMod, left, movefocus, l"
    "$mainMod, right, movefocus, r"
    "$mainMod, up, movefocus, u"
    "$mainMod, down, movefocus, d"

    "$mainMod SHIFT, left, movewindow, l"
    "$mainMod SHIFT, right, movewindow, r"
    "$mainMod SHIFT, up, movewindow, u"
    "$mainMod SHIFT, down, movewindow, d"

    "$mainMod, 1, workspace, 1"
    "$mainMod, 2, workspace, 2"
    "$mainMod, 3, workspace, 3"
    "$mainMod, 4, workspace, 4"
    "$mainMod, 5, workspace, 5"
    "$mainMod, 6, workspace, 6"
    "$mainMod, 7, workspace, 7"
    "$mainMod, 8, workspace, 8"
    "$mainMod, 9, workspace, 9"
    "$mainMod, 0, workspace, 10"

    "$mainMod SHIFT, 1, movetoworkspace, 1"
    "$mainMod SHIFT, 2, movetoworkspace, 2"
    "$mainMod SHIFT, 3, movetoworkspace, 3"
    "$mainMod SHIFT, 4, movetoworkspace, 4"
    "$mainMod SHIFT, 5, movetoworkspace, 5"
    "$mainMod SHIFT, 6, movetoworkspace, 6"
    "$mainMod SHIFT, 7, movetoworkspace, 7"
    "$mainMod SHIFT, 8, movetoworkspace, 8"
    "$mainMod SHIFT, 9, movetoworkspace, 9"
    "$mainMod SHIFT, 0, movetoworkspace, 10"

    "$mainMod, mouse_down, workspace, e+1"
    "$mainMod, mouse_up, workspace, e-1"

    "$mainMod, grave, togglespecialworkspace, magic"
    "$mainMod SHIFT, grave, movetoworkspace, special:magic"

    ''$mainMod, S, exec, grim -g "$(slurp -w 0)" - | wl-copy''
    ''$mainMod SHIFT, S, exec, grim -g "$(slurp -w 0)" "$HOME/Pictures/Screenshots/$(date +'%Y-%m-%d-%H%M%S_grim.png')"''

    "$mainMod, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"
  ];

  bindm = [
    "$mainMod, mouse:272, movewindow"
    "$mainMod, mouse:273, resizewindow"
    "$mainMod, Z, movewindow"
    "$mainMod, X, resizewindow"
  ];

  binde = [
    ", XF86AudioRaiseVolume, exec, pamixer -i 5"
    ", XF86AudioLowerVolume, exec, pamixer -d 5"
    ", XF86AudioMute, exec, pamixer -t"
    ", XF86AudioMicMute, exec, pamixer --default-source -t"
    ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
    ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
    "$mainMod CTRL, right, resizeactive, 20 0"
    "$mainMod CTRL, left, resizeactive, -20 0"
    "$mainMod CTRL, up, resizeactive, 0 -20"
    "$mainMod CTRL, down, resizeactive, 0 20"
  ];

  bindl = [
    ", XF86AudioPlay, exec, playerctl play-pause"
    ", XF86AudioPause, exec, playerctl play-pause"
    ", XF86AudioNext, exec, playerctl next"
    ", XF86AudioPrev, exec, playerctl previous"
    ", XF86AudioStop, exec, playerctl stop"
  ];
}

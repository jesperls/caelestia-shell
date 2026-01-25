{
  config,
  pkgs,
  osConfig,
  lib,
  ...
}:

let
  theme = osConfig.mySystem.theme.colors;
in
{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$nix_shell$character";
      right_format = "$cmd_duration";
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
      directory = {
        style = "bold ${theme.accent}";
        truncation_length = 4;
      };
      git_branch = {
        style = "bold ${theme.accent2}";
        format = "[$symbol$branch]($style) ";
      };
      git_status = {
        style = "bold yellow";
        format = "[$all_status$ahead_behind]($style) ";
      };
      nix_shell = {
        format = "[$symbol$state]($style) ";
        symbol = "❄️ ";
        style = "bold blue";
      };
      cmd_duration = {
        format = "[$duration]($style)";
        style = "${theme.muted}";
        min_time = 2000;
      };
    };
  };

  programs.eza = {
    enable = true;
    icons = "auto";
    git = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
      "--inline-info"
    ];
    colors = {
      fg = theme.text;
      bg = theme.background;
      hl = theme.accent;
      "fg+" = theme.text;
      "bg+" = theme.surface;
      "hl+" = theme.accent2;
      info = theme.muted;
      prompt = theme.accent;
      pointer = theme.accent2;
      marker = theme.accent;
      spinner = theme.accent;
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    config = {
      global = {
        warn_timeout = "30s";
        hide_env_diff = true;
      };
    };
  };

  programs.kitty = {
    enable = true;
    themeFile = "Catppuccin-Mocha";
    settings = {
      font_family = osConfig.mySystem.theme.fonts.monospace;
      font_size = builtins.toString osConfig.mySystem.theme.fonts.size;
      adjust_line_height = "120%";
      window_padding_width = 10;
      confirm_os_window_close = 0;

      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = true;

      scrollback_lines = 10000;

      url_style = "curly";
      open_url_with = "default";
      detect_urls = true;

      enable_audio_bell = false;
      visual_bell_duration = "0.0";

      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
    };
    keybindings = {
      "ctrl+shift+t" = "new_tab_with_cwd";
      "ctrl+shift+enter" = "new_window_with_cwd";
      "ctrl+shift+n" = "new_os_window_with_cwd";
    };
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "Dracula";
      style = "numbers,changes,header";
      italic-text = "always";
    };
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "dracula";
      theme_background = false;
      vim_keys = true;
      rounded_corners = true;
      update_ms = 1000;
    };
  };
}

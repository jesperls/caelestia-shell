{ osConfig, ... }:

let
  colors = osConfig.mySystem.theme.colors;
  rounding = osConfig.mySystem.theme.rounding;
in
''
  window {
    background-color: ${colors.background};
    border-radius: ${toString rounding}px;
    border: 1px solid ${colors.border};
  }

  #input {
    margin: 10px 14px;
    padding: 8px 14px;
    border: none;
    border-radius: ${toString (rounding / 2)}px;
    background-color: ${colors.surface};
    color: ${colors.text};
    font-size: 14px;
  }

  #outer-box { margin: 0; padding: 0; }
  #inner-box { margin: 6px; padding: 0; }
  #scroll { margin: 0; padding: 0; }

  #img { border-radius: ${toString (rounding / 3)}px; }

  #text, #unmatched, #matched {
    margin: 0; padding: 0;
    min-height: 0; min-width: 0;
    font-size: 0px;
    color: transparent;
  }

  #entry {
    margin: 6px;
    padding: 6px;
    border-radius: ${toString (rounding / 2)}px;
    background-color: transparent;
    border: 2px solid transparent;
  }

  #entry:selected {
    background-color: alpha(${colors.accent}, 0.12);
    border: 2px solid ${colors.accent};
  }
''

# Color derivation library for Caelestia theme integration
# Takes 9 base colors and derives a full M3 palette
{ lib }:

let
  # Hex color math utilities
  fromHex =
    s:
    let
      chars = lib.stringToCharacters (lib.toLower s);
      hexVal =
        c:
        if c == "a" then
          10
        else if c == "b" then
          11
        else if c == "c" then
          12
        else if c == "d" then
          13
        else if c == "e" then
          14
        else if c == "f" then
          15
        else
          lib.toInt c;
    in
    (hexVal (builtins.elemAt chars 0)) * 16 + (hexVal (builtins.elemAt chars 1));

  toHex =
    n:
    let
      hexChars = [
        "0"
        "1"
        "2"
        "3"
        "4"
        "5"
        "6"
        "7"
        "8"
        "9"
        "a"
        "b"
        "c"
        "d"
        "e"
        "f"
      ];
    in
    "${builtins.elemAt hexChars (n / 16)}${builtins.elemAt hexChars (lib.mod n 16)}";

  clamp =
    v:
    if v > 255 then
      255
    else if v < 0 then
      0
    else
      v;

  darken =
    hex: amount:
    let
      r = fromHex (builtins.substring 0 2 hex);
      g = fromHex (builtins.substring 2 2 hex);
      b = fromHex (builtins.substring 4 2 hex);
      scale = v: clamp (builtins.floor (v * amount));
    in
    "${toHex (scale r)}${toHex (scale g)}${toHex (scale b)}";

  lighten =
    hex: amount:
    let
      r = fromHex (builtins.substring 0 2 hex);
      g = fromHex (builtins.substring 2 2 hex);
      b = fromHex (builtins.substring 4 2 hex);
      scale = v: clamp (builtins.floor (v + (255 - v) * amount));
    in
    "${toHex (scale r)}${toHex (scale g)}${toHex (scale b)}";

  strip = c: lib.removePrefix "#" c;

  # Derive full M3 palette from 9 base colors
  # Input: { accent, accent2, background, surface, surfaceAlt, text, muted, border, shadow }
  # Output: attrset of "colorName" = "#hexval" suitable for themeColors
  deriveM3Palette =
    baseColors:
    let
      a = strip baseColors.accent;
      a2 = strip baseColors.accent2;
      bg = strip baseColors.background;
      sf = strip baseColors.surface;
      sa = strip baseColors.surfaceAlt;
      tx = strip baseColors.text;
      mu = strip baseColors.muted;
      bd = strip baseColors.border;
      sh = strip baseColors.shadow;
    in
    {
      # Palette key colors
      primary_paletteKeyColor = "#${a}";
      secondary_paletteKeyColor = "#${a2}";
      tertiary_paletteKeyColor = "#${a2}";
      neutral_paletteKeyColor = "#${mu}";
      neutral_variant_paletteKeyColor = "#${bd}";

      # Background/Surface
      background = "#${bg}";
      onBackground = "#${tx}";
      surface = "#${bg}";
      surfaceDim = "#${darken bg 0.8}";
      surfaceBright = "#${lighten bg 0.15}";
      surfaceContainerLowest = "#${sa}";
      surfaceContainerLow = "#${darken sf 0.9}";
      surfaceContainer = "#${sf}";
      surfaceContainerHigh = "#${lighten sf 0.08}";
      surfaceContainerHighest = "#${lighten sf 0.15}";
      onSurface = "#${tx}";
      surfaceVariant = "#${bd}";
      onSurfaceVariant = "#${mu}";
      inverseSurface = "#${tx}";
      inverseOnSurface = "#${bg}";

      # Outline
      outline = "#${mu}";
      outlineVariant = "#${bd}";

      # Shadow
      shadow = "#${sh}";
      scrim = "#000000";

      # Primary
      surfaceTint = "#${a}";
      primary = "#${a}";
      onPrimary = "#${darken a 0.3}";
      primaryContainer = "#${darken a 0.5}";
      onPrimaryContainer = "#${lighten a 0.6}";
      inversePrimary = "#${darken a 0.6}";

      # Secondary
      secondary = "#${a2}";
      onSecondary = "#${darken a2 0.3}";
      secondaryContainer = "#${darken a2 0.5}";
      onSecondaryContainer = "#${lighten a2 0.6}";

      # Tertiary
      tertiary = "#${lighten a2 0.2}";
      onTertiary = "#${darken a2 0.3}";
      tertiaryContainer = "#${darken a2 0.6}";
      onTertiaryContainer = "#${lighten a2 0.7}";

      # Error
      error = "#ffb4ab";
      onError = "#690005";
      errorContainer = "#93000a";
      onErrorContainer = "#ffdad6";

      # Success
      success = "#B5CCBA";
      onSuccess = "#213528";
      successContainer = "#374B3E";
      onSuccessContainer = "#D1E9D6";

      # Fixed
      primaryFixed = "#${lighten a 0.5}";
      primaryFixedDim = "#${a}";
      onPrimaryFixed = "#${darken a 0.7}";
      onPrimaryFixedVariant = "#${darken a 0.5}";
      secondaryFixed = "#${lighten a2 0.5}";
      secondaryFixedDim = "#${a2}";
      onSecondaryFixed = "#${darken a2 0.7}";
      onSecondaryFixedVariant = "#${darken a2 0.5}";
      tertiaryFixed = "#${lighten a2 0.6}";
      tertiaryFixedDim = "#${lighten a2 0.2}";
      onTertiaryFixed = "#${darken a2 0.7}";
      onTertiaryFixedVariant = "#${darken a2 0.5}";

      # Terminal
      term0 = "#353434";
      term1 = "#${a}";
      term2 = "#${a2}";
      term3 = "#${lighten a2 0.5}";
      term4 = "#${mu}";
      term5 = "#${lighten a 0.2}";
      term6 = "#${lighten a2 0.3}";
      term7 = "#${tx}";
      term8 = "#${darken mu 0.7}";
      term9 = "#${lighten a 0.3}";
      term10 = "#${lighten a2 0.4}";
      term11 = "#${lighten tx 0.3}";
      term12 = "#${lighten bd 0.3}";
      term13 = "#${lighten a 0.4}";
      term14 = "#${lighten a2 0.5}";
      term15 = "#ffffff";
    };

in
{
  inherit darken lighten deriveM3Palette;
}

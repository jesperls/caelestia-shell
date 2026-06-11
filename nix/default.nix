{
  rev,
  lib,
  stdenv,
  makeWrapper,
  makeFontsConf,
  fish,
  ddcutil,
  brightnessctl,
  networkmanager,
  lm_sensors,
  swappy,
  wl-clipboard,
  libqalculate,
  bash,
  hyprland,
  material-symbols,
  rubik,
  nerd-fonts,
  qt6,
  quickshell,
  aubio,
  libcava,
  fftw,
  pipewire,
  xkeyboard-config,
  cmake,
  ninja,
  pkg-config,
  caelestia-cli,
  m3shapes,
  debug ? false,
  withCli ? false,
  extraRuntimeDeps ? [],
  themeColors ? {},
}: let
  version = "1.0.0";

  runtimeDeps =
    [
      fish
      ddcutil
      brightnessctl
      networkmanager
      lm_sensors
      swappy
      wl-clipboard
      libqalculate
      bash
      hyprland
    ]
    ++ extraRuntimeDeps
    ++ lib.optional withCli caelestia-cli;

  fontconfig = makeFontsConf {
    fontDirectories = [material-symbols rubik nerd-fonts.caskaydia-cove];
  };

  cmakeBuildType =
    if debug
    then "Debug"
    else "RelWithDebInfo";

  cmakeVersionFlags = [
    (lib.cmakeFeature "VERSION" version)
    (lib.cmakeFeature "GIT_REVISION" rev)
    (lib.cmakeFeature "DISTRIBUTOR" "nix-flake")
  ];

  # The build sandbox has no network access so add it as a flake input instead
  m3shapesFlag = lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_M3SHAPES_EXTERNAL" "${m3shapes}";

  # Upstream's default palette: used to fill any @THEME_*@ placeholder not
  # overridden via themeColors, so the shell works without a theme config.
  defaultThemeColors = {
    primary_paletteKeyColor = "#a8627b";
    secondary_paletteKeyColor = "#8e6f78";
    tertiary_paletteKeyColor = "#986e4c";
    neutral_paletteKeyColor = "#807477";
    neutral_variant_paletteKeyColor = "#837377";
    background = "#191114";
    onBackground = "#efdfe2";
    surface = "#191114";
    surfaceDim = "#191114";
    surfaceBright = "#403739";
    surfaceContainerLowest = "#130c0e";
    surfaceContainerLow = "#22191c";
    surfaceContainer = "#261d20";
    surfaceContainerHigh = "#31282a";
    surfaceContainerHighest = "#3c3235";
    onSurface = "#efdfe2";
    surfaceVariant = "#514347";
    onSurfaceVariant = "#d5c2c6";
    inverseSurface = "#efdfe2";
    inverseOnSurface = "#372e30";
    outline = "#9e8c91";
    outlineVariant = "#514347";
    shadow = "#000000";
    scrim = "#000000";
    surfaceTint = "#ffb0ca";
    primary = "#ffb0ca";
    onPrimary = "#541d34";
    primaryContainer = "#6f334a";
    onPrimaryContainer = "#ffd9e3";
    inversePrimary = "#8b4a62";
    secondary = "#e2bdc7";
    onSecondary = "#422932";
    secondaryContainer = "#5a3f48";
    onSecondaryContainer = "#ffd9e3";
    tertiary = "#f0bc95";
    onTertiary = "#48290c";
    tertiaryContainer = "#b58763";
    onTertiaryContainer = "#000000";
    error = "#ffb4ab";
    onError = "#690005";
    errorContainer = "#93000a";
    onErrorContainer = "#ffdad6";
    success = "#B5CCBA";
    onSuccess = "#213528";
    successContainer = "#374B3E";
    onSuccessContainer = "#D1E9D6";
    primaryFixed = "#ffd9e3";
    primaryFixedDim = "#ffb0ca";
    onPrimaryFixed = "#39071f";
    onPrimaryFixedVariant = "#6f334a";
    secondaryFixed = "#ffd9e3";
    secondaryFixedDim = "#e2bdc7";
    onSecondaryFixed = "#2b151d";
    onSecondaryFixedVariant = "#5a3f48";
    tertiaryFixed = "#ffdcc3";
    tertiaryFixedDim = "#f0bc95";
    onTertiaryFixed = "#2f1500";
    onTertiaryFixedVariant = "#623f21";
    term0 = "#353434";
    term1 = "#ff4c8a";
    term2 = "#ffbbb7";
    term3 = "#ffdedf";
    term4 = "#b3a2d5";
    term5 = "#e98fb0";
    term6 = "#ffba93";
    term7 = "#eed1d2";
    term8 = "#b39e9e";
    term9 = "#ff80a3";
    term10 = "#ffd3d0";
    term11 = "#fff1f0";
    term12 = "#dcbc93";
    term13 = "#f9a8c2";
    term14 = "#ffd1c0";
    term15 = "#ffffff";
  };
  effectiveThemeColors = defaultThemeColors // themeColors;

  extras = stdenv.mkDerivation {
    inherit cmakeBuildType;
    name = "caelestia-extras${lib.optionalString debug "-debug"}";
    src = lib.fileset.toSource {
      root = ./..;
      fileset = lib.fileset.union ./../CMakeLists.txt ./../extras;
    };

    nativeBuildInputs = [cmake ninja];

    cmakeFlags =
      [
        (lib.cmakeFeature "ENABLE_MODULES" "extras")
        (lib.cmakeFeature "INSTALL_LIBDIR" "${placeholder "out"}/lib")
      ]
      ++ cmakeVersionFlags;
  };

  plugin = stdenv.mkDerivation {
    inherit cmakeBuildType;
    name = "caelestia-qml-plugin${lib.optionalString debug "-debug"}";
    src = lib.fileset.toSource {
      root = ./..;
      fileset = lib.fileset.union ./../CMakeLists.txt ./../plugin;
    };

    nativeBuildInputs = [cmake ninja pkg-config];
    buildInputs = [qt6.qtbase qt6.qtdeclarative qt6.qtshadertools libqalculate pipewire aubio libcava fftw lm_sensors];

    dontWrapQtApps = true;
    cmakeFlags =
      [
        (lib.cmakeFeature "ENABLE_MODULES" "plugin")
        (lib.cmakeFeature "INSTALL_QMLDIR" qt6.qtbase.qtQmlPrefix)
      ]
      ++ cmakeVersionFlags;
  };

  m3shapesModule = stdenv.mkDerivation {
    inherit cmakeBuildType;
    name = "caelestia-m3shapes${lib.optionalString debug "-debug"}";
    src = lib.fileset.toSource {
      root = ./..;
      fileset = ./../CMakeLists.txt;
    };

    nativeBuildInputs = [cmake ninja];
    buildInputs = [qt6.qtbase qt6.qtdeclarative];

    dontWrapQtApps = true;
    cmakeFlags =
      [
        (lib.cmakeFeature "ENABLE_MODULES" "m3shapes")
        (lib.cmakeFeature "INSTALL_QMLDIR" qt6.qtbase.qtQmlPrefix)
        m3shapesFlag
      ]
      ++ cmakeVersionFlags;
  };
in
  stdenv.mkDerivation {
    inherit version cmakeBuildType;
    pname = "caelestia-shell${lib.optionalString debug "-debug"}";
    src = ./..;

    nativeBuildInputs = [cmake ninja makeWrapper qt6.wrapQtAppsHook];
    buildInputs = [quickshell extras plugin m3shapesModule xkeyboard-config qt6.qtbase];
    propagatedBuildInputs = runtimeDeps;

    cmakeFlags =
      [
        (lib.cmakeFeature "ENABLE_MODULES" "shell")
        (lib.cmakeFeature "INSTALL_QSCONFDIR" "${placeholder "out"}/share/caelestia-shell")
      ]
      ++ cmakeVersionFlags;

    dontStrip = debug;

    prePatch =
      ''
        substituteInPlace assets/pam.d/fprint \
          --replace-fail pam_fprintd.so /run/current-system/sw/lib/security/pam_fprintd.so
        substituteInPlace assets/pam.d/howdy \
          --replace-fail pam_howdy.so /run/current-system/sw/lib/security/pam_howdy.so
        substituteInPlace shell.qml \
          --replace-fail 'settings.watchFiles: true' 'settings.watchFiles: false'
      ''
      + lib.optionalString (themeColors != {}) ''
        substituteInPlace services/Colours.qml \
          --replace-fail 'onLoaded: root.load(text(), false)' '// onLoaded: root.load(text(), false)'
      ''
      + lib.concatStringsSep "\n" (
        lib.mapAttrsToList (
          name: value: "substituteInPlace services/Colours.qml --replace-fail '@THEME_${name}@' '${value}' "
        )
        effectiveThemeColors
      );

    postInstall = ''
      makeWrapper ${quickshell}/bin/qs $out/bin/caelestia-shell \
      	--prefix PATH : "${lib.makeBinPath runtimeDeps}" \
      	--set FONTCONFIG_FILE "${fontconfig}" \
      	--set CAELESTIA_LIB_DIR ${extras}/lib \
        --set CAELESTIA_XKB_RULES_PATH ${xkeyboard-config}/share/xkeyboard-config-2/rules/base.lst \
      	--add-flags "-p $out/share/caelestia-shell"

      mkdir -p $out/lib
      ln -s ${extras}/lib/* $out/lib/

      # Ensure wrap_term_launch.sh is executable
      chmod 755 $out/share/caelestia-shell/assets/wrap_term_launch.sh
    '';

    passthru = {
      inherit plugin extras m3shapesModule;
    };

    meta = {
      description = "A very segsy desktop shell";
      homepage = "https://github.com/caelestia-dots/shell";
      license = lib.licenses.gpl3Only;
      mainProgram = "caelestia-shell";
    };
  }

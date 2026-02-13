pragma Singleton
pragma ComponentBehavior: Bound

import qs.config
import qs.utils
import Caelestia
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property bool showPreview
    property string scheme
    property string flavour
    readonly property bool light: showPreview ? previewLight : currentLight
    property bool currentLight
    property bool previewLight
    readonly property M3Palette palette: showPreview ? preview : current
    readonly property M3TPalette tPalette: M3TPalette {}
    readonly property M3Palette current: M3Palette {}
    readonly property M3Palette preview: M3Palette {}
    readonly property Transparency transparency: Transparency {}
    readonly property alias wallLuminance: analyser.luminance

    function getLuminance(c: color): real {
        if (c.r == 0 && c.g == 0 && c.b == 0)
            return 0;
        return Math.sqrt(0.299 * (c.r ** 2) + 0.587 * (c.g ** 2) + 0.114 * (c.b ** 2));
    }

    function alterColour(c: color, a: real, layer: int): color {
        const luminance = getLuminance(c);

        const offset = (!light || layer == 1 ? 1 : -layer / 2) * (light ? 0.2 : 0.3) * (1 - transparency.base) * (1 + wallLuminance * (light ? (layer == 1 ? 3 : 1) : 2.5));
        const scale = (luminance + offset) / luminance;
        const r = Math.max(0, Math.min(1, c.r * scale));
        const g = Math.max(0, Math.min(1, c.g * scale));
        const b = Math.max(0, Math.min(1, c.b * scale));

        return Qt.rgba(r, g, b, a);
    }

    function layer(c: color, layer: var): color {
        if (!transparency.enabled)
            return c;

        return layer === 0 ? Qt.alpha(c, transparency.base) : alterColour(c, transparency.layers, layer ?? 1);
    }

    function on(c: color): color {
        if (c.hslLightness < 0.5)
            return Qt.hsla(c.hslHue, c.hslSaturation, 0.9, 1);
        return Qt.hsla(c.hslHue, c.hslSaturation, 0.1, 1);
    }

    function load(data: string, isPreview: bool): void {
        const colours = isPreview ? preview : current;
        const scheme = JSON.parse(data);

        if (!isPreview) {
            root.scheme = scheme.name;
            flavour = scheme.flavour;
            currentLight = scheme.mode === "light";
        } else {
            previewLight = scheme.mode === "light";
        }

        for (const [name, colour] of Object.entries(scheme.colours)) {
            const propName = name.startsWith("term") ? name : `m3${name}`;
            if (colours.hasOwnProperty(propName))
                colours[propName] = `#${colour}`;
        }
    }

    function setMode(mode: string): void {
        Quickshell.execDetached(["caelestia", "scheme", "set", "--notify", "-m", mode]);
    }

    FileView {
        path: `${Paths.state}/scheme.json`
        watchChanges: true
        onFileChanged: reload()
        onLoaded: root.load(text(), false)
    }

    ImageAnalyser {
        id: analyser

        source: Wallpapers.current
    }

    component Transparency: QtObject {
        readonly property bool enabled: Appearance.transparency.enabled
        readonly property real base: Appearance.transparency.base - (root.light ? 0.1 : 0)
        readonly property real layers: Appearance.transparency.layers
    }

    component M3TPalette: QtObject {
        readonly property color m3primary_paletteKeyColor: root.layer(root.palette.m3primary_paletteKeyColor)
        readonly property color m3secondary_paletteKeyColor: root.layer(root.palette.m3secondary_paletteKeyColor)
        readonly property color m3tertiary_paletteKeyColor: root.layer(root.palette.m3tertiary_paletteKeyColor)
        readonly property color m3neutral_paletteKeyColor: root.layer(root.palette.m3neutral_paletteKeyColor)
        readonly property color m3neutral_variant_paletteKeyColor: root.layer(root.palette.m3neutral_variant_paletteKeyColor)
        readonly property color m3background: root.layer(root.palette.m3background, 0)
        readonly property color m3onBackground: root.layer(root.palette.m3onBackground)
        readonly property color m3surface: root.layer(root.palette.m3surface, 0)
        readonly property color m3surfaceDim: root.layer(root.palette.m3surfaceDim, 0)
        readonly property color m3surfaceBright: root.layer(root.palette.m3surfaceBright, 0)
        readonly property color m3surfaceContainerLowest: root.layer(root.palette.m3surfaceContainerLowest)
        readonly property color m3surfaceContainerLow: root.layer(root.palette.m3surfaceContainerLow)
        readonly property color m3surfaceContainer: root.layer(root.palette.m3surfaceContainer)
        readonly property color m3surfaceContainerHigh: root.layer(root.palette.m3surfaceContainerHigh)
        readonly property color m3surfaceContainerHighest: root.layer(root.palette.m3surfaceContainerHighest)
        readonly property color m3onSurface: root.layer(root.palette.m3onSurface)
        readonly property color m3surfaceVariant: root.layer(root.palette.m3surfaceVariant, 0)
        readonly property color m3onSurfaceVariant: root.layer(root.palette.m3onSurfaceVariant)
        readonly property color m3inverseSurface: root.layer(root.palette.m3inverseSurface, 0)
        readonly property color m3inverseOnSurface: root.layer(root.palette.m3inverseOnSurface)
        readonly property color m3outline: root.layer(root.palette.m3outline)
        readonly property color m3outlineVariant: root.layer(root.palette.m3outlineVariant)
        readonly property color m3shadow: root.layer(root.palette.m3shadow)
        readonly property color m3scrim: root.layer(root.palette.m3scrim)
        readonly property color m3surfaceTint: root.layer(root.palette.m3surfaceTint)
        readonly property color m3primary: root.layer(root.palette.m3primary)
        readonly property color m3onPrimary: root.layer(root.palette.m3onPrimary)
        readonly property color m3primaryContainer: root.layer(root.palette.m3primaryContainer)
        readonly property color m3onPrimaryContainer: root.layer(root.palette.m3onPrimaryContainer)
        readonly property color m3inversePrimary: root.layer(root.palette.m3inversePrimary)
        readonly property color m3secondary: root.layer(root.palette.m3secondary)
        readonly property color m3onSecondary: root.layer(root.palette.m3onSecondary)
        readonly property color m3secondaryContainer: root.layer(root.palette.m3secondaryContainer)
        readonly property color m3onSecondaryContainer: root.layer(root.palette.m3onSecondaryContainer)
        readonly property color m3tertiary: root.layer(root.palette.m3tertiary)
        readonly property color m3onTertiary: root.layer(root.palette.m3onTertiary)
        readonly property color m3tertiaryContainer: root.layer(root.palette.m3tertiaryContainer)
        readonly property color m3onTertiaryContainer: root.layer(root.palette.m3onTertiaryContainer)
        readonly property color m3error: root.layer(root.palette.m3error)
        readonly property color m3onError: root.layer(root.palette.m3onError)
        readonly property color m3errorContainer: root.layer(root.palette.m3errorContainer)
        readonly property color m3onErrorContainer: root.layer(root.palette.m3onErrorContainer)
        readonly property color m3success: root.layer(root.palette.m3success)
        readonly property color m3onSuccess: root.layer(root.palette.m3onSuccess)
        readonly property color m3successContainer: root.layer(root.palette.m3successContainer)
        readonly property color m3onSuccessContainer: root.layer(root.palette.m3onSuccessContainer)
        readonly property color m3primaryFixed: root.layer(root.palette.m3primaryFixed)
        readonly property color m3primaryFixedDim: root.layer(root.palette.m3primaryFixedDim)
        readonly property color m3onPrimaryFixed: root.layer(root.palette.m3onPrimaryFixed)
        readonly property color m3onPrimaryFixedVariant: root.layer(root.palette.m3onPrimaryFixedVariant)
        readonly property color m3secondaryFixed: root.layer(root.palette.m3secondaryFixed)
        readonly property color m3secondaryFixedDim: root.layer(root.palette.m3secondaryFixedDim)
        readonly property color m3onSecondaryFixed: root.layer(root.palette.m3onSecondaryFixed)
        readonly property color m3onSecondaryFixedVariant: root.layer(root.palette.m3onSecondaryFixedVariant)
        readonly property color m3tertiaryFixed: root.layer(root.palette.m3tertiaryFixed)
        readonly property color m3tertiaryFixedDim: root.layer(root.palette.m3tertiaryFixedDim)
        readonly property color m3onTertiaryFixed: root.layer(root.palette.m3onTertiaryFixed)
        readonly property color m3onTertiaryFixedVariant: root.layer(root.palette.m3onTertiaryFixedVariant)
    }

    component M3Palette: QtObject {
        property color m3primary_paletteKeyColor: "@THEME_primary_paletteKeyColor@"
        property color m3secondary_paletteKeyColor: "@THEME_secondary_paletteKeyColor@"
        property color m3tertiary_paletteKeyColor: "@THEME_tertiary_paletteKeyColor@"
        property color m3neutral_paletteKeyColor: "@THEME_neutral_paletteKeyColor@"
        property color m3neutral_variant_paletteKeyColor: "@THEME_neutral_variant_paletteKeyColor@"
        property color m3background: "@THEME_background@"
        property color m3onBackground: "@THEME_onBackground@"
        property color m3surface: "@THEME_surface@"
        property color m3surfaceDim: "@THEME_surfaceDim@"
        property color m3surfaceBright: "@THEME_surfaceBright@"
        property color m3surfaceContainerLowest: "@THEME_surfaceContainerLowest@"
        property color m3surfaceContainerLow: "@THEME_surfaceContainerLow@"
        property color m3surfaceContainer: "@THEME_surfaceContainer@"
        property color m3surfaceContainerHigh: "@THEME_surfaceContainerHigh@"
        property color m3surfaceContainerHighest: "@THEME_surfaceContainerHighest@"
        property color m3onSurface: "@THEME_onSurface@"
        property color m3surfaceVariant: "@THEME_surfaceVariant@"
        property color m3onSurfaceVariant: "@THEME_onSurfaceVariant@"
        property color m3inverseSurface: "@THEME_inverseSurface@"
        property color m3inverseOnSurface: "@THEME_inverseOnSurface@"
        property color m3outline: "@THEME_outline@"
        property color m3outlineVariant: "@THEME_outlineVariant@"
        property color m3shadow: "@THEME_shadow@"
        property color m3scrim: "@THEME_scrim@"
        property color m3surfaceTint: "@THEME_surfaceTint@"
        property color m3primary: "@THEME_primary@"
        property color m3onPrimary: "@THEME_onPrimary@"
        property color m3primaryContainer: "@THEME_primaryContainer@"
        property color m3onPrimaryContainer: "@THEME_onPrimaryContainer@"
        property color m3inversePrimary: "@THEME_inversePrimary@"
        property color m3secondary: "@THEME_secondary@"
        property color m3onSecondary: "@THEME_onSecondary@"
        property color m3secondaryContainer: "@THEME_secondaryContainer@"
        property color m3onSecondaryContainer: "@THEME_onSecondaryContainer@"
        property color m3tertiary: "@THEME_tertiary@"
        property color m3onTertiary: "@THEME_onTertiary@"
        property color m3tertiaryContainer: "@THEME_tertiaryContainer@"
        property color m3onTertiaryContainer: "@THEME_onTertiaryContainer@"
        property color m3error: "@THEME_error@"
        property color m3onError: "@THEME_onError@"
        property color m3errorContainer: "@THEME_errorContainer@"
        property color m3onErrorContainer: "@THEME_onErrorContainer@"
        property color m3success: "@THEME_success@"
        property color m3onSuccess: "@THEME_onSuccess@"
        property color m3successContainer: "@THEME_successContainer@"
        property color m3onSuccessContainer: "@THEME_onSuccessContainer@"
        property color m3primaryFixed: "@THEME_primaryFixed@"
        property color m3primaryFixedDim: "@THEME_primaryFixedDim@"
        property color m3onPrimaryFixed: "@THEME_onPrimaryFixed@"
        property color m3onPrimaryFixedVariant: "@THEME_onPrimaryFixedVariant@"
        property color m3secondaryFixed: "@THEME_secondaryFixed@"
        property color m3secondaryFixedDim: "@THEME_secondaryFixedDim@"
        property color m3onSecondaryFixed: "@THEME_onSecondaryFixed@"
        property color m3onSecondaryFixedVariant: "@THEME_onSecondaryFixedVariant@"
        property color m3tertiaryFixed: "@THEME_tertiaryFixed@"
        property color m3tertiaryFixedDim: "@THEME_tertiaryFixedDim@"
        property color m3onTertiaryFixed: "@THEME_onTertiaryFixed@"
        property color m3onTertiaryFixedVariant: "@THEME_onTertiaryFixedVariant@"
        property color term0: "@THEME_term0@"
        property color term1: "@THEME_term1@"
        property color term2: "@THEME_term2@"
        property color term3: "@THEME_term3@"
        property color term4: "@THEME_term4@"
        property color term5: "@THEME_term5@"
        property color term6: "@THEME_term6@"
        property color term7: "@THEME_term7@"
        property color term8: "@THEME_term8@"
        property color term9: "@THEME_term9@"
        property color term10: "@THEME_term10@"
        property color term11: "@THEME_term11@"
        property color term12: "@THEME_term12@"
        property color term13: "@THEME_term13@"
        property color term14: "@THEME_term14@"
        property color term15: "@THEME_term15@"
    }
}

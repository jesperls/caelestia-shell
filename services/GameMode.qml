pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Caelestia
import Caelestia.Config
import qs.services

Singleton {
    id: root

    property alias enabled: props.enabled

    function setDynamicConfs(): void {
        if (Hypr.usingLua) {
            // Snapshot the current values in the config VM so disabling can restore
            // them without a full reload, which would wipe all Lua runtime state.
            Hypr.extras.message(`eval __caelestia_gamemode = __caelestia_gamemode or {
    animations = { enabled = hl.get_config("animations.enabled") },
    decoration = {
        shadow = { enabled = hl.get_config("decoration.shadow.enabled") },
        blur = { enabled = hl.get_config("decoration.blur.enabled") },
        rounding = hl.get_config("decoration.rounding")
    },
    general = {
        gaps_in = hl.get_config("general.gaps_in"),
        gaps_out = hl.get_config("general.gaps_out"),
        border_size = hl.get_config("general.border_size"),
        allow_tearing = hl.get_config("general.allow_tearing")
    }
}
hl.config({
    animations = { enabled = false },
    decoration = { shadow = { enabled = false }, blur = { enabled = false }, rounding = 0 },
    general = { gaps_in = 0, gaps_out = 0, border_size = 0, allow_tearing = true }
})`);
        } else {
            Hypr.extras.applyOptions({
                "animations:enabled": 0,
                "decoration:shadow:enabled": 0,
                "decoration:blur:enabled": 0,
                "general:gaps_in": 0,
                "general:gaps_out": 0,
                "general:border_size": 0,
                "decoration:rounding": 0,
                "general:allow_tearing": 1
            });
        }
    }

    function restoreConfs(): void {
        if (Hypr.usingLua)
            Hypr.extras.message("eval if __caelestia_gamemode then hl.config(__caelestia_gamemode) __caelestia_gamemode = nil end");
        else
            Hypr.extras.message("reload");
    }

    onEnabledChanged: {
        if (enabled) {
            setDynamicConfs();
            if (GlobalConfig.utilities.toasts.gameModeChanged)
                Toaster.toast(qsTr("Game mode enabled"), qsTr("Disabled Hyprland animations, blur, gaps and shadows"), "gamepad");
        } else {
            restoreConfs();
            if (GlobalConfig.utilities.toasts.gameModeChanged)
                Toaster.toast(qsTr("Game mode disabled"), qsTr("Hyprland settings restored"), "gamepad");
        }
    }

    PersistentProperties {
        id: props

        property bool enabled: Hypr.options["animations:enabled"] === 0 // qmllint disable missing-property

        reloadableId: "gameMode"
    }

    Connections {
        function onConfigReloaded(): void {
            if (props.enabled)
                root.setDynamicConfs();
        }

        target: Hypr
    }

    IpcHandler {
        function isEnabled(): bool {
            return props.enabled;
        }

        function toggle(): void {
            props.enabled = !props.enabled;
        }

        function enable(): void {
            props.enabled = true;
        }

        function disable(): void {
            props.enabled = false;
        }

        target: "gameMode"
    }
}

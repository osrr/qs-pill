pragma Singleton

import Quickshell
import QtQuick

import qs.services

Singleton {
    id: root

    // ------------------------------------------------------------
    // Helpers
    // ------------------------------------------------------------

    function mix(a, b, amount) {
        return Qt.lighter(
            a,
            1.0 + (b.value - a.value) * amount
        )
    }

    function lighten(color, amount) {
        let h = color.hslHue
        let s = color.hslSaturation
        let l = Math.min(1.0, color.hslLightness + amount)

        return Qt.hsla(h, s, l, 1.0)
    }

    function darken(color, amount) {
        let h = color.hslHue
        let s = color.hslSaturation
        let l = Math.max(0.0, color.hslLightness - amount)

        return Qt.hsla(h, s, l, 1.0)
    }

    function semantic(base, influence) {
        const hue = base.hslHue

        const saturation = Math.min(
            1.0,
            base.hslSaturation * 0.7 +
            influence.hslSaturation * 0.3
        )

        const lightness = Math.min(
            1.0,
            base.hslLightness * 0.7 +
            influence.hslLightness * 0.3
        )

        return Qt.hsla(
            hue,
            saturation,
            lightness,
            1.0
        )
    }

    readonly property color red:
    semantic(Qt.color("#E5484D"), WalService.accent)

    readonly property color warn:
    semantic(Qt.color("#E5A23C"), WalService.accent)

    readonly property color success:
    semantic(Qt.color("#3BA675"), WalService.accent)

    readonly property color info:
    WalService.secondary


    // ------------------------------------------------------------
    // Wallpaper-derived colors
    // ------------------------------------------------------------

    readonly property color bg: {
        // Keep the UI dark regardless of wallpaper.
        return Qt.rgba(
            WalService.darkest.r * 0.15,
            WalService.darkest.g * 0.15,
            WalService.darkest.b * 0.15,
            1.0
        )
    }

    readonly property color bgLighter:
        lighten(bg, 0.08)


    readonly property color fg: {
        // Push the wallpaper's brightest color toward white.
        return Qt.rgba(
            WalService.brightest.r * 0.25 + 0.75,
            WalService.brightest.g * 0.25 + 0.75,
            WalService.brightest.b * 0.25 + 0.75,
            1.0
        )
    }

    readonly property color fgDarker:
        darken(fg, 0.20)


    readonly property color accent:
        WalService.accent

    readonly property color accentLighter:
        lighten(accent, 0.15)

}

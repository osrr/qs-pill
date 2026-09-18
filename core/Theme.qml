pragma Singleton

import Quickshell
import QtQuick

Singleton {
    component Radius: QtObject {
        property int sm: 8
        property int md: 16
        property int lg: 24
        property int xl: 32
    }

    component Spacing: QtObject {
        property int sm: 8
        property int md: 16
        property int lg: 24
        property int xl: 32
    }

    component Padding: QtObject {
        property int sm: 8
        property int md: 16
        property int lg: 24
        property int xl: 32
    }

    component Margin: QtObject {
        property int sm: 8
        property int md: 16
        property int lg: 24
        property int xl: 32
    }

    component Font: QtObject {
        property string family: "JetBrainsMono Nerd Propo"
        property string iconFont: "Material Symbols Rounded"

        property int sm: md - 2
        property int md: 12
        property int lg: md + 2
        property int xlg: md + 4
        property int xxlg: md + 6
        property int icon: md + 8

        property int bold: 800
        property int semibold: 700
        property int medium: 600
        property int regular: 400
        property int thin: 200
    }

    readonly property Radius radius: Radius {}
    readonly property Spacing spacing: Spacing {}
    readonly property Padding p: Padding {}
    readonly property Margin m: Margin {}
    readonly property Font font: Font {}
}

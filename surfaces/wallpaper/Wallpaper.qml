import Quickshell
import Quickshell.Wayland
import QtQuick

import qs.services

Variants {
    model: Quickshell.screens
    delegate: PanelWindow {
        id: background

        required property var modelData

        screen: modelData
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Bottom

        anchors {
            top: true
            left: true
            bottom: true
            right: true
        }

        color: "#3c3c3c"

        Image {
            id: wallpaper
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            source: WallpaperService.wallpaper 
        }
    }
}

import Quickshell
import Quickshell.Wayland
import QtQuick

import qs.core
import qs.surfaces.wallpaper
import qs.surfaces.pill

ShellRoot {
    Wallpaper {}

    Variants {
        model: Quickshell.screens
        delegate: PanelWindow {
            required property var modelData
            screen: modelData

            anchors { left: true; top: true; right: true }

            implicitHeight: Config.pillInfo.defaultHeight + Theme.m.sm

            mask: Region {}

            color: "#0000ffff"
        }
    }

    Pill {}

    // PanelWindow {
    //     implicitWidth: 100
    //     implicitHeight: 100
    //
    //     anchors { top: true; left: true }
    //     exclusionMode: ExclusionMode.Ignore
    //
    //     color: Colors.accent 
    // }
}

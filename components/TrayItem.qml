import QtQuick
import Quickshell
import Quickshell.Widgets

import qs.core

Rectangle {
    id: root
    required property var modelData

    implicitWidth: 30
    implicitHeight: 30
    radius: 10
    color: "transparent"

    Icon {
        name: modelData.icon
        isSvg: false
        anchors.fill: parent
        anchors.margins: 5
        iconColor: Colors.foreground
    }

    TrayMenu {
        id: trayMenu
        menuHandle: root.modelData.menu
        anchorItem: root
    }

    HoverHandler {
        onHoveredChanged: {
            root.color = hovered
                ? Qt.rgba(Colors.foreground.r, Colors.foreground.g, Colors.foreground.b, 0.4)
                : "transparent"
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (modelData.hasMenu) {
                trayMenu.visible = !trayMenu.visible
            } else {
                modelData.activate()
            }
        }
    }
}

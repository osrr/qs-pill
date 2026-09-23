import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland

import qs.core

PopupWindow {
    id: menuWindow

    property var menuHandle: null
    property var anchorItem: null

    implicitWidth: 200
    implicitHeight: column.implicitHeight + 10
    color: "transparent"

    anchor.item: anchorItem
    anchor.rect.x: 0
    anchor.rect.y: anchorItem ? anchorItem.height : 0

    grabFocus: true

    HyprlandFocusGrab {
        id: grab
        windows: [ menuWindow ]
        onCleared: menuWindow.visible = false
    }

    onVisibleChanged: {
        if (visible) Qt.callLater(() => menuRoot.forceActiveFocus())
    }

    QsMenuOpener {
        id: opener
        menu: menuWindow.menuHandle
    }

    Rectangle {
        id: menuRoot
        anchors.fill: parent
        radius: 8
        color: Colors.background
        border.color: Colors.white

        focus: true
        Keys.onEscapePressed: menuWindow.visible = false

        ColumnLayout {
            id: column
            anchors.fill: parent
            anchors.margins: 5
            spacing: 2

            Repeater {
                model: opener.children
                delegate: Item {
                    id: entryRoot
                    required property var modelData

                    Layout.fillWidth: true
                    implicitHeight: modelData.isSeparator ? 9 : 28

                    // separator
                    Rectangle {
                        visible: entryRoot.modelData.isSeparator
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.margins: 4
                        height: 1
                        color: Colors.foregroundAlt
                    }

                    // normal item
                    Rectangle {
                        visible: !entryRoot.modelData.isSeparator
                        anchors.fill: parent
                        radius: 4
                        color: itemMouse.containsMouse ? Qt.rgba(Colors.foreground.r, Colors.foreground.g, Colors.foreground.b, 0.4) : "transparent"

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 8
                            anchors.rightMargin: 8
                            spacing: 6

                            Text {
                                text: entryRoot.modelData.text
                                color: entryRoot.modelData.enabled ? Colors.foreground : Colors.foregroundAlt
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                            }

                            Text {
                                visible: entryRoot.modelData.hasChildren
                                text: "\u203a" // ›
                                color: "#aaa"
                            }
                        }

                        MouseArea {
                            id: itemMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            enabled: entryRoot.modelData.enabled
                            onClicked: {
                                if (!entryRoot.modelData.hasChildren) {
                                    entryRoot.modelData.triggered()
                                    menuWindow.visible = false
                                }
                                // submenu handling
                            }
                        }
                    }
                }
            }
        }
    }
}

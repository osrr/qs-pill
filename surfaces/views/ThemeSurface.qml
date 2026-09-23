import Quickshell
import QtQuick

import qs.core
import qs.services

Surface {
    id: root

    defaultWidth: 640
    defaultHeight: 160

    radius: 25
    requiresKeyboardFocus: true
    focus: true

    Keys.onPressed: function(event) {
        switch (event.key) {
        case Qt.Key_Left:
            event.accepted = true
            if (carouselView.currentIndex > 0)
                carouselView.currentIndex--
            break

        case Qt.Key_Right:
            event.accepted = true
            if (carouselView.currentIndex < carouselView.count - 1)
                carouselView.currentIndex++
            break

        case Qt.Key_Return:
        case Qt.Key_Enter:
            event.accepted = true
            if (carouselView.currentIndex >= 0) {
                const entry = carouselView.model.get(
                    carouselView.currentIndex 
                )
                ColorsService.setTheme(entry.path)
                controller.resetSurface()
            }
            break

        case Qt.Key_Escape:
            event.accepted = true
            controller.resetSurface()
            break
        }
    }

    Component {
        id: highlight
        Rectangle {
            width: 160; height: 120
            radius: 10
            anchors.verticalCenter: parent.verticalCenter
            color: "transparent"
            border.width: 5
            border.color: ColorsService.foreground
        }
    }

    ListView {
        id: carouselView
        anchors.fill: parent

        anchors.topMargin: Theme.m.sm
        anchors.bottomMargin: Theme.m.sm
        anchors.rightMargin: Theme.m.lg
        anchors.leftMargin: Theme.m.lg

        orientation: Qt.Horizontal
        clip: true

        highlight: highlight
        highlightMoveVelocity: -1
        highlightFollowsCurrentItem: true

        model: ColorsService.previews
        delegate: Item {
            id: wrapper
            width: 160; height: 120
            anchors.verticalCenter: parent.verticalCenter
            // Layout.alignment: Qt.AlignVCenter

            required property string name
            required property color background
            required property color foreground
            required property color red
            required property color orange
            required property color yellow
            required property color green
            required property color cyan
            required property color blue
            required property color magenta
            required property color brown

            Rectangle {
                anchors.fill: parent
                anchors.margins: 4
                radius: 8
                color: wrapper.background

                Column {
                    anchors.centerIn: parent
                    spacing: 8

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: wrapper.name
                        color: wrapper.foreground
                        font.family: Theme.font.family
                        font.weight: Theme.font.semibold
                        font.pixelSize: Theme.font.md
                        elide: Text.ElideRight
                        width: 130
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 6

                        Repeater {
                            model: [
                                wrapper.red, wrapper.orange, wrapper.yellow,
                                wrapper.green, wrapper.cyan, wrapper.blue,
                                wrapper.magenta, wrapper.brown
                            ]

                            delegate: Rectangle {
                                required property color modelData
                                width: 10; height: 10
                                radius: 5
                                color: modelData
                            }
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: forceActiveFocus()
}

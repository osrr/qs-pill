import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Services.SystemTray

import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

import qs.core
import qs.services
import qs.components
import qs.widgets

Surface {
    id: root

    expandedWidth: 612
    expandedHeight: 228 

    supportsExpanded: true
    allowExpandLock: true

    ColumnLayout {
        id: layout

        anchors.fill: parent

        anchors.topMargin: 2
        anchors.bottomMargin: root.expanded ? 8 : 2

        anchors.rightMargin: Theme.m.lg / 2
        anchors.leftMargin: Theme.m.lg / 2

        RowLayout {
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
            Layout.fillHeight: true
            // Layout.maximumHeight: 158

            spacing: Theme.spacing.md
            layoutDirection: Qt.RightToLeft

            Item {
                Layout.maximumWidth: clock.width + Theme.m.lg
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.alignment: root.expanded ? Qt.AlignRight : Qt.AlignCenter

                Text {
                    id: clock 
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: root.expanded ? -(date.height / 2) : 0

                    anchors.horizontalCenter: parent.horizontalCenter
                    // anchors.horizontalCenterOffset: root.expanded ? Theme.m.xl * 4 : 0

                    text: ClockService.time 

                    color: Colors.white
                    // color: Colors.fg 

                    font.family: Theme.font.family
                    font.weight: Theme.font.bold
                    font.pixelSize: root.expanded ? Theme.font.xxlg + 16 : Theme.font.xlg 

                    Behavior on font.pixelSize {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.OutExpo
                        }
                    }
                }

                Text {
                    id: date

                    anchors.top: clock.bottom
                    anchors.horizontalCenter: clock.horizontalCenter

                    text: "date not working"

                    color: Colors.foregroundAlt

                    font.family: Theme.font.family
                    font.weight: Theme.font.semibold
                    font.pixelSize: Theme.font.xlg

                    visible: root.expanded
                }

                Process {
                    command: ["date", "+%a-%d %b %Y"]
                    running: root.expanded
                    stdout: StdioCollector {
                        onStreamFinished: date.text = this.text
                    }
                }
            }

            // Media Player

            Item {
                visible: root.expanded
                Layout.alignment: Qt.AlignVCenter 
                Layout.fillWidth: true
                Layout.preferredHeight: parent.height - Theme.m.lg

                MediaPlayer {
                    radius: controller.state.expectedRadius - 5
                }
            }

            // media player

        }

        Rectangle {
            id: separator

            Layout.fillWidth: true
            Layout.leftMargin: Theme.m.lg
            Layout.rightMargin: Theme.m.lg

            Layout.fillHeight: true
            Layout.minimumHeight: 1
            Layout.maximumHeight: 1



            visible: root.expanded
            color: Colors.backgroundAlt
        }


        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 22
            Layout.maximumHeight: 22

            Layout.leftMargin: Theme.m.lg
            Layout.rightMargin: Theme.m.lg

            color: Qt.rgba(Colors.backgroundAlt.r, Colors.backgroundAlt.g, Colors.backgroundAlt.b, 0.0) 
            radius: 10

            visible: root.expanded

            RowLayout {
                id: tray
                anchors.centerIn: parent
                spacing: 4

                Repeater {
                    model: SystemTray.items

                    delegate: TrayItem {
                        Layout.alignment: Qt.AlignVCenter
                    }
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if(root.allowExpandLock) {
                root.controller.state.lockExpand = !root.controller.state.lockExpand
            }
        }
        z: -1
    }

}

import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import qs.core
import qs.services
import qs.components

Surface {
    id: root

    expandedWidth: 512
    expandedHeight: 128

    supportsExpanded: true

    Text {
        id: clock 
        // anchors.centerIn: root.expanded ? undefined : parent
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: root.expanded && -(date.height / 2)

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: root.expanded ? Theme.m.xl * 4 : 0

        // anchors.right: root.expanded ? parent.right : undefined

        text: ClockService.time 

        color: Colors.fg

        font.family: Theme.font.family
        font.weight: Theme.font.bold
        font.pixelSize: root.expanded ? Theme.font.xxlg + 16 : Theme.font.xlg 

        Behavior on font.pixelSize {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutExpo
            }
        }

        Behavior on anchors.horizontalCenterOffset {
            SpringAnimation {
                spring: 20
                damping: 0.8
            }
        }
    }

    Text {
        id: date

        anchors.top: clock.bottom
        anchors.horizontalCenter: clock.horizontalCenter

        text: "wed 19 2026"

        color: Colors.fgDarker

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

    RowLayout {
        visible: root.expanded

        anchors.left: parent.left
        anchors.leftMargin: Theme.m.lg
        anchors.verticalCenter: parent.verticalCenter

        implicitWidth: 200
        implicitHeight: 300

        spacing: Theme.spacing.sm

        Rectangle {
            id: mediaImg
            Layout.preferredWidth: 75
            Layout.preferredHeight: 75
            radius: 10

            ClippingWrapperRectangle {
                id: imgWrapper
                anchors.fill: parent
                radius: 5 

                Image {
                    id: image
                    anchors.fill: parent
                    source: MprisService.artUrl 
                    fillMode: Image.PreserveAspectCrop
                }
            }
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: 175 
            Layout.preferredHeight: mediaImg.height 

            ColumnLayout {
                Layout.alignment: Qt.AlignTop
                Layout.preferredWidth: parent.width
                Layout.fillHeight: true

                Text {
                    Layout.fillWidth: true

                    text: MprisService.title
                    color: Colors.fg 

                    font.family: Theme.font.family
                    font.weight: Theme.font.semibold
                    font.pixelSize: Theme.font.lg

                    elide: Text.ElideRight
                }

                Text {
                    Layout.fillWidth: true

                    text: MprisService.artist
                    color: Colors.fgDarker

                    font.family: Theme.font.family
                    font.weight: Theme.font.semibold
                    font.pixelSize: Theme.font.md

                    elide: Text.ElideRight
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignBottom
                Layout.fillWidth: true
                Layout.preferredHeight: 16 

                spacing: Theme.spacing.md

                // Rectangle {
                //     Layout.fillWidth: true 
                //     Layout.fillHeight: true 
                //
                //     color: "red"
                // }

                Icon {
                    // Layout.preferredWidth: 16
                    // Layout.preferredHeight: 16

                    name: "skip_prev"
                    size: Theme.font.icon * 1.25

                    iconColor: m_prev.hovered ? Colors.accent : Colors.fg

                    HoverHandler {
                        id: m_prev 
                    }

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton
                        onClicked: { 
                            MprisService.previous() 
                        }
                    }
                }

                Icon {
                    name: MprisService.isPlaying ? "pause" : "play_arrow"
                    size: Theme.font.icon * 1.25

                    iconColor: m_toggle.hovered ? Colors.accent : Colors.fg

                    HoverHandler {
                        id: m_toggle 
                    }

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton
                        onClicked: { 
                            MprisService.togglePlaying() 
                            console.log("Should stop playing")
                        }
                    }
                }

                Icon {
                    name: "skip_next"
                    size: Theme.font.icon * 1.25

                    iconColor: m_next.hovered ? Colors.accent : Colors.fg

                    HoverHandler {
                        id: m_next 
                    }

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton
                        onClicked: {
                            MprisService.next()
                        }
                    }
                }

            }
        }
    }
}

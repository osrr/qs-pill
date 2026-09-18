import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

import qs.core
import qs.components
import qs.services

Surface {
    id: root
    defaultWidth: 640
    defaultHeight: 64 

    radius: 25

    requiresKeyboardFocus: true

    Rectangle {
        id: searchPanel

        anchors.fill: parent

        anchors.topMargin: Theme.m.sm
        anchors.bottomMargin: Theme.m.sm

        anchors.rightMargin: Theme.m.xl
        anchors.leftMargin: Theme.m.xl

        color: "#00ffff00"

        RowLayout {
            anchors.fill: parent
            spacing: Theme.spacing.xl

            Icon {
                name: "search"
                size: Theme.font.icon + 4
                iconColor: Colors.accent
                // iconColor: Colors.fg
            }

            Rectangle {
                Layout.fillWidth: true 
                Layout.fillHeight: true
                color: "transparent"

                TextInput {
                    id: input

                    width: parent.width 
                    anchors.verticalCenter: parent.verticalCenter

                    color: Colors.fg

                    font.family: Theme.font.family
                    font.pixelSize: Theme.font.lg
                    font.weight: Theme.font.semibold

                    focus: true

                    verticalAlignment: TextInput.AlignVCenter

                    clip: true

                    onTextChanged: {
                        LauncherService.search(text)
                    }

                    onActiveFocusChanged: {
                        console.log("INPUT ACTIVE FOCUS:", activeFocus)
                    }

                    Component.onCompleted: input.forceActiveFocus()

                    Text {
                        anchors.fill: parent

                        text: "Search application e.g. Discord, Steam..."
                        color: Colors.fg

                        font.family: Theme.font.family
                        font.pixelSize: Theme.font.lg
                        font.weight: Theme.font.semibold

                        opacity: 0.6

                        visible: !parent.text 
                    }


                    Keys.onPressed: function(event) {
                        switch(event.key) {
                            case Qt.Key_Escape:
                                event.accepted = true;
                                controller.resetSurface();
                                break;
                            case Qt.Key_Down:
                                event.accepted = true;
                                LauncherService.selectNext();
                                break;
                            case Qt.Key_Up:
                                event.accepted = true;
                                LauncherService.selectPrevious();
                                break;

                            case Qt.Key_Return:
                            case Qt.Key_Enter:
                                event.accepted = true;
                                LauncherService.launchSelected();
                                controller.resetSurface();
                                break;
                        }
                    }

                }
            }
        }
    }


    // search list
    Rectangle {
        id: searchList

        property bool lock: false
        readonly property bool active: lock || (input.text && input.activeFocus) 

        implicitWidth: root.defaultWidth 
        implicitHeight: active ? 360 : 0 

        anchors.top: searchPanel.bottom
        anchors.topMargin: Theme.m.md

        radius: root.radius

        color: Colors.bg 

        Behavior on implicitHeight {
            SpringAnimation {
                spring: 20
                damping: 0.6

                onRunningChanged: {
                    if (!running) {
                        searchList.lock = true;
                    }
                }
            }
        }

        ListView {
            id: applicationList

            anchors.fill: parent

            anchors.margins: Theme.m.md

            model: LauncherService.filteredApplications

            clip: true

            currentIndex: LauncherService.selectedIndex

            delegate: Rectangle {
                width: applicationList.width
                height: 48

                radius: 12

                color: ListView.isCurrentItem
                ? Qt.rgba(Colors.accentLighter.r, Colors.accentLighter.g, Colors.accentLighter.b, 0.3) 
                : "transparent"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Theme.m.md
                    anchors.rightMargin: Theme.m.md

                    Image {
                        Layout.preferredWidth: 28
                        Layout.preferredHeight: 28

                        source: Quickshell.iconPath(modelData.icon)
                        fillMode: Image.PreserveAspectFit
                    }

                    Text {
                        Layout.fillWidth: true

                        text: modelData.name

                        color: Colors.fg 

                        font.family: Theme.font.family
                        font.pixelSize: Theme.font.md
                        font.weight: Theme.font.semibold
                    }
                }
            }
        }

    }
}

import Quickshell
import Quickshell.Widgets

import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls

import qs.core
import qs.components
import qs.services

Rectangle {
    id: root
    anchors.fill: parent

    clip: true

    color: "transparent" 

    Item {
        id: background
        anchors.fill: parent

        Image {
            id: image
            anchors.fill: parent
            source: MprisService.artUrl 
            fillMode: Image.PreserveAspectCrop
            visible: false
        }

        Rectangle {
            id: blurMask
            anchors.fill: parent
            radius: root.radius 
            visible: false 
            layer.enabled: true
        }

        MultiEffect {
            anchors.fill: blurMask 
            source: image

            blurEnabled: true
            blur: 1.0
            blurMax: 35 
            autoPaddingEnabled: false 


            maskEnabled: true
            maskSource: blurMask 
            maskThresholdMin: 0.5
            maskSpreadAtMin: 0.8

            // colorizationColor: Colors.surface
            // colorization: 0.00
        }

        Rectangle {
            anchors.fill: parent
            radius: root.radius
            // color: Qt.rgba(
            //     Colors.accent.r,
            //     Colors.accent.g,
            //     Colors.accent.b,
            //     0.45  // higher = more guaranteed contrast, lower = more art visible
            // )
            color: Colors.accent 
            opacity: 0.4
        }
    }

    // ColumnLayout {
        // anchors.fill: parent
        // // anchors.topMargin: 8.5
        // // anchors.bottomMargin: 8.5
        // anchors.rightMargin: Theme.m.lg / 2 
        // anchors.leftMargin: Theme.m.lg / 2 

        RowLayout {
            anchors.fill: parent
            // anchors.topMargin: Theme.m.lg / 2 
            // anchors.bottomMargin: Theme.m.lg / 2 
            // anchors.rightMargin: Theme.m.lg / 2 
            // anchors.leftMargin: Theme.m.lg / 2 
            anchors.margins: Theme.m.lg / 2

            // Layout.fillWidth: true
            // Layout.fillHeight: true
            // Layout.maximumHeight: 90
            spacing: 16 



            ClippingWrapperRectangle {
                id: art
                Layout.alignment: Qt.AlignTop
                Layout.preferredWidth: 100
                Layout.preferredHeight: 100 
                radius: 10 
                color: "transparent"

                Image {
                    anchors.fill: parent
                    source: MprisService.artUrl
                    fillMode: Image.PreserveAspectCrop
                }
            }


            ColumnLayout {
                Layout.alignment: Qt.AlignTop
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 1

                Text {
                    Layout.fillWidth: true

                    text: MprisService.title
                    color: Colors.white

                    font.family: Theme.font.family
                    font.weight: Theme.font.semibold
                    font.pixelSize: Theme.font.xlg

                    elide: Text.ElideRight
                }


                Text {
                    Layout.fillWidth: true

                    text: MprisService.artist
                    color: Colors.foregroundAlt

                    font.family: Theme.font.family
                    font.weight: Theme.font.semibold
                    font.pixelSize: Theme.font.lg - 2

                    elide: Text.ElideRight
                }

                Text {
                    Layout.fillWidth: true

                    text: MprisService.album
                    color: Colors.foregroundAlt

                    font.family: Theme.font.family
                    font.pixelSize: Theme.font.sm

                    elide: Text.ElideRight
                }

                // controls
                ColumnLayout {
                    Layout.fillWidth: true 
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter


                    Rectangle {
                        Layout.fillWidth: true 
                        Layout.fillHeight: true
                        color: "transparent"
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.fillWidth: true
                        Layout.preferredHeight: 16 

                        spacing: Theme.spacing.md

                        Button {
                            icon: "skip_prev"
                            Layout.preferredWidth: 32
                            Layout.preferredHeight: 32

                            bgClr: "transparent"
                            hoverClr: Colors.surface

                            onClick: MprisService.previous()
                        }

                        Button {
                            icon: MprisService.isPlaying ? "pause" : "play_arrow"
                            Layout.preferredWidth: 32
                            Layout.preferredHeight: 32

                            bgClr: "transparent"
                            hoverClr: Colors.surface

                            onClick: MprisService.togglePlaying()
                        }

                        Button {
                            icon: "skip_next"
                            Layout.preferredWidth: 32
                            Layout.preferredHeight: 32

                            bgClr: "transparent"
                            hoverClr: Colors.surface

                            onClick: MprisService.next()
                        }
                    }
                }

            }

            

        }

    // }


    // RowLayout {
    //     anchors.fill: parent
    //     // anchors.topMargin: Theme.m.lg / 2
    //     // anchors.bottomMargin: Theme.m.lg / 2 
    //     anchors.rightMargin: Theme.m.lg / 2
    //     anchors.leftMargin: Theme.m.lg / 2
    //     spacing: 10
    //
    //     ClippingWrapperRectangle {
    //         Layout.preferredWidth: 75
    //         Layout.preferredHeight: 75
    //         radius: 5
    //
    //         Image {
    //             anchors.fill: parent
    //             source: MprisService.artUrl
    //             fillMode: Image.PreserveAspectCrop
    //         }
    //     }
    //
    //     ColumnLayout {
    //
    //         ColumnLayout {
    //             Layout.alignment: Qt.AlignTop
    //             Layout.preferredWidth: parent.width
    //             Layout.fillHeight: true
    //             spacing: 1
    //
    //             Text {
    //                 Layout.fillWidth: true
    //
    //                 text: MprisService.title
    //                 color: Colors.white
    //
    //                 font.family: Theme.font.family
    //                 font.weight: Theme.font.semibold
    //                 font.pixelSize: Theme.font.lg
    //
    //                 elide: Text.ElideRight
    //             }
    //
    //             Text {
    //                 Layout.fillWidth: true
    //
    //                 text: MprisService.artist
    //                 color: Colors.foregroundAlt
    //
    //                 font.family: Theme.font.family
    //                 font.weight: Theme.font.semibold
    //                 font.pixelSize: Theme.font.lg - 2
    //
    //                 elide: Text.ElideRight
    //             }
    //         }
    //
    //         RowLayout {
    //             Layout.alignment: Qt.AlignBottom | Qt.AlignCenter
    //             Layout.fillWidth: true
    //             Layout.preferredHeight: 16 
    //
    //             spacing: Theme.spacing.md
    //
    //             Icon {
    //
    //                 name: "skip_prev"
    //                 size: Theme.font.icon * 1.25
    //
    //                 iconColor: m_prev.hovered ? Colors.foreground : Colors.white
    //
    //                 HoverHandler {
    //                     id: m_prev 
    //                 }
    //
    //                 MouseArea {
    //                     anchors.fill: parent
    //                     acceptedButtons: Qt.LeftButton
    //                     onClicked: { 
    //                         MprisService.previous() 
    //                     }
    //                 }
    //             }
    //
    //             Icon {
    //                 name: MprisService.isPlaying ? "pause" : "play_arrow"
    //                 size: Theme.font.icon * 1.25
    //
    //                 iconColor: m_toggle.hovered ? Colors.foreground : Colors.white
    //
    //                 HoverHandler {
    //                     id: m_toggle 
    //                 }
    //
    //                 MouseArea {
    //                     anchors.fill: parent
    //                     acceptedButtons: Qt.LeftButton
    //                     onClicked: { 
    //                         MprisService.togglePlaying() 
    //                         console.log("Should stop playing")
    //                     }
    //                 }
    //             }
    //
    //             Icon {
    //                 name: "skip_next"
    //                 size: Theme.font.icon * 1.25
    //
    //                 iconColor: m_next.hovered ? Colors.foreground : Colors.white
    //
    //                 HoverHandler {
    //                     id: m_next 
    //                 }
    //
    //                 MouseArea {
    //                     anchors.fill: parent
    //                     acceptedButtons: Qt.LeftButton
    //                     onClicked: {
    //                         MprisService.next()
    //                     }
    //                 }
    //             }
    //
    //         }
    //     }
    // }


}

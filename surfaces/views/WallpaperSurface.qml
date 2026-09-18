import Quickshell
import Quickshell.Widgets
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

            if (carouselView.currentIndex <
                carouselView.count - 1)
                carouselView.currentIndex++

            break

        case Qt.Key_Return:
        case Qt.Key_Enter:
            event.accepted = true

            if (carouselView.currentIndex >= 0) {
                const wallpaper =
                    carouselView.model.get(
                        carouselView.currentIndex,
                        "fileUrl"
                    )

                WallpaperService.setWallpaper(wallpaper)
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
            width: 200; height: 120
            radius: 10
            anchors.verticalCenter: parent.verticalCenter
            color: "transparent"

            border.width: 5
            border.color: Colors.accent 


            // x: carouselView.currentItem ? carouselView.currentItem.x : 0
            // Behavior on x {
            //     NumberAnimation {
            //         duration: 200
            //         easing.type: Easing.Linear
            //     }
            // }
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

        // focus: true
        clip: true

        highlight: highlight
        highlightMoveVelocity: -1
        highlightFollowsCurrentItem: true 

        model: WallpaperService.wallpapers
        delegate: Item {
            id: wrapper
            width: 200; height: 120
            anchors.verticalCenter: parent.verticalCenter

            ClippingWrapperRectangle {
                id: imgWrapper
                anchors.fill: parent
                anchors.margins: 4
                radius: 5

                Image {
                    id: image
                    anchors.fill: parent
                    source: model.fileUrl
                    fillMode: Image.PreserveAspectCrop
                }
            }
        }
    }


    Component.onCompleted: {
        forceActiveFocus()
    }
}

import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick
import QtQuick.Effects

import qs.core
import qs.components

import qs.surfaces
import qs.surfaces.pill

Variants {
    model: Quickshell.screens
    delegate: PanelWindow {
        id: root 
        required property var modelData

        screen: modelData

        anchors { top: true; right: true; left: true }

        implicitHeight: 860 

        WlrLayershell.layer: WlrLayer.Top
        exclusionMode: ExclusionMode.Ignore

        mask: Region {
            item: pill
        }

        color: "#00ff0000"

        PillController {
            id: controller
            screen: modelData
        }

        focusable: controller.currentSurface !== SurfaceRegistery.SurfaceType.Clock 
        // WlrLayershell.keyboardFocus: controller.state.requiresKeyboardFocus
        //     ? WlrKeyboardFocus.OnDemand
        //     : WlrKeyboardFocus.None

        HyprlandFocusGrab {
            id: inputGrab
            windows: [root]
            active: root.focusable

            onCleared: {
                controller.resetSurface()
            }
        }

        Connections {
            target: ShortcutManager

            function onLauncher() {
                if (!controller.isFocusedMonitor()){
                    return
                }

                if (
                    controller.currentSurface
                    === SurfaceRegistery.SurfaceType.Launcher
                ) {
                    controller.resetSurface()
                    return
                }

                controller.toggleSurface(
                    SurfaceRegistery.SurfaceType.Launcher
                )

                // root.requestActivate()
                pill.forceActiveFocus()
            }

            function onWallpaper() {
                if(!controller.isFocusedMonitor()) {
                    return
                }

                if(controller.currentSurface === SurfaceRegistery.SurfaceType.Wallpaper) {
                    controller.resetSurface()
                    return
                }

                controller.toggleSurface(
                    SurfaceRegistery.SurfaceType.Wallpaper
                )

                pill.forceActiveFocus()
            }
        }

        FocusScope {
            id: pill 

            function releaseFocus() {
                focus = false;
            }

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.margins: Theme.m.sm / 2

            implicitWidth: controller.state.expectedWidth 
            implicitHeight: controller.state.expectedHeight 

            focus: true

            Rectangle {
                id: background
                anchors.fill: parent

                radius: controller.state.expectedRadius

                color: Colors.bg
            }

            RectangularShadow {
                anchors.fill: background
                offset.x: 0
                offset.y: 5
                radius: background.radius
                blur: 20
                spread: 2
                opacity: 0.2
                // color: Qt.darker(background.color, 1.6)
                color: Colors.accent
                z: -1
            }

            Loader {
                id: surfaceLoader

                anchors.fill: parent
                function loadSurface() {
                    setSource(
                        controller.currentSurfaceSource,
                        {
                            "controller": controller
                        }
                    )
                }

                function updateSurface() {
                    if(!item)
                        return;

                    controller.setNewSurface(item)
                }

                Component.onCompleted: {
                    loadSurface()
                }

                onLoaded: {
                    updateSurface()
                }

                Connections {
                    target: controller

                    function onCurrentSurfaceSourceChanged() {
                        surfaceLoader.loadSurface()
                    }
                }
            }

            Behavior on implicitWidth {
                // NumberAnimation {
                //     duration: 200
                //     easing.type: Easing.OutExpo
                // }
                SpringAnimation {
                    spring: 20
                    damping: 0.8
                }
            }

            Behavior on implicitHeight {
                // NumberAnimation {
                //     duration: 600
                //     easing.type: Easing.OutExpo
                // }
                SpringAnimation {
                    spring: 20
                    damping: 0.5
                }
            }

            // Behavior on radius {
            //     // NumberAnimation {
            //     //     duration: 800
            //     //     easing.type: Easing.OutExpo
            //     // }
            //     SpringAnimation {
            //         spring: 20
            //         damping: 0.6
            //     }
            // }

           onActiveFocusChanged: {
                // if(!activeFocus) {
                //     controller.resetSurface()
                // }
                console.log(
                    "PILL:",
                    "activeFocus =", activeFocus,
                    "focus =", focus
                )
            }

            HoverHandler {
                id: mouse

                onHoveredChanged: {
                    if (hovered) {
                        controller.setExpanded(true)
                    } else {
                        controller.reset();
                    }
                }
            }

        }
    }
}

import Quickshell
import Quickshell.Hyprland
import QtQuick

import qs.core
import qs.surfaces
import qs.surfaces.views


QtObject {
    required property var screen

    component PillState: QtObject {
        property int expectedWidth: Config.pillInfo.defaultWidth 
        property int expectedHeight: Config.pillInfo.defaultHeight 
        property real expectedRadius: defaultHeight / 2

        property int defaultWidth: Config.pillInfo.defaultWidth 
        property int defaultHeight: Config.pillInfo.defaultHeight 

        property int expandedWidth: Config.pillInfo.defaultWidth 
        property int expandedHeight: Config.pillInfo.defaultHeight 

        property real radius: defaultHeight / 2
        property real expandedRadius: 25

        property bool expanded: false
        property bool supportsExpanded: false 

        property bool requiresKeyboardFocus: false
    }

    property PillState state: PillState {}

    property int currentSurface: SurfaceRegistery.SurfaceType.Clock
    property string currentSurfaceSource: SurfaceRegistery.source(currentSurface)

    function isFocusedMonitor() {
        return Hyprland.monitorFor(screen) === Hyprland.focusedMonitor
    }

    function setSurface(surface) {
        currentSurface = surface 
    }

    function toggleSurface(surface) {
        if (currentSurface === surface) {
            setSurface(SurfaceRegistery.SurfaceType.Clock)
        }
        else {
            setSurface(surface)
        }
    }

    function setNewSurface(item) {
        state.defaultWidth = item.defaultWidth;
        state.defaultHeight = item.defaultHeight;

        state.expandedWidth = item.expandedWidth;
        state.expandedHeight = item.expandedHeight;

        state.radius = item.radius;
        state.expandedRadius = item.expandedRadius;

        state.supportsExpanded = item.supportsExpanded;
        state.requiresKeyboardFocus = item.requiresKeyboardFocus

        updateSize()
    }

    function updateSize() {
        if(state.expanded && state.supportsExpanded) {
            state.expectedWidth = state.expandedWidth
            state.expectedHeight = state.expandedHeight
            state.expectedRadius = state.expandedRadius
        } else {
            state.expectedWidth = state.defaultWidth
            state.expectedHeight = state.defaultHeight
            state.expectedRadius = state.radius
        }
    }

    function setExpanded(expanded) {
        if(!state.supportsExpanded) {
            state.expanded = false
            return
        }

        state.expanded = expanded
        updateSize()
    }

    function reset() {
        state.expanded = false;
        updateSize()
    }

    function resetSurface() {
        setSurface(SurfaceRegistery.SurfaceType.Clock)
        reset()
    }

}

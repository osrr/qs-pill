import Quickshell
import QtQuick

import qs.core
import qs.surfaces.pill

Item {
    id: surface 
    required property var controller

    property int defaultWidth: Config.pillInfo.defaultWidth
    property int defaultHeight: Config.pillInfo.defaultHeight

    property int expandedWidth: defaultWidth 
    property int expandedHeight: defaultHeight 

    property real radius: defaultHeight / 2
    property real expandedRadius: 25

    property bool supportsExpanded: false
    readonly property bool expanded: controller.state.expanded 

    property bool requiresKeyboardFocus: false
}

import Quickshell
import QtQuick
import QtQuick.Effects
import Quickshell.Widgets

import qs.core

Item {
    id: root
    required property string name
    property real size: 16
    property color iconColor: "#fff" 

    property bool isSvg: true;

    implicitWidth: size 
    implicitHeight: size 

    IconImage {
        id: icon

        source: isSvg ? Qt.resolvedUrl("../assets/" + name + ".svg") : name


        anchors.fill: parent
        anchors.centerIn: parent
        visible: false
        layer.enabled: true
    }

    Rectangle {
        id: colorSource
        anchors.fill: parent
        color: root.iconColor
        visible: false
    }

    MultiEffect {
        anchors.fill: parent 
        source: colorSource 

        maskEnabled: true
        maskSource: icon
        maskThresholdMin: 0.5
        maskSpreadAtMin: 0.8
    }
}

// Item {
//     id: root
//
//     required property string icon
//
//     property int size: Theme.font.icon
//     property string color: "#fff"
//
//     Text {
//         anchors.centerIn: parent
//
//         text: root.icon
//         color: root.color
//
//         font.family: Theme.font.iconFont
//         font.pixelSize: root.size
//         font.variableAxes: {
//             "FILL": 1,
//             "wght": 400,
//             "GRAD": 0,
//             "opsz": 24
//         }
//     }
// }

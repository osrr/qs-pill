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

    implicitWidth: size 
    implicitHeight: size 

    IconImage {
        id: icon

        source: Qt.resolvedUrl("../assets/" + name + ".svg")


        anchors.fill: parent
        anchors.centerIn: parent
    }

    MultiEffect {
        source: icon
        anchors.fill: icon
        colorization: 1.0
        colorizationColor: root.iconColor 
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

import Quickshell
import QtQuick 

import qs.core

Rectangle {
    id: root

    property string text: ""
    property string icon: ""

    property color bgClr: Colors.backgroundAlt
    property color hoverClr: Colors.foreground 

    property color contentClr: Colors.white 

    signal click;

    radius: 10
    color: bgClr 

    // implicitWidth: text.length === 0 ? elIcon.width : elText.width
    // implicitHeight: text.length === 0 ? elIcon.height : elText.height
    // anchors.margins: 10

    Text {
        id: elText
        visible: root.text.length !== 0

        text: root.text
        color: root.contentClr

        font.family: Theme.font.family
        font.weight: Theme.font.semibold

        anchors.fill: parent
        anchors.margins: 5
    }

    Icon {
        id: elIcon
        visible: root.text.length === 0

        name: root.icon
        iconColor: root.contentClr

        anchors.fill: parent
        anchors.margins: 5
    }

    HoverHandler {
        onHoveredChanged: root.color = hovered ? root.hoverClr : root.bgClr
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.click()
    }
}

pragma Singleton

import Quickshell
import QtQuick

Singleton {
    component PillInfo: QtObject {
        property int defaultWidth: 128 
        property int defaultHeight: 36
    }

    property PillInfo pillInfo: PillInfo {} 
}

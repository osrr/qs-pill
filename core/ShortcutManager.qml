pragma Singleton

import Quickshell
import Quickshell.Hyprland
import QtQuick

Singleton {
    id: root

    signal launcher()
    GlobalShortcut {
        name: "launcher"
        description: "Open Launcher"

        onPressed: {
            root.launcher()
        }
    }

    signal wallpaper()
    GlobalShortcut {
        name: "wallpaper"
        description: "Open wallpaper selector"

        onPressed: {
            root.wallpaper()
        }
    }

    signal dashboardTriggered()
    Shortcut {
        sequence: "Super+Comma"
        onActivated: {
            root.dashboardTriggered()
        }
    }
}

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

    signal theme()
    GlobalShortcut {
        name: "theme"
        description: "Open theme selector"

        onPressed: {
            root.theme()
        }
    }

    signal control_center()
    GlobalShortcut {
        name: "cc"
        description: "Open Control Center"

        onPressed: {
            root.control_center()
        }
    }
}

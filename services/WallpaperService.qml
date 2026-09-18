pragma Singleton

import Quickshell
import Quickshell.Io

import QtQuick
import Qt.labs.folderlistmodel

import qs.services

Singleton {
    id: root

    readonly property string wallpaperDirectory:
        Quickshell.env("HOME") + "/Pictures/Wallpapers"

    property string wallpaper: ""
    property bool restored: false
    readonly property alias wallpapers: wallpaperModel

    FolderListModel {
        id: wallpaperModel
        folder: "file://" + root.wallpaperDirectory
        nameFilters: ["*.png", "*.jpg", "*.jpeg", "*.webp"]
        showDirs: false
        showFiles: true
        showHidden: false
        sortField: FolderListModel.Name

        onCountChanged: {
            if (!root.wallpaper && count > 0)
                root.wallpaper = get(0, "fileUrl")
        }
    }

    Connections {
        target: WalService
        function onWallpaperPathChanged() {
            if(root.restored) return
            if(!WalService.wallpaperPath) return 

            root.restored = true
            root.wallpaper = "file://"+encodeURI(WalService.wallpaperPath)
        }
    }

    Process {
        id: walProcess
        onExited: (exitCode) => console.log("wal exited with", exitCode)
    }

    function setWallpaper(path) {
        wallpaper = path
        restored = true
        generateColors(path)
    }

    function generateColors(path) {
        let resolvedUrl = Qt.resolvedUrl(path).toString()
        let localPath = resolvedUrl.replace(/^file:\/\//, "")
        console.log("Image Path:", localPath)

        // kill any in-flight wal run so results can't arrive out of order
        if (walProcess.running)
            walProcess.running = false

        walProcess.command = ["wal", "-i", localPath, "-n", "-s"]
        walProcess.running = true
    }
}

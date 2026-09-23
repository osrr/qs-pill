pragma Singleton

import Quickshell
import Quickshell.Io

import QtQuick
import Qt.labs.folderlistmodel

Singleton {
    id: root

    readonly property string themesDirectory:
        Quickshell.env("HOME") + "/.config/quickshell/themes"

    readonly property string stateDir:
        Quickshell.env("HOME") + "/.local/state/quickshell"

    property string currentThemePath: ""
    property bool restored: false

    readonly property alias previews: previewModel

    property color background:     "#000000"
    property color backgroundAlt:  "#000000"
    property color surface:        "#000000"
    property color surfaceAlt:     "#000000"
    property color foreground:     "#ffffff"
    property color foregroundAlt:  "#ffffff"
    property color white:  "#000000"

    property color red:     "#ff0000"
    property color orange:  "#ffa500"
    property color yellow:  "#ffff00"
    property color green:   "#00ff00"
    property color cyan:    "#00ffff"
    property color blue:    "#0000ff"
    property color magenta: "#ff00ff"
    property color brown:   "#a52a2a"

    ListModel { id: previewModel }

    // watches the directory purely to know WHEN to rescan (inotify-backed,
    // event-driven, not a poller) - we don't use this model's data directly
    FolderListModel {
        id: dirWatcher
        folder: "file://" + root.themesDirectory
        nameFilters: ["*.yaml", "*.yml"]
        showDirs: false
        showFiles: true

        onCountChanged: {
            if (count > 0) root.rescan()
        }
    }

    Process {
        id: scanProcess
        stdout: StdioCollector {
            onStreamFinished: root.applyScanResults(text)
        }
    }

    Process {
        id: restoreProcess
        stdout: StdioCollector {
            onStreamFinished: root.applyRestoredPath(text)
        }
    }

    Process {
        id: stateProcess
    }

    function rescan() {
        scanProcess.command = [
            "bash", "-c",
            `for f in "${root.themesDirectory}"/*.yaml "${root.themesDirectory}"/*.yml; do ` +
            `[ -f "$f" ] || continue; echo "@@THEME_FILE@@$f"; cat "$f"; echo; done`
        ]
        scanProcess.running = false
        scanProcess.running = true
    }

    function applyScanResults(data) {
        previewModel.clear()

        const chunks = data.split("@@THEME_FILE@@").filter(c => c.trim().length > 0)

        for (const chunk of chunks) {
            const newlineIndex = chunk.indexOf("\n")
            const path = chunk.substring(0, newlineIndex).trim()
            const content = chunk.substring(newlineIndex + 1)

            const p = parseBase16(content)
            if (!p["00"] || !p["07"]) continue // skip unparseable files

            const pal = paletteFrom(p)
            const name = path.split("/").pop().replace(/\.(yaml|yml)$/, "")

            previewModel.append({
                name: name,
                path: path,
                background: pal.background,
                backgroundAlt: pal.backgroundAlt,
                surface: pal.surface,
                surfaceAlt: pal.surfaceAlt,
                foreground: pal.foreground,
                foregroundAlt: pal.foregroundAlt,
                white: pal.white,
                red: pal.red, orange: pal.orange, yellow: pal.yellow,
                green: pal.green, cyan: pal.cyan, blue: pal.blue,
                magenta: pal.magenta, brown: pal.brown
            })
        }

        console.log("themes loaded:", previewModel.count)

        if (!root.restored) restoreState()
    }

    function parseBase16(data) {
        const result = {}
        const regex = /base(0[0-9a-fA-F])\s*:\s*["']?#?([0-9a-fA-F]{6})["']?/g
        let match
        while ((match = regex.exec(data)) !== null)
            result[match[1].toLowerCase()] = match[2].toLowerCase()
        return result
    }

    function paletteFrom(p) {
        return {
            background:    "#" + p["00"],
            backgroundAlt: "#" + (p["01"] ?? p["00"]),
            surface:       "#" + (p["02"] ?? p["00"]),
            surfaceAlt:    "#" + (p["03"] ?? p["01"]),
            foregroundAlt: "#" + (p["04"] ?? p["05"]),
            foreground:    "#" + p["05"],
            white:    "#" + p["07"],
            red:     "#" + p["08"],
            orange:  "#" + p["09"],
            yellow:  "#" + p["0a"],
            green:   "#" + p["0b"],
            cyan:    "#" + p["0c"],
            blue:    "#" + p["0d"],
            magenta: "#" + p["0e"],
            brown:   "#" + p["0f"]
        }
    }

    function setTheme(path) {
        console.log(path)
        for (let i = 0; i < previewModel.count; i++) {
            const entry = previewModel.get(i)
            if (entry.path === path) {
                root.background = entry.background
                root.backgroundAlt = entry.backgroundAlt
                root.surface = entry.surface
                root.surfaceAlt = entry.surfaceAlt
                root.foreground = entry.foreground
                root.foregroundAlt = entry.foregroundAlt
                root.white = entry.white
                root.red = entry.red
                root.orange = entry.orange
                root.yellow = entry.yellow
                root.green = entry.green
                root.cyan = entry.cyan
                root.blue = entry.blue
                root.magenta = entry.magenta
                root.brown = entry.brown

                root.currentThemePath = path
                root.restored = true
                persistTheme(path)
                return
            }
        }
        console.log("setTheme: no match found for", path)
    }

    function persistTheme(path) {
        stateProcess.command = [
            "bash", "-c",
            `mkdir -p '${root.stateDir}' && printf '%s' '${path}' > '${root.stateDir}/theme-path'`
        ]
        stateProcess.running = false
        stateProcess.running = true
    }

    function restoreState() {
        restoreProcess.command = ["cat", root.stateDir + "/theme-path"]
        restoreProcess.running = false
        restoreProcess.running = true
    }

    function applyRestoredPath(data) {
        const savedPath = data.trim()
        root.restored = true
        if (savedPath) root.setTheme(savedPath)
    }

    Component.onCompleted: console.log("ColorsService alive")
}

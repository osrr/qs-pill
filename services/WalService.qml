pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick


Singleton {
    id: root

    readonly property string colorsFile:
        Quickshell.env("HOME") + "/.cache/wal/colors.json"

    property string wallpaperPath: ""

    property color background: "#000000"
    property color foreground: "#ffffff"
    property color darkest: "#000000"
    property color brightest: "#ffffff"
    property color dominant: "#000000"
    property color accent: "#ffffff"
    property color secondary: "#ffffff"

    property int retries: 0

    FileView {
        id: file
        path: root.colorsFile
        watchChanges: true
        onFileChanged: reloadTimer.restart()
    }

    // debounce + gives wal's write time to fully land on disk
    Timer {
        id: reloadTimer
        interval: 80
        repeat: false
        onTriggered: root.readColors()
    }

    Process {
        id: catProcess
        command: ["cat", root.colorsFile]
        stdout: StdioCollector {
            onStreamFinished: root.tryParse(text)
        }
    }

    function readColors() {
        catProcess.running = false
        catProcess.running = true
    }

    function tryParse(data) {
        try {
            root.parseColors(data)
            root.retries = 0
        } catch (e) {
            if (root.retries < 5) {
                root.retries++
                reloadTimer.restart() // file was probably mid-write, try again shortly
            } else {
                console.log("wal: giving up parsing colors.json:", e)
                root.retries = 0
            }
        }
    }

    Component.onCompleted: readColors()

    function luminance(color) {
        return 0.2126 * color.r + 0.7152 * color.g + 0.0722 * color.b
    }

    function findDarkest(colors) {
        let result = colors[0]
        let lowest = luminance(result)
        for (const color of colors) {
            const value = luminance(color)
            if (value < lowest) { lowest = value; result = color }
        }
        return result
    }

    function findBrightest(colors) {
        let result = colors[0]
        let highest = luminance(result)
        for (const color of colors) {
            const value = luminance(color)
            if (value > highest) { highest = value; result = color }
        }
        return result
    }

    function findAccent(colors) {
        let result = colors[0]
        let highest = -1
        for (const color of colors) {
            const score = color.hsvSaturation * color.hsvValue
            if (score > highest) { highest = score; result = color }
        }
        return result
    }

    function findSecondary(colors, accent) {
        let result = colors[0]
        let highest = -1
        for (const color of colors) {
            if (color === accent) continue
            const score = color.hsvSaturation * color.hsvValue
            if (score > highest) { highest = score; result = color }
        }
        return result
    }

    function parseColors(data) {
        const json = JSON.parse(data)

        root.wallpaperPath = json.wallpaper ?? ""

        root.background = json.special.background
        root.foreground = json.special.foreground

        const colors = []
        for (let i = 0; i < 16; i++)
            colors.push(Qt.color(json.colors["color" + i]))

        root.darkest = findDarkest(colors)
        root.brightest = findBrightest(colors)
        root.accent = findAccent(colors)
        root.secondary = findSecondary(colors, root.accent)

        console.log("=== WAL ===")
        console.log("darkest:", root.darkest)
        console.log("brightest:", root.brightest)
        console.log("accent:", root.accent)
        console.log("secondary:", root.secondary)
    }
}

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
    property color accent: "#ffffff"
    property color secondary: "#ffffff"

    property int retries: 0

    // ---------- watch colors.json (written by wal) ----------

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

    // ---------- pywal-palette-derived helpers (darkest/brightest/secondary) ----------

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

    function findSecondary(colors) {
        let result = colors[0]
        let highest = -1
        for (const color of colors) {
            const score = color.hsvSaturation * color.hsvValue
            if (score > highest) { highest = score; result = color }
        }
        return result
    }

    // ---------- real-pixel accent extraction (this replaces findAccent) ----------

    Process {
        id: accentProcess
        stdout: StdioCollector {
            onStreamFinished: root.applyAccent(text.trim())
        }
    }

    function computeAccent(path) {
        if (!path) return

        const script = `
import sys, colorsys
from PIL import Image

path = sys.argv[1]
img = Image.open(path).convert("RGB")
img.thumbnail((150, 150))
img = img.quantize(colors=12, method=Image.MEDIANCUT).convert("RGB")
colors = img.getcolors(150 * 150) or []

best, best_score = None, -1
for count, (r, g, b) in colors:
    h, s, v = colorsys.rgb_to_hsv(r / 255, g / 255, b / 255)
    if s < 0.15 or v < 0.15 or v > 0.97:
        continue
    score = count * s * v
    if score > best_score:
        best_score, best = score, (r, g, b)

if best is None:
    _, (r, g, b) = max(colors, key=lambda c: c[0])
    best = (r, g, b)

print("#%02x%02x%02x" % best)
`
        accentProcess.command = ["python3", "-c", script, path]
        accentProcess.running = false
        accentProcess.running = true
    }

    function applyAccent(hex) {
        if (!hex.startsWith("#")) {
            console.log("wal: accent script returned bad output:", hex)
            return
        }
        root.accent = hex
        root.applyToHyprland()
        console.log("accent from image:", hex)
    }

    // ---------- hyprland live border color ----------

    function colorToHyprHex(c) {
        const r = Math.round(c.r * 255).toString(16).padStart(2, "0")
        const g = Math.round(c.g * 255).toString(16).padStart(2, "0")
        const b = Math.round(c.b * 255).toString(16).padStart(2, "0")
        return r + g + b
    }

    Process {
        id: hyprctlProcess
    }

    function applyToHyprland() {
        const hex = colorToHyprHex(root.accent)
        const cmd = "hl.config({ general = { col = { active_border = \"rgba(" + hex + "ee)\" } } })"

        hyprctlProcess.command = ["hyprctl", "eval", cmd]
        hyprctlProcess.running = true
    }    

    // ---------- entry point ----------

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
        root.secondary = findSecondary(colors)

        root.computeAccent(root.wallpaperPath)

        console.log("=== WAL ===")
        console.log("darkest:", root.darkest)
        console.log("brightest:", root.brightest)
        console.log("secondary:", root.secondary)
        // console.log("accent:", root.accent)
    }
}

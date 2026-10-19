import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../.."

BotBubble {
    id: weatherbubble
    col: Theme.colYellow

    property bool full: false

    property var w: null
    readonly property bool ok: w !== null && !w.error

    // Small reusable text styles
    component WText: Text {
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
        color: Theme.colYellow
    }
    component WDim: WText {
        opacity: 0.6
    }

    ico: w && w.icon ? w.icon : "󰖐"
    bottomtxt: ok ? (w.temp + w.tunit) : "-"

    topit: ColumnLayout {
        visible: weatherbubble.full
        spacing: 3
        Layout.alignment: Qt.AlignHCenter

        // ── Error / no-data state ─────────────────────────────
        WText {
            visible: !weatherbubble.ok
            Layout.alignment: Qt.AlignHCenter
            horizontalAlignment: Text.AlignHCenter
            text: weatherbubble.w ? "Weather error\n" + weatherbubble.w.error : "No weather data"
        }

        // ── Header: condition + city ──────────────────────────
        WText {
            visible: weatherbubble.ok
            Layout.alignment: Qt.AlignHCenter
            text: weatherbubble.ok ? weatherbubble.w.desc : ""
            font.bold: true
        }
        WDim {
            visible: weatherbubble.ok && weatherbubble.w.city !== ""
            Layout.alignment: Qt.AlignHCenter
            text: weatherbubble.ok ? weatherbubble.w.city : ""
            font.pixelSize: Theme.fontSize - 2
        }

        Rectangle {
            visible: weatherbubble.ok
            Layout.fillWidth: true
            Layout.topMargin: 2
            Layout.bottomMargin: 2
            implicitHeight: 1
            color: Theme.colYellow
            opacity: 0.25
        }

        // ── Details: label on the left, value on the right ────
        GridLayout {
            visible: weatherbubble.ok
            Layout.alignment: Qt.AlignHCenter
            columns: 2
            columnSpacing: 14
            rowSpacing: 2

            WDim { text: "Feels like" }
            WText {
                Layout.alignment: Qt.AlignRight
                text: weatherbubble.ok ? weatherbubble.w.feels + weatherbubble.w.tunit : ""
            }

            WDim { text: "Humidity" }
            WText {
                Layout.alignment: Qt.AlignRight
                text: weatherbubble.ok ? weatherbubble.w.humidity + "%" : ""
            }

            WDim { text: "High / Low" }
            WText {
                Layout.alignment: Qt.AlignRight
                text: weatherbubble.ok ? weatherbubble.w.high + "° / " + weatherbubble.w.low + "°" : ""
            }

            WDim { text: "Rain" }
            WText {
                Layout.alignment: Qt.AlignRight
                text: weatherbubble.ok ? weatherbubble.w.rain + "%" : ""
            }

            WDim { text: "Wind" }
            WText {
                Layout.alignment: Qt.AlignRight
                text: weatherbubble.ok ? weatherbubble.w.wind + " " + weatherbubble.w.wunit : ""
            }
        }

        // ── Footer ────────────────────────────────────────────
        WDim {
            visible: weatherbubble.ok && weatherbubble.w.updated !== undefined
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 2
            text: weatherbubble.ok ? "Updated " + weatherbubble.w.updated : ""
            font.pixelSize: Theme.fontSize - 3
        }
    }

    // Reloads automatically whenever weather.py rewrites the file
    FileView {
        path: Quickshell.env("HOME") + "/.cache/weather.json"
        watchChanges: true
        printErrors: false
        onFileChanged: reload()
        onLoadFailed: weatherbubble.w = null
        onLoaded: {
            const raw = text().trim()
            if (!raw) return
            try {
                weatherbubble.w = JSON.parse(raw)
            } catch (e) {
                console.warn("weather: bad JSON", e)
            }
        }
    }
}

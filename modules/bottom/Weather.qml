import QtQuick
import Quickshell
import Quickshell.Io
import "../.."

BotBubble {
    id: weatherbubble
    col: Theme.colYellow

    property bool full: false

    property var w: null
    readonly property bool ok: w !== null && !w.error

    readonly property string detailTitle: ok
        ? w.desc + (w.city ? " · " + w.city : "")
        : (w ? "Weather error" : "No weather data")

    readonly property var detailRows: ok ? [
        { label: "Feels like", value: w.feels + w.tunit },
        { label: "Humidity",   value: w.humidity + "%" },
        { label: "High / Low", value: w.high + "° / " + w.low + "°" },
        { label: "Rain",       value: w.rain + "%" },
        { label: "Wind",       value: w.wind + " " + w.wunit }
    ] : (w ? [{ label: "", value: String(w.error) }] : [])

    readonly property var detailFooter:
        ok && w.updated !== undefined ? [{ label: "Updated", value: String(w.updated) }] : []

    ico: w && w.icon ? w.icon : "󰖐"
    bottomtxt: ok ? (w.temp + w.tunit) : "-"

    topit: DetailList {
        visible: weatherbubble.full
        col: Theme.colYellow
        title: weatherbubble.detailTitle
        titleBold: true
        titleOpacity: 1
        titleSize: Theme.fontSize
        rows: weatherbubble.detailRows
        footer: weatherbubble.detailFooter
    }

    FileView {
        path: Quickshell.env("HOME") + "/.cache/weather.json"
        watchChanges: true
        blockLoading: true
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

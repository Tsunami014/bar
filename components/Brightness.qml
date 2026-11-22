pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Io
import "../.."

Singleton { id: root
    property int value: 100
    property bool ready: false

    Process {
        id: reader
        command: ["sh", "-c", "brightnessctl info | grep -o -P '[0-9]+(?=%)' -m 1"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                const v = parseInt(data.trim())
                root.value = isNaN(v) ? 100 : v
                root.ready = true
            }
        }
    }
    function refresh() { reader.running = true }

    Process { id: writer }
    function set(pct) {
        root.value = Math.round(pct)
        writer.command = ["brightnessctl", "set", root.value + "%"]
        writer.running = true
    }

    property string ico: (
        value <= 5 ? "" :
        value <= 10 ? "" :
        value <= 20 ? "" :
        value <= 30 ? "" :
        value <= 40 ? "" :
        value <= 48 ? "" :
        value <= 52 ? "" :
        value <= 60 ? "" :
        value <= 70 ? "" :
        value <= 80 ? "" :
        value <= 90 ? "" :
        value <= 95 ? "" :
        "")

    Component.onCompleted: refresh()
}

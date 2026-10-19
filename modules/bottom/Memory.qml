import QtQuick
import Quickshell.Io
import "../.."

BotBubble {
    id: membubble
    col: Theme.colBlue

    property bool full: false

    property int memUsage: 0
    property real memUsedGb: 0
    property real memTotalGb: 0
    property var topProcs: []
    property var tmpProcs: []

    function fmtKib(k) {
        return k >= 1048576 ? (k / 1048576).toFixed(1) + " GiB"
                            : Math.round(k / 1024) + " MiB"
    }

    ico: ""
    bottomtxt: memUsage + "%"
    topit: DetailList {
        visible: membubble.full
        col: Theme.colBlue
        title: "Top processes"
        rows: membubble.topProcs
        footer: [{
            label: "Used / Total",
            value: membubble.memUsedGb.toFixed(1) + " / " + membubble.memTotalGb.toFixed(1) + " GiB"
        }]
    }

    Process {
        id: memProc
        // Summed by process name, so a browser's many processes count as one
        command: ["sh", "-c", `
            free | grep Mem
            [ "$1" = full ] || exit 0
            ps -eo rss=,comm= | awk '{ r = $1; $1 = ""; sub(/^ /, ""); a[$0] += r } END { for (k in a) print a[k], k }' | sort -rn | head -5
        `, "sh", membubble.full ? "full" : ""]

        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                data = data.trim()

                if (data.startsWith("Mem")) {
                    let parts = data.split(/\s+/)
                    let total = parseInt(parts[1]) || 1
                    let used = parseInt(parts[2]) || 0
                    membubble.memUsage = Math.round(100 * used / total)
                    membubble.memTotalGb = total / 1048576   // free reports KiB
                    membubble.memUsedGb = used / 1048576
                    membubble.tmpProcs = []
                } else {
                    const i = data.indexOf(" ")
                    const t = membubble.tmpProcs.concat([{
                        label: data.slice(i + 1),
                        value: membubble.fmtKib(parseInt(data.slice(0, i)))
                    }])
                    membubble.tmpProcs = t
                    membubble.topProcs = t
                }
            }
        }
        Component.onCompleted: running = true
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: memProc.running = true
    }
}

pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton { id: root
    property string ico: ""

    property int usage: 0
    property real usedGb: 0
    property real totalGb: 0
    property var topProcs: []
    property var tmpProcs: []

    function fmtKib(k) {
        return k >= 1048576 ? (k / 1048576).toFixed(1) + " GiB"
                            : Math.round(k / 1024) + " MiB"
    }

    Process {
        id: memProc
        // Summed by process name, so a browser's many processes count as one
        command: ["sh", "-c", `
            free | grep Mem
            [ "$1" = full ] || exit 0
            ps -eo rss=,comm= | awk '{ r = $1; $1 = ""; sub(/^ /, ""); a[$0] += r } END { for (k in a) print a[k], k }' | sort -rn | head -5
        `, "sh", root.full ? "full" : ""]

        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                data = data.trim()

                if (data.startsWith("Mem")) {
                    let parts = data.split(/\s+/)
                    let total = parseInt(parts[1]) || 1
                    let used = parseInt(parts[2]) || 0
                    root.usage = Math.round(100 * used / total)
                    root.totalGb = total / 1048576   // free reports KiB
                    root.usedGb = used / 1048576
                    root.tmpProcs = []
                } else {
                    const i = data.indexOf(" ")
                    const t = root.tmpProcs.concat([{
                        label: data.slice(i + 1),
                        value: root.fmtKib(parseInt(data.slice(0, i)))
                    }])
                    root.tmpProcs = t
                    root.topProcs = t
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

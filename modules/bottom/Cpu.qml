import QtQuick
import Quickshell.Io
import "../.."

BotBubble {
    id: cpububble
    col: Theme.colGreen

    property bool full: false

    property real cpuUsage: -1
    property real lastCpuTotal: 0
    property real lastCpuIdle: 0
    property string temp: ""

    // process tracking
    property var topProcs: []
    property var prevTicks: ({})  // pid -> ticks at previous cycle
    property var curTicks: ({})  // pid -> ticks this cycle
    property var agg: ({})  // process name -> ticks used since previous cycle
    property real dTotal: 0  // total cpu ticks (all cores) since previous cycle

    readonly property int maxProcs: 5

    ico: ""
    bottomtxt: (cpuUsage == -1 ? '-' : cpuUsage) + "%"
    topit: DetailList {
        visible: cpububble.full
        col: Theme.colGreen
        title: "Top processes"
        rows: cpububble.topProcs
        footer: cpububble.temp !== "" ? [{ label: "Temp", value: cpububble.temp }] : []
    }

    Process {
        id: cpuProc
        running: true
        // $1 == "full" -> also dump per-process cpu ticks (only when expanded)
        command: ["sh", "-c", `
            head -1 /proc/stat
            t=
            for h in /sys/class/hwmon/hwmon*; do
                read n < "$h/name"
                case "$n" in
                    coretemp|k10temp|zenpower|cpu_thermal) read t < "$h/temp1_input"; break ;;
                esac
            done 2>/dev/null
            [ -n "$t" ] && echo "temp $((t / 1000))"
            if [ "$1" = full ]; then
                cat /proc/[0-9]*/stat 2>/dev/null | awk '{
                    s = $0; i = index(s, "("); j = 0
                    for (k = length(s); k > i; k--) if (substr(s, k, 1) == ")") { j = k; break }
                    if (!j) next
                    split(substr(s, j + 2), f, " ")
                    print $1, f[12] + f[13], substr(s, i + 1, j - i - 1)
                }'
            fi
            echo end
        `, "sh", cpububble.full ? "full" : ""]

        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                data = data.trim()

                if (data.startsWith("cpu")) {
                    var p = data.split(/\s+/)
                    var idle = parseInt(p[4]) + parseInt(p[5])
                    var total = p.slice(1, 8).reduce((a, b) => a + parseInt(b), 0)

                    if (cpububble.lastCpuTotal > 0) {
                        cpububble.cpuUsage = Math.round(100 * (1 - (idle - cpububble.lastCpuIdle) / (total - cpububble.lastCpuTotal)))
                        cpububble.dTotal = total - cpububble.lastCpuTotal
                    } else {
                        cpububble.cpuUsage = -1
                        cpububble.dTotal = 0
                    }
                    cpububble.lastCpuTotal = total
                    cpububble.lastCpuIdle = idle

                    // new cycle
                    cpububble.curTicks = {}
                    cpububble.agg = {}
                } else if (data.startsWith("temp ")) {
                    cpububble.temp = data.slice(5) + "°C"
                } else if (data === "end") {
                    if (cpububble.full) {
                        const a = cpububble.agg, d = cpububble.dTotal
                        cpububble.topProcs = Object.keys(a)
                            .map(n => ({ label: n, pct: d > 0 ? Math.round(100 * a[n] / d) : 0 }))
                            .filter(x => x.pct > 0)
                            .sort((x, y) => y.pct - x.pct)
                            .slice(0, cpububble.maxProcs)
                            .map(x => ({ label: x.label, value: x.pct + "%" }))
                    }
                    // keep the snapshot only if we actually collected one
                    cpububble.prevTicks = cpububble.curTicks
                } else if (data.charCodeAt(0) >= 48 && data.charCodeAt(0) <= 57) {
                    // "<pid> <ticks> <name>"
                    const i = data.indexOf(" ")
                    const j = data.indexOf(" ", i + 1)
                    const pid = data.slice(0, i)
                    const ticks = parseInt(data.slice(i + 1, j))
                    const name = data.slice(j + 1)

                    cpububble.curTicks[pid] = ticks
                    const prev = cpububble.prevTicks[pid]
                    if (prev !== undefined && cpububble.dTotal > 0 && ticks >= prev)
                        cpububble.agg[name] = (cpububble.agg[name] || 0) + (ticks - prev)
                }
            }
        }
    }

    // quick second sample so the numbers appear immediately
    Timer {
        interval: 400
        running: true
        repeat: false
        onTriggered: cpuProc.running = true
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: cpuProc.running = true
    }
}

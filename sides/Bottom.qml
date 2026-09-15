import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import ".."
import "../modules/all/"
import "../modules/bottom/"

RowLayout {
    id: top
    property bool full: false
    spacing: Theme.barSpacing*2

    BotBubble {
        col: Theme.colYellow
        SystemClock {
            id: clock
            precision: SystemClock.Hours
        }
        bottomtxt: Qt.formatDateTime(clock.date, "󰸘  dd/MM/yyyy")
        topit: Text {
            visible: top.full
            text: "Hello, world!"
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            color: Theme.colYellow
        }
    }

    BotBubble {
        id: cpububble
        col: Theme.colGreen
        property real cpuUsage: -1
        property real lastCpuTotal: 0
        property real lastCpuIdle: 0

        bottomtxt: `  ${cpuUsage == -1? '-' : cpuUsage}%`
        topit: Text {
            visible: top.full
            text: "Hello, world!"
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            color: Theme.colGreen
        }

        Process {
            id: cpuProc
            running: true
            command: ["sh", "-c", "head -1 /proc/stat"]
            stdout: SplitParser {
                onRead: data => {
                    if (!data) return
                    var p = data.trim().split(/\s+/)
                    var idle = parseInt(p[4]) + parseInt(p[5])
                    var total = p.slice(1, 8).reduce((a, b) => a + parseInt(b), 0)

                    if (cpububble.lastCpuTotal > 0) {
                        cpububble.cpuUsage = Math.round(100 * (1 - (idle - cpububble.lastCpuIdle) / (total - cpububble.lastCpuTotal)))
                    } else {
                        cpububble.cpuUsage = -1
                    }
                    cpububble.lastCpuTotal = total
                    cpububble.lastCpuIdle = idle
                }
            }
            Component.onCompleted: running = true
        }

        Timer {
            interval: 2000
            running: true
            repeat: true
            onTriggered: cpuProc.running = true
        }
    }

    BotBubble {
        id: membubble
        col: Theme.colBlue
        property int memUsage: 0

        bottomtxt: `  ${memUsage}%`
        topit: Text {
            visible: top.full
            text: "Hello, world!"
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            color: Theme.colBlue
        }

        Process {
            id: memProc
            command: ["sh", "-c", "free | grep Mem"]
            stdout: SplitParser {
                onRead: data => {
                    if (!data) return
                    let parts = data.trim().split(/\s+/)
                    let total = parseInt(parts[1]) || 1
                    let used = parseInt(parts[2]) || 0
                    membubble.memUsage = Math.round(100 * used / total)
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

    BotBubble {
        id: diskbubble
        col: Theme.colPurple
        property string diskFree: "-"
        property int diskUsedPct: -1

        bottomtxt: `  ${diskFree} (${diskUsedPct == -1 ? '-' : diskUsedPct}%)`
        topit: Text {
            visible: top.full
            text: "Hello, world!"
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            color: Theme.colPurple
        }

        Process {
            id: diskProc
            command: ["sh", "-c", "df -h / | tail -1"]
            stdout: SplitParser {
                onRead: data => {
                    if (!data) return
                    let parts = data.trim().split(/\s+/)
                    diskbubble.diskFree = parts[3]
                    diskbubble.diskUsedPct = parseInt(parts[4]) || 0
                }
            }
            Component.onCompleted: running = true
        }

        Timer {
            interval: 5000
            running: true
            repeat: true
            onTriggered: diskProc.running = true
        }
    }
}

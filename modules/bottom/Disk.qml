import QtQuick
import Quickshell.Io
import "../.."

BotBubble {
    id: diskbubble
    col: Theme.colPurple

    property bool full: false

    property string diskFree: "-"
    property int diskUsedPct: -1
    property var mounts: []
    property var tmpMounts: []
    property var seenSources: ({})

    ico: ""
    bottomtxt: `${diskFree} (${diskUsedPct == -1 ? '-' : diskUsedPct}%)`
    topit: DetailList {
        visible: diskbubble.full
        col: Theme.colPurple
        title: "Used / Total"
        rows: diskbubble.mounts
        footer: [{ label: "Free (/)", value: diskbubble.diskFree }]
    }

    Process {
        id: diskProc
        command: ["sh", "-c",
            "LC_ALL=C df -h --output=source,target,size,used,avail,pcent -x tmpfs -x devtmpfs -x efivarfs -x squashfs -x overlay"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                let p = data.trim().split(/\s+/)

                if (p[0] === "Filesystem") {  // header = new cycle
                    diskbubble.tmpMounts = []
                    diskbubble.seenSources = {}
                    return
                }
                if (p.length < 6) return

                const [src, target, size, used, avail, pct] = p
                if (target === "/") {
                    diskbubble.diskFree = avail
                    diskbubble.diskUsedPct = parseInt(pct) || 0
                }
                // skip btrfs subvolumes / bind mounts of an already-listed device
                if (diskbubble.seenSources[src] || diskbubble.tmpMounts.length >= 4) return
                diskbubble.seenSources[src] = true

                const t = diskbubble.tmpMounts.concat([{ label: target, value: `${used} / ${size}` }])
                diskbubble.tmpMounts = t
                diskbubble.mounts = t
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

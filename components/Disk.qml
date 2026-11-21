pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton { id: root
    property string ico: ""

    property string free: "-"
    //! Used percentage
    property int used: -1
    property var mounts: []
    property var tmpMounts: []
    property var seenSources: ({})

    Process {
        id: diskProc
        command: ["sh", "-c",
            "LC_ALL=C df -h --output=source,target,size,used,avail,pcent -x tmpfs -x devtmpfs -x efivarfs -x squashfs -x overlay"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                let p = data.trim().split(/\s+/)

                if (p[0] === "Filesystem") {  // header = new cycle
                    root.tmpMounts = []
                    root.seenSources = {}
                    return
                }
                if (p.length < 6) return

                const [src, target, size, used, avail, pct] = p
                if (target === "/") {
                    root.free = avail
                    root.used = parseInt(pct) || 0
                }
                // skip btrfs subvolumes / bind mounts of an already-listed device
                if (root.seenSources[src] || root.tmpMounts.length >= 4) return
                root.seenSources[src] = true

                const t = root.tmpMounts.concat([{ label: target, value: `${used} / ${size}` }])
                root.tmpMounts = t
                root.mounts = t
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

pragma Singleton
import Quickshell
import Quickshell.Io
import Quickshell.Networking
import QtQuick

Singleton { id: root
    readonly property bool enabled: Networking.wifiEnabled
    function toggle() {
        Networking.wifiEnabled = !Networking.wifiEnabled
    }
    // Live state
    readonly property var device:
        Networking.devices.values.find(d => d.type === DeviceType.Wifi) ?? null
    readonly property var active:
        device ? (device.networks.values.find(n => n.connected) ?? null) : null

    readonly property bool linked: Networking.wifiEnabled && active !== null
    readonly property int strength: linked ? Math.round(active.signalStrength * 100) : 0
    readonly property string name: linked ? active.name : "-"

    // Extra details
    property string wifiText: ""
    readonly property bool scanning: wifiRescan.running

    function refreshDetails() {
        if (!wifiScan.running && !wifiRescan.running) wifiScan.running = true
    }

    function rescan() {
        if (!wifiRescan.running && Networking.wifiEnabled) wifiRescan.running = true
    }

    function applyScan(text) {
        let info = ""
        for (let line of text.trim().split("\n")) {
            // nmcli escapes literal colons as \:
            line = line.replace(/\\:/g, "§COLON§")
            const fields = line.split(":").map(f =>
                f.replace(/§COLON§/g, ":")
            )
            if (fields[0] == "*") {
                info = fields[1] + "  Ch " + fields[4] + "\nMax rate: " + fields[5] + "\nSecurity: " + fields[8]
                break
            }
        }
        wifiText = info
    }

    // Connection status changed
    onActiveChanged: {
        wifiText = ""
        if (active) refreshDetails()
    }

    property string ico: linked ? (
        strength <= 20 ? "󰤯" :
        strength <= 40 ? "󰤟" :
        strength <= 60 ? "󰤢" :
        strength <= 80 ? "󰤥" :
        "󰤨"
    ) : "󰤮"


    // Cached list
    Process {
        id: wifiScan
        command: ["nmcli", "-t", "dev", "wifi", "list", "--rescan", "no"]
        stdout: StdioCollector {
            onStreamFinished: root.applyScan(text)
        }
    }

    // Forced rescan
    Process {
        id: wifiRescan
        command: ["nmcli", "-t", "dev", "wifi", "list", "--rescan", "yes"]
        stdout: StdioCollector {
            onStreamFinished: root.applyScan(text)
        }
    }

    // Wifi toggled
    Connections {
        target: Networking
        function onWifiEnabledChanged() {
            root.wifiText = ""
            if (Networking.wifiEnabled) root.refreshDetails()
        }
    }


    Process {
        id: opencmd
        command: ["sh", "-c", "$TermSpawn nmtui"]
    }
    function open() { opencmd.running = true }
}

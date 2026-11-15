import QtQuick
import Quickshell.Networking
import Quickshell.Io
import "../.."
import "../base/"

LeftBubble {
    id: b

    col: Theme.colPurple

    // Live state
    readonly property var wifiDev:
        Networking.devices.values.find(d => d.type === DeviceType.Wifi) ?? null
    readonly property var active:
        wifiDev ? (wifiDev.networks.values.find(n => n.connected) ?? null) : null

    readonly property bool linked: Networking.wifiEnabled && active !== null
    readonly property int wStrength: linked ? Math.round(active.signalStrength * 100) : 0
    readonly property string wifiName: linked ? active.name : "-"

    // Extra details
    property string wifiText: "-"
    readonly property bool scanning: wifiRescan.running

    function refreshDetails() {
        if (!wifiScan.running && !wifiRescan.running) wifiScan.running = true
    }

    function rescan() {
        if (!wifiRescan.running && Networking.wifiEnabled) wifiRescan.running = true
    }

    function applyScan(text) {
        let info = "-"
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
        b.wifiText = info
    }

    // Connection status changed
    onActiveChanged: {
        wifiText = "-"
        if (active) refreshDetails()
    }

    item: Text {
        anchors.centerIn: parent

        text: b.linked ? (
            b.wStrength <= 20 ? "󰤯" :
            b.wStrength <= 40 ? "󰤟" :
            b.wStrength <= 60 ? "󰤢" :
            b.wStrength <= 80 ? "󰤥" :
            "󰤨"
        ) : "󰤮"
        color: b.col
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize*1.5
    }

    Popup {
        id: pop
        prioritiseHover: true
        touchdblstick: true
        onExpandChanged: if (pop.expand) b.refreshDetails()

        Column {
            id: popCol
            spacing: 4
            width: Math.max(
                wifiTitl.implicitWidth + wifiSwitch.width + 8,
                wifiInfo.implicitWidth,
                rescanLabel.implicitWidth + Theme.barRound * 2,
                settingsLabel.implicitWidth + Theme.barRound * 2
            )

            Item {
                width: parent.width
                height: Math.max(wifiTitl.implicitHeight, wifiSwitch.height)

                Text {
                    id: wifiTitl
                    anchors.left: parent.left
                    anchors.right: wifiSwitch.left
                    anchors.rightMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignHCenter
                    text: Networking.wifiEnabled ? (
                        b.wifiName + '\n' + (
                            b.linked ? b.wStrength + "% strength" : "-"
                        )
                    ) : "-\n-"
                    color: b.col
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                    font.bold: true
                }

                Toggle {
                    id: wifiSwitch
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    checked: Networking.wifiEnabled
                    accent: b.col
                    onClicked: Networking.wifiEnabled = !Networking.wifiEnabled
                }
            }

            Text {
                id: wifiInfo
                text: Networking.wifiEnabled ? b.wifiText : ""
                color: b.col
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize
            }

            // Rescan button
            Rectangle {
                width: parent.width
                height: 28
                radius: Theme.barRound
                color: Qt.rgba(b.col.r, b.col.g, b.col.b, b.scanning ? 0.3 : 0.15)

                Text {
                    id: rescanLabel
                    anchors.centerIn: parent
                    text: b.scanning ? "Scanning..." : "Rescan Wifi"
                    color: b.col
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: b.rescan()
                }
            }

            // Settings button
            Rectangle {
                width: parent.width
                height: 28
                radius: Theme.barRound
                color: Qt.rgba(b.col.r, b.col.g, b.col.b, 0.15)

                Text {
                    id: settingsLabel
                    anchors.centerIn: parent
                    text: "Wifi Settings"
                    color: b.col
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: (mouse) => {
                        click.running = true
                        pop.shutIfTouch(mouse)
                    }
                }
            }
        }
    }

    // Cached list
    Process {
        id: wifiScan
        command: ["nmcli", "-t", "dev", "wifi", "list", "--rescan", "no"]
        stdout: StdioCollector {
            onStreamFinished: b.applyScan(text)
        }
    }

    // Forced rescan
    Process {
        id: wifiRescan
        command: ["nmcli", "-t", "dev", "wifi", "list", "--rescan", "yes"]
        stdout: StdioCollector {
            onStreamFinished: b.applyScan(text)
        }
    }

    // Wifi toggled
    Connections {
        target: Networking
        function onWifiEnabledChanged() {
            b.wifiText = "-"
            if (Networking.wifiEnabled) b.refreshDetails()
        }
    }

    MousePressCmd { id: click; cmd: ["sh", "-c", "$($TermSpawn nmtui)"] }
}

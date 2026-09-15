import QtQuick
import Quickshell.Networking
import Quickshell.Io
import "../.."
import "../base/"

LeftBubble {
    id: b

    col: Theme.colPurple
    property int wStrength: 0

    item: Text {
        anchors.centerIn: parent

        text: (b.wifiText != "..." & b.wifiText != "-") ? (
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

    property string wifiText: "..."
    Popup {
        id: pop
        prioritiseHover: true
        touchdblstick: true
        Column {
            spacing: 4
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: Networking.wifiEnabled ? (
                    b.wifiText != "..." ? b.wStrength + "% strength" : "..."
                ) : "-"
                color: b.col
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize
                font.bold: true
            }
            Text {
                text: wifiText
                color: b.col
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize
            }

            // Settings button
            Rectangle {
                width: parent.width
                height: 28
                radius: Theme.barRound
                color: Qt.rgba(col.r, col.g, col.b, 0.15)

                Text {
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

    // Wifi Strength
    Process {
        id: wifiStrengthProc
        running: true
        command: ["sh", "-c", "awk 'NR == 3 {printf \"%.1f\", (substr($3, 1, length($3)-1)/70)*100; exit}' /proc/net/wireless"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                b.wStrength = parseInt(data.trim()) || 0
            }
        }
    }

    // Wifi scan
    Process {
        id: wifiScan
        running: true
        command: ["nmcli", "-t", "dev", "wifi"]

        stdout: SplitParser {
            splitMarker: "\0"
            onRead: data => {
                if (!data) return
                const lines = data.trim().split("\n")

                b.wifiText = "..."

                for (let line of lines) {
                    // nmcli escapes literal colons as \:
                    line = line.replace(/\\:/g, "§COLON§")

                    const fields = line.split(":").map(f =>
                        f.replace(/§COLON§/g, ":")
                    )

                    if (fields[0] == "*") {
                        b.wifiText = fields[2] + "\n" + fields[1] + "\n" + fields[5] + "  " + fields[7] + "\nSecurity: " + fields[8]
                        break
                    }
                }
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: {
            wifiStrengthProc.running = true
            wifiScan.running = true
        }
    }

    MousePressCmd { id: click; cmd: ["sh", "-c", "$($TermSpawn nmtui)"] }
}

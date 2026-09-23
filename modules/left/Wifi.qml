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

        text: (Networking.wifiEnabled && b.wifiText != "..." & b.wifiText != "-") ? (
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
    property string wifiName: "-"
    Popup {
        id: pop
        prioritiseHover: true
        touchdblstick: true
        Column {
            spacing: 4
            Item {
                width: Math.max(parent.width, wifiTitl.width+wifiSwitch.width)
                height: wifiTitl.height

                Text {
                    id: wifiTitl
                    anchors.left: parent.left
                    anchors.right: wifiSwitch.left
                    horizontalAlignment: Text.AlignHCenter
                    text: Networking.wifiEnabled ? (
                        b.wifiName + '\n' + (
                            b.wifiText != "..." ? b.wStrength + "% strength" : "..."
                        )
                    ) : "-\n-"
                    color: b.col
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                    font.bold: true
                }

                Rectangle {
                    id: wifiSwitch
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: Theme.fontSize*1.3
                    width: height*1.8
                    radius: height / 2
                    color: Networking.wifiEnabled ? b.col : Theme.colMuted2

                    Behavior on color { ColorAnimation { duration: 120 } }

                    Rectangle {
                        height: parent.height - 4
                        width: height
                        radius: height / 2
                        color: Theme.colFg
                        anchors.verticalCenter: parent.verticalCenter
                        x: Networking.wifiEnabled ? parent.width - width - 2 : 2
                        Behavior on x { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
                        Behavior on color { ColorAnimation { duration: 120 } }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            Networking.wifiEnabled = !Networking.wifiEnabled
                        }
                    }
                }
            }
            Text {
                text: Networking.wifiEnabled ? wifiText : ""
                color: b.col
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize
            }

            // Settings button
            Rectangle {
                width: Math.max(parent.width, children[0].width+Theme.barRound*2)
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
                        b.wifiText = fields[1] + "\n" + fields[5] + "  " + fields[7] + "\nSecurity: " + fields[8]
                        b.wifiName = fields[2]
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

import QtQuick
import QtQuick.Layouts
import Quickshell.Networking
import Quickshell.Io
import "../.."
import "../base/"

Bubble {
    id: b
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignHCenter

    col: Theme.colPurple

    property int wStrength: 0

    item: Column {
        id: main
        anchors.centerIn: parent
        Text {
            anchors { left: parent.left; right: parent.right }
            horizontalAlignment: Text.AlignHCenter

            text: Networking.wifiEnabled ? (
                b.wStrength <= 20 ? "󰤯" :
                b.wStrength <= 40 ? "󰤟" :
                b.wStrength <= 60 ? "󰤢" :
                b.wStrength <= 80 ? "󰤥" :
                "󰤨"
            ): "󰤮"
            color: b.col
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize*1.5
        }
        Text {
            horizontalAlignment: Text.AlignHCenter

            text: Networking.wifiEnabled ? b.wStrength + "%" : "n/a"

            color: b.col
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            font.bold: true
        }
    }

    Popup{}

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

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: {
            wifiStrengthProc.running = true
        }
    }
}

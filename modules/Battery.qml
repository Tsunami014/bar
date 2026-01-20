import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import ".."
import "base/"

Bubble {
    id: b
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignHCenter

    property int batteryLevel: 0
    property bool batteryCharging: false

    col: b.batteryCharging ? (
        b.batteryLevel <= 10 ? Theme.colRed :
        b.batteryLevel <= 20 ? Theme.colOrange :
        b.batteryLevel <= 35 ? Theme.colYellow :
        b.batteryLevel <= 50 ? Theme.colBlue :
        b.batteryLevel <= 65 ? Theme.colIndigo :
        b.batteryLevel <= 80 ? Theme.colPurple :
        Theme.colGreen
    ) : (
        b.batteryLevel <= 15 ? Theme.colRed :
        b.batteryLevel <= 40 ? Theme.colOrange :
        b.batteryLevel <= 60 ? Theme.colYellow :
        Theme.colGreen
    )

    Column {
        anchors.centerIn: parent
        Text {
            anchors { left: parent.left; right: parent.right }
            horizontalAlignment: Text.AlignHCenter

            text: b.batteryCharging ? (
                  b.batteryLevel <= 10 ? "󰢟" :
                  b.batteryLevel <= 20 ? "󰢜" :
                  b.batteryLevel <= 30 ? "󰂆" :
                  b.batteryLevel <= 40 ? "󰂇" :
                  b.batteryLevel <= 50 ? "󰂈" :
                  b.batteryLevel <= 60 ? "󰢝" :
                  b.batteryLevel <= 70 ? "󰂉" :
                  b.batteryLevel <= 80 ? "󰢞" :
                  b.batteryLevel <= 90 ? "󰂊" :
                  b.batteryLevel < 100 ? "󰂋" :
                  "󰂅") : (
                  b.batteryLevel <= 10 ? "󰂎" :
                  b.batteryLevel <= 20 ? "󰁺" :
                  b.batteryLevel <= 30 ? "󰁻" :
                  b.batteryLevel <= 40 ? "󰁼" :
                  b.batteryLevel <= 50 ? "󰁽" :
                  b.batteryLevel <= 60 ? "󰁾" :
                  b.batteryLevel <= 70 ? "󰁿" :
                  b.batteryLevel <= 80 ? "󰂀" :
                  b.batteryLevel <= 90 ? "󰂁" :
                  b.batteryLevel < 100 ? "󰂂" :
                  "󰁹")

            color: b.col
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize*1.8
        }
        Text {
            horizontalAlignment: Text.AlignHCenter

            text: b.batteryLevel + "%"

            color: b.col
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            font.bold: true
        }
    }

    // Battery level
    Process {
        id: batteryProc
        running: true
        command: ["sh", "-c", "cat /sys/class/power_supply/BAT*/capacity | awk '{sum+=$1; count++} END {print sum/count}'"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                b.batteryLevel = parseInt(data.trim()) || 0
            }
        }
    }

    // Battery charging status
    Process {
        id: batteryStatusProc
        running: true
        command: ["sh", "-c", "cat /sys/class/power_supply/BAT*/status | awk '{s[$1]++} END {if (s[\"Charging\"]) print \"Charging\"; else if (s[\"Discharging\"]) print \"Discharging\"; else print \"Full\"}'"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                b.batteryCharging = (data.trim() === "Charging" || data.trim() === "Full")
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: {
            batteryProc.running = true
            batteryStatusProc.running = true
        }
    }
}

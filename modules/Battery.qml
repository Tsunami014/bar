import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.UPower
import Quickshell.Io
import ".."

Text {
    id: batteryWidget
    anchors {
        verticalCenter: parent.verticalCenter
    }
    property int batteryLevel: 0
    property bool batteryCharging: false
    property bool clicked: false

    property string batteryIcon: batteryCharging ? (
          batteryLevel <= 10 ? "󰢟 " :
          batteryLevel <= 20 ? "󰢜 " :
          batteryLevel <= 30 ? "󰂆 " :
          batteryLevel <= 40 ? "󰂇 " :
          batteryLevel <= 50 ? "󰂈 " :
          batteryLevel <= 60 ? "󰢝 " :
          batteryLevel <= 70 ? "󰂉 " :
          batteryLevel <= 80 ? "󰢞 " :
          batteryLevel <= 90 ? "󰂊 " :
          batteryLevel < 100 ? "󰂋 " :
          "󰂅 ") : (
          batteryLevel <= 10 ? "󰂎 " :
          batteryLevel <= 20 ? "󰁺 " :
          batteryLevel <= 30 ? "󰁻 " :
          batteryLevel <= 40 ? "󰁼 " :
          batteryLevel <= 50 ? "󰁽 " :
          batteryLevel <= 60 ? "󰁾 " :
          batteryLevel <= 70 ? "󰁿 " :
          batteryLevel <= 80 ? "󰂀 " :
          batteryLevel <= 90 ? "󰂁 " :
          batteryLevel < 100 ? "󰂂 " :
          "󰁹 ")

    text: batteryIcon + batteryLevel + "%"
    color: batteryCharging ? (
        batteryLevel <= 15 ? Theme.colOrange : Theme.colGreen
    ) : (
        batteryLevel <= 15 ? Theme.colRed : Theme.colGreen
    )

    MouseArea {
        anchors.fill: parent
        onClicked: batteryWidget.clicked = !batteryWidget.clicked
    }

    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSize
    font.bold: true
    Component.onCompleted: {
        parent.width = batteryWidget.contentWidth
    }

    // Battery level
    Process {
        id: batteryProc
        command: ["sh", "-c", "cat /sys/class/power_supply/BAT*/capacity | awk '{sum+=$1; count++} END {print sum/count}'"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                batteryWidget.batteryLevel = parseInt(data.trim()) || 0
            }
        }
        Component.onCompleted: running = true
    }

    // Battery charging status
    Process {
        id: batteryStatusProc
        command: ["sh", "-c", "cat /sys/class/power_supply/BAT*/status | awk '{s[$1]++} END {if (s[\"Charging\"]) print \"Charging\"; else if (s[\"Discharging\"]) print \"Discharging\"; else print \"Full\"}'"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                batteryWidget.batteryCharging = (data.trim() === "Charging" || data.trim() === "Full")
            }
        }
        Component.onCompleted: running = true
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

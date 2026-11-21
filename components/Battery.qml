pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import ".."

Singleton { id: root
    property int batteryLevel: 0
    //! Charge status, e.g. "Full"
    property string batChargeStatus: "?"
    //! Extra text, e.g. how long until charged
    property string batteryExtra: ""
    property bool batteryCharging: false

    property color col: batteryCharging ? (
        batteryLevel <= 10 ? Theme.colRed :
        batteryLevel <= 20 ? Theme.colOrange :
        batteryLevel <= 35 ? Theme.colYellow :
        batteryLevel <= 50 ? Theme.colIndigo :
        batteryLevel <= 60 ? Theme.colPurple :
        Theme.colGreen
    ) : (
        batteryLevel <= 15 ? Theme.colRed :
        batteryLevel <= 40 ? Theme.colOrange :
        batteryLevel <= 60 ? Theme.colYellow :
        Theme.colGreen
    )

    property string ico: batteryCharging ? (
          batteryLevel <= 10 ? "󰢟" :
          batteryLevel <= 20 ? "󰢜" :
          batteryLevel <= 30 ? "󰂆" :
          batteryLevel <= 40 ? "󰂇" :
          batteryLevel <= 50 ? "󰂈" :
          batteryLevel <= 60 ? "󰢝" :
          batteryLevel <= 70 ? "󰂉" :
          batteryLevel <= 80 ? "󰢞" :
          batteryLevel <= 90 ? "󰂊" :
          batteryLevel < 100 ? "󰂋" :
          "󰂅") : (
          batteryLevel <= 10 ? "󰂎" :
          batteryLevel <= 20 ? "󰁺" :
          batteryLevel <= 30 ? "󰁻" :
          batteryLevel <= 40 ? "󰁼" :
          batteryLevel <= 50 ? "󰁽" :
          batteryLevel <= 60 ? "󰁾" :
          batteryLevel <= 70 ? "󰁿" :
          batteryLevel <= 80 ? "󰂀" :
          batteryLevel <= 90 ? "󰂁" :
          batteryLevel < 100 ? "󰂂" :
          "󰁹")

    // Battery level
    Process {
        id: batteryProc
        running: true
        command: ["sh", "-c", "cat /sys/class/power_supply/BAT*/capacity | awk '{sum+=$1; count++} END {print sum/count}'"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                root.batteryLevel = parseInt(data.trim()) || 0
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
                root.batChargeStatus = data.trim()
                root.batteryCharging = (root.batChargeStatus === "Charging" || root.batChargeStatus === "Full")
            }
        }
    }

    // Time left
    Process {
        id: batteryTLProc
        running: true
        command: ["sh", "-c", "acpi -b | grep 'charg' -m 1 | grep -P -o '(?<=%, ).+'"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                root.batteryExtra = data.trim()
            }
        }
    }

    // Refresh
    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: {
            batteryProc.running = true
            batteryStatusProc.running = true
            batteryTLProc.running = true
        }
    }
}

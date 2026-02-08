import QtQuick
import QtQuick.Layouts
import ".."
import "../modules/top/"

Rectangle {
    // left
    RowLayout {
        anchors {
            left: parent.left
            leftMargin: Theme.barSpacing
            top: parent.top
            bottom: parent.bottom
        }
        spacing: Theme.barSpacing
        TopExec {
            text: "󰌌"
            col1: Theme.colIndigo
            col2: proc.running ? Theme.colPurple : Theme.colBlue
            cmd: ["sh", "-c", "pgrep wvkbd-mobintl >/dev/null || wvkbd-mobintl"]
        }
        TopExec {
            text: ""
            col1: proc.running ? Theme.colOrange : Theme.colBlue
            col2: Theme.colGreen
            cmd: ["sh", "-c", 'pid=$(pidof swayidle); kill -STOP -$pid; trap "kill -CONT -$pid" EXIT; sleep infinity']
        }
    }
    // center
    RowLayout {
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }

        Text {
            text: niri.focusedWindow?.title ?? ""
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            color: Theme.colFg
        }
    }
}

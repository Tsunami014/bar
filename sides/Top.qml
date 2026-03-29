import QtQuick
import QtQuick.Layouts
import ".."
import "../modules/top/"

Rectangle {
    property string exitproc: "kill -CONT $(pidof swayidle)"
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
        TopExecTog {
            text: ""
            col1: proc.run ? Theme.colOrange : Theme.colBlue
            col2: Theme.colGreen
            cmd: ["sh", "-c", "kill -STOP $(pidof swayidle)"]
            stopcmd: ["sh", "-c", "kill -CONT $(pidof swayidle)"]
        }
    }
    // center
    RowLayout {
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
            top: parent.top
            bottom: parent.bottom
            topMargin: 3
            bottomMargin: 3
        }
        spacing: Theme.barSpacing*2

        TopExec {
            text: ""
            col1: Theme.colBlue
            col2: Theme.colFg
            cmd: ["niri", "msg", "action", "focus-column-or-monitor-left"]
        }
        Text {
            text: niri.focusedWindow?.title ?? ""
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            color: Theme.colFg
        }
        TopExec {
            text: ""
            col1: Theme.colOrange
            col2: Theme.colIndigo
            cmd: ["niri", "msg", "action", "focus-column-or-monitor-right"]
        }
    }
    // right
    RowLayout {
        anchors {
            right: parent.right
            rightMargin: Theme.barSpacing
            top: parent.top
            bottom: parent.bottom
        }
        spacing: Theme.barSpacing
        KeyPress {
            text: ""
            col1: Theme.colYellow
            col2: Theme.colRed
            key: "Backspace"
        }
    }
}

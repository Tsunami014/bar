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
        }

        Text {
            text: niri.focusedWindow?.title ?? ""
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            color: Theme.colFg
        }
    }
}

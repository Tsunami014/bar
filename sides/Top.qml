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
        Lock {
            text: running ? "" : ""
            col: running ? Theme.colYellow : Theme.colPurple
        }
        TopExecTog {
            text: proc.run ? "󰛐" : ""
            col: proc.run ? Theme.colGreen : Theme.colOrange
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
            col: Theme.colIndigo
            cmd: ["niri", "msg", "action", "focus-column-or-monitor-left"]
        }
        Text {
            property string title: niri.focusedWindow?.title ?? ""
            property int mxlen: 55
            text: title.length > mxlen
                ? title.substring(0, mxlen) + "…"
                : title
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            color: Theme.colFg
        }
        TopExec {
            text: ""
            col: Theme.colBlue
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
        TopExec {
            text: proc.running ? "󰆡" : "󰢆"
            col: proc.running ? Theme.colYellow : Theme.colGreen
            cmd: ["sh", "-c", `touch /tmp/"NOAUTOROTATE-$USER" && trap "rm \\"/tmp/NOAUTOROTATE-$USER\\"" EXIT && sleep infinity`]
        }
        TopExec {
            text: "󰌌"
            col: proc.running ? Theme.colFg : Theme.colBlue
            cmd: ["sh", "-c", "pgrep wvkbd-mobintl >/dev/null || wvkbd-mobintl --bg 000000C0 -H 350 -L 200"]
        }
        TopExec {
            text: "󰓾"
            col: proc.running ? Theme.colOrange : Theme.colYellow
            cmd: ["sh", "-c", "qs -p ~/.config/quickshell/bar/touchdebug"]
        }
    }
}

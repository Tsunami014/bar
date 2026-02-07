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
            col2: Theme.colBlue
            cmd: ["sh", "-c", "pgrep wvkbd-mobintl >/dev/null || wvkbd-mobintl"]
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

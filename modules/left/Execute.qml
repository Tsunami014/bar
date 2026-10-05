import QtQuick
import Quickshell.Io
import "../base"

FancyBubble {
    property list<string> cmd: []
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        Process {
            id: click
            command: cmd
            Component.onDestruction: {
                if (running) running = false
            }
        }
        onClicked: click.running = true
    }
    property Process proc: click
}

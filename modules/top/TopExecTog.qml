import QtQuick
import Quickshell.Io

TopExecBase {
    property list<string> cmd: []
    property list<string> stopcmd: []
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        Process {
            id: click
            property bool run: false
            running: false
            command: run ? cmd : stopcmd
            Component.onDestruction: {
                if (running) running = false
            }
        }
        onClicked: {
            click.run = !click.run
            click.running = !click.running
        }
    }
    property Process proc: click
}

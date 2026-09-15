import QtQuick
import Quickshell.Io

MouseArea {
    property list<string> cmd: []

    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    propagateComposedEvents: true
    Process {
        id: click
        running: false
        command: cmd
    }
    property alias running: click.running
    onPressed: (mouse) => {
        if (mouse.source === Qt.MouseEventNotSynthesized) {
            click.running = true
        } else {
            mouse.accepted = false
        }
    }
}

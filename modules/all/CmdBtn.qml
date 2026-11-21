import QtQuick
import Quickshell.Io
import "../.."

Button {
    property list<string> cmd: []
    property alias run: click.running
    property color runcol: Theme.colRed
    col: run ? runcol : Theme.colFg
    radius: Theme.smallRadius
    txtSize: 1.5

    Process {
        id: click
        running: false
        command: cmd
        Component.onDestruction: {
            if (running) running = false
        }
    }
    onPressed: {
        click.running = !click.running
    }
}

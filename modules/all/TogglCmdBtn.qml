import QtQuick
import Quickshell.Io
import "../.."

Button {
    property list<string> cmd: []
    property list<string> stopcmd: []
    property alias run: click.run
    property color runcol: Theme.colRed
    col: run ? runcol : Theme.colFg
    radius: Theme.smallRadius
    txtSize: 1.5

    Process {
        id: click
        property bool run: false
        running: false
        command: run ? cmd : stopcmd
        Component.onDestruction: {
            if (running) running = false
        }
    }
    onPressed: {
        click.run = !click.run
        click.running = !click.running
    }
}

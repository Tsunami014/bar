import QtQuick
import Quickshell.Io
import ".."
import "base"

CmdBtnBase {
    property list<string> cmd: []
    property list<string> stopcmd: []
    run: click.run

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

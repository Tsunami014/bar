import QtQuick
import Quickshell.Io
import ".."
import "base"

CmdBtnBase {
    property list<string> cmd: []
    run: click.running

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

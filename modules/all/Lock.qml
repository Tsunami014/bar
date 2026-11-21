import QtQuick
import Quickshell.Io
import "../.."

Button {
    property color runcol: Theme.colRed
    col: run ? runcol : Theme.colFg
    radius: Theme.smallRadius
    txtSize: 1.5

    Component.onDestruction: {
        if (Theme.expandLock) Theme.expandLock = false
    }
    property bool run: Theme.expandLock
    onPressed: {
        Theme.expandLock = !Theme.expandLock
    }
}

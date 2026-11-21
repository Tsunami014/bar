import QtQuick
import ".."
import "base"

CmdBtnBase {
    run: Theme.expandLock
    Component.onDestruction: {
        if (Theme.expandLock) Theme.expandLock = false
    }
    onPressed: {
        Theme.expandLock = !Theme.expandLock
    }
}

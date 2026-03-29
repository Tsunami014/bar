import QtQuick
import Quickshell.Io
import "../.."

TopExecBase {
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            Theme.expandLock = !Theme.expandLock
        }
        Component.onDestruction: {
            if (Theme.expandLock) Theme.expandLock = false
        }
    }
    property bool running: Theme.expandLock
}

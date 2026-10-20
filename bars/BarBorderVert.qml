import QtQuick
import Quickshell
import ".."

PanelWindow {
    anchors {
        top: true; bottom: true
    }
    margins {
        top: Theme.barRound
        bottom: Theme.barRound
    }
    exclusiveZone: 0
    implicitWidth: Theme.barBorder

    color: Theme.colBorder
}

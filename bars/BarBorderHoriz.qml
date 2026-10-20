import QtQuick
import Quickshell
import ".."

PanelWindow {
    anchors {
        left: true; right: true
    }
    margins {
        left: Theme.barRound
        right: Theme.barRound
    }
    exclusiveZone: 0
    implicitHeight: Theme.barBorder
    color: Theme.colBorder
}

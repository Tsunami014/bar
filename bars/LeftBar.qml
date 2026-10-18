import QtQuick
import Quickshell
import ".."
import "../sides/"

PanelWindow {
    id: bar
    anchors {
        top: true
        bottom: true
        left: true
    }

    exclusiveZone: Theme.leftBarWidth
    implicitWidth: exclusiveZone

    color: Theme.colBg
    Left{
        anchors.fill: parent
        anchors.leftMargin:  Theme.barPadding
        anchors.rightMargin: Theme.barPadding
        anchors.topMargin:    Theme.barBaseSze*1.5
        anchors.bottomMargin: Theme.barBaseSze*1.5
        color: Theme.colBg
    }
}

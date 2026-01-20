import QtQuick
import Quickshell
import "./sides/"

PanelWindow {
    id: bar
    anchors {
        top: true
        bottom: true
        left: true
    }

    exclusiveZone: Theme.barSze*1.5
    implicitWidth: exclusiveZone

    color: Theme.colBg
    Left{
        anchors.fill: parent
        anchors.leftMargin:  Theme.barPadding
        anchors.rightMargin: Theme.barPadding
        anchors.topMargin:    Theme.barBaseSze*2
        anchors.bottomMargin: Theme.barBaseSze*2
        color: Theme.colBg
    }
}

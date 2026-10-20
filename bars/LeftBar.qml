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

    Binding { target: Theme; property: "dpr"; value: bar.devicePixelRatio }

    color: Theme.colBg
    Left{
        anchors.fill: parent
        anchors.leftMargin:  Theme.barPadding
        anchors.rightMargin: Theme.barPadding
        anchors.topMargin:    Theme.snap(Theme.barBaseSze*1.5)
        anchors.bottomMargin: Theme.snap(Theme.barBaseSze*1.5)
        color: Theme.colBg
    }
}

import QtQuick
import Quickshell
import "../modules/base"
import ".."

PanelWindow {
    id: pw
    property int rx: 0
    property int ry: 0

    color: Theme.colTransparent

    implicitWidth: Theme.barRound
    implicitHeight: Theme.barRound 

    Corner {
        id: corn
        anchors.fill: parent
        rx: pw.rx
        ry: pw.ry
    }
}

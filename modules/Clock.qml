import QtQuick
import QtQuick.Layouts
import Quickshell
import ".."
import "base/"

Bubble {
    id: b
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignHCenter

    col: Theme.colBlue

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    item: Text {
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter

        text: Qt.formatDateTime(clock.date, " \nhh\nmm")
        color: b.col
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize*1.5
    }
}

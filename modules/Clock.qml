import QtQuick
import QtQuick.Layouts
import Quickshell
import ".."
import "base/"

Bubble {
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignHCenter

    col: Theme.colBlue

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
    Text {
        id: timeBlock
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter

        text: Qt.formatDateTime(clock.date, " \nhh\nmm")
        color: Theme.colBlue
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize*1.5
        Component.onCompleted: {
            parent.width = timeBlock.contentWidth
        }
    }
}

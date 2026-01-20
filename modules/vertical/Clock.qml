import QtQuick
import QtQuick.Layouts
import Quickshell
import "../.."
import "../base/"

Bubble {
    id: b
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignHCenter

    col: Theme.colBlue

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    Popup {
        Text {
            text: Qt.formatDateTime(clock.date, "h:mm:ss AP\nd MMM yyyy\ndd/MM/yy")
            color: b.col
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            font.bold: true
        }
    }

    item: Text {
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter

        text: Qt.formatDateTime(clock.date, " \nhh\nmm")
        color: b.col
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize*1.3
        font.bold: true
    }
}

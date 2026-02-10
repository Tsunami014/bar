import QtQuick
import Quickshell
import "../.."
import "../base/"

LeftBubble {
    id: b

    col: Theme.colOrange

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    Popup {
        Text {
            text: Qt.formatDateTime(clock.date, "h:mm:ss AP\nddd d MMM yyyy\ndd/MM/yy\nt")
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

import QtQuick
import QtQuick.Layouts
import Quickshell
import ".."

Rectangle {
    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
    Text {
        id: timeBlock
        anchors {
            verticalCenter: parent.verticalCenter
        }
        text: Qt.formatDateTime(clock.date, "hh:mm dd MMM, yyyy")
        color: Theme.colMuted1
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
        Component.onCompleted: {
            parent.width = timeBlock.contentWidth
        }
    }
}

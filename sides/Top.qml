import QtQuick
import QtQuick.Layouts
import ".."

Rectangle {
    // left
    RowLayout {
        anchors {
            left: parent.left
            leftMargin: Theme.barSze
        }
    }
    // center
    RowLayout {
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }

        Text {
            text: niri.focusedWindow?.title ?? ""
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            color: Theme.colFg
        }
    }
}

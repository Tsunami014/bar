import QtQuick
import QtQuick.Layouts
import ".."
import "../modules/"

Rectangle {
    // left
    RowLayout {
        anchors {
            left: parent.left
            leftMargin: Theme.barSze
        }
        Loader { active: true; sourceComponent: Workspaces {} }
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

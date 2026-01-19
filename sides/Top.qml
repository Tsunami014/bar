import QtQuick
import QtQuick.Layouts
import ".."
import "../modules/"

Rectangle {
    anchors.fill: parent
    color: Theme.colBg

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
    // right
    RowLayout {
        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: Theme.barSze
        }
        spacing: 10
        Loader { active: true; sourceComponent: Battery {} }
        Loader { active: true; sourceComponent: Time {} }
    }
}

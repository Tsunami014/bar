import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import "../.."
import "../base/"

ColumnLayout {
    id: lay
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignHCenter

    Repeater {
        model: SystemTray.items

        LeftBubble {
            id: b
            col: modelData.status == Status.NeedsAttention ? Theme.colRed :
                modelData.status == Status.Active ? Theme.colFg : Theme.colMuted2
            item: Image {
                anchors { left: parent.left; right: parent.right }
                source: modelData.icon
                fillMode: Image.PreserveAspectFit
            }
            Loader {
                id: menuLoader
                anchors.fill: parent
                active: modelData.hasMenu
                sourceComponent: TrayPop {}
            }
            MouseOverlay {
                anchors.fill: parent
                area: menuLoader.item
                acceptedButtons: Qt.RightButton
                cursorShape: Qt.PointingHandCursor
                onPressed: modelData.activate()
                onWheel: wheel => modelData.scroll(wheel.angleDelta.y, false)
            }
        }
    }
}

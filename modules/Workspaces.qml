import QtQuick
import QtQuick.Layouts
import Quickshell
import ".."

Rectangle {
    id: wrect
    property int padding: 2
    property int amnt: 10
    property int mainHei: Theme.barSze - 7
    property int dotSze: mainHei - padding*2
    property int dotRound: dotSze/9*4
    property int mainRound: dotSze/3*2

    anchors.left: parent.left
    color: Theme.colMuted2
    height: mainHei
    width: mainRound*2 + (dotSze + padding*2) * amnt
    bottomLeftRadius: mainRound
    bottomRightRadius: mainRound

    Rectangle {
        id: workspaceLayout
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            right: parent.right
            leftMargin: mainRound
            rightMargin: mainRound
        }

        RowLayout {
            anchors {
                verticalCenter: parent.verticalCenter
            }
            spacing: padding

            Repeater {
                model: niri.workspaces

                Rectangle {
                    visible: index < amnt+1
                    width: dotSze
                    height: dotSze
                    radius: dotRound
                    color: model.isActive ? Theme.colFg : Theme.colMuted1
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: niri.focusWorkspaceById(model.id)
                    }
                }
            }
        }
    }
}

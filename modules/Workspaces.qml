import QtQuick
import QtQuick.Layouts
import Quickshell
import ".."

Rectangle {
    id: wrect
    property int padding: 4
    property int margin: 6
    property int dotSze: Theme.fontSize*1.5
    property double activeScale: 1.5
    property double round: 4/9

    color: Theme.colMuted2
    height: (
        (dotSze + padding) * (niri.workspaces.count - 1) +
        dotSze * activeScale +
        margin * 2
    )
    width: dotSze+margin*2
    radius: width*round

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: wrect.margin
        spacing: padding

        Repeater {
            model: niri.workspaces

            Rectangle {
                width: wrect.dotSze
                height: model.isActive ? width*wrect.activeScale : width
                Layout.preferredHeight: height
                radius: wrect.dotSze*wrect.round
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

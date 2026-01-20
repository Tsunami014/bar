import QtQuick
import QtQuick.Layouts
import Quickshell
import ".."

Rectangle {
    id: wrect
    Layout.alignment: Qt.AlignHCenter
    property int padding: 4
    property int margin: 8 + Theme.borderWidth
    property int dotSze: Theme.fontSize*1.2
    property double activeScale: 1.3
    property double round: 4/9

    color: Theme.colMuted2
    border.color: Qt.lighter(color, 1.5)
    border.width: Theme.borderWidth
    implicitHeight: (
        (dotSze + padding) * (niri.workspaces.count - 1) +
        dotSze * activeScale +
        margin * 2
    )
    width: dotSze+margin*2
    radius: Theme.borderRadius

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

import QtQuick
import QtQuick.Layouts
import Quickshell
import "../.."

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
    implicitHeight: childrenRect.height + margin*2
    width: dotSze+margin*2
    radius: Theme.borderRadius

    property var palette: [
        Theme.colRed, Theme.colOrange, Theme.colYellow,
        Theme.colGreen, Theme.colBlue, Theme.colIndigo,
        Theme.colPurple,
        Theme.colFg, Theme.colMuted1
    ]
    Component.onCompleted: {
        palette.sort(function() { return Math.random() - 0.5 })
    }

    function colourForId(id, lighten) {
        return Qt.lighter(palette[id % palette.length], lighten)
    }

    ColumnLayout {
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            margins: wrect.margin
        }
        spacing: padding

        Repeater {
            model: niri.workspaces

            Rectangle {
                visible: (niri.workspaces.count == 1) || (model.index > 1 && model.index < niri.workspaces.count)
                width: wrect.dotSze
                height: model.isActive ? width*wrect.activeScale : width
                Layout.preferredHeight: height
                radius: wrect.dotSze*wrect.round
                color: colourForId(model.id, model.isActive ? 1.4 : 1.3)
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: niri.focusWorkspaceById(model.id)
                }
            }
        }
    }
}

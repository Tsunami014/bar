import QtQuick
import QtQuick.Layouts
import Quickshell
import "../.."

Rectangle {
    id: wrect
    Layout.fillWidth: true
    property int dotSze: Theme.fontSize*1.25
    property int smlDotSze: Theme.fontSize*0.9

    color: Qt.darker(Theme.colMuted2, 1.3)
    border.color: Qt.darker(Theme.colMuted1, 1.5)
    border.width: Theme.borderWidth
    property int xtraY: (lay.width-dotSze)/2
    implicitHeight: lay.height + xtraY*2
    radius: width/2

    property var palette: [
        Theme.colRed, Theme.colOrange, Theme.colYellow,
        Theme.colGreen, Theme.colBlue, Theme.colIndigo,
        Theme.colPurple,
        Theme.colFg, Theme.colMuted1
    ]

    function colourForId(id, lighten) {
        return Qt.lighter(palette[id % palette.length], lighten)
    }

    ColumnLayout {
        id: lay
        width: parent.width
        y: wrect.xtraY
        spacing: 4

        Repeater {
            model: niri.workspaces

            Rectangle {
                id: dot
                visible: (niri.workspaces.count == 1) || (model.index > 1 && model.index < niri.workspaces.count)

                Layout.preferredWidth: model.isActive ? wrect.dotSze : wrect.smlDotSze
                Layout.preferredHeight: Layout.preferredWidth
                Layout.alignment: Qt.AlignHCenter

                radius: Layout.preferredWidth / 2
                color: wrect.colourForId(model.index, model.isActive ? 1.4 : 1.3)

                Behavior on Layout.preferredWidth {
                    NumberAnimation { duration: 120; easing.type: Easing.OutCubic }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: niri.focusWorkspaceById(model.id)
                }
            }
        }
    }
}

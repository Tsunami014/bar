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

    readonly property var palettePool: [
        [ // Reverse Rainbow
            Theme.colPurple, Theme.colIndigo, Theme.colBlue,
            Theme.colGreen, Theme.colYellow, Theme.colOrange, Theme.colRed,
        ],
        [ // Faster Rainbow
            Theme.colRed, Theme.colYellow, Theme.colGreen,
            Theme.colBlue, Theme.colPurple, Theme.colFg,
        ],
        [ // Cool tones
            Theme.colBlue, Theme.colIndigo, Theme.colMuted1,
            Theme.colPurple, Theme.colFg,
        ],
        [ // Warm tones
            Theme.colRed, Theme.colOrange, Theme.colYellow,
            Theme.colGreen, Theme.colYellow, Theme.colOrange,
        ],
        [
            "#8ac5e6", "#b58ae6", "#e78bc5", "#e9ebf5",
            "#e78bc5", "#b58ae6",
        ],
    ]
    property int paletteIndex: Math.floor(Math.random() * palettePool.length)
    property var palette: palettePool[paletteIndex]

    Timer {
        interval: 15 * 60 * 1000 // 15 minutes
        running: true
        repeat: true
        onTriggered: {
            // Pick a random palette from the pool
            wrect.paletteIndex = Math.floor(Math.random() * wrect.palettePool.length);
        }
    }

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
                color: wrect.colourForId(model.index-2, model.isActive ? 1.1 : 1.3)

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

import QtQuick
import QtQuick.Layouts
import Quickshell
import "../.."
import "../base/"

Bubble { id: wrect
    Layout.fillWidth: true
    property int dotSze: Theme.fontSize*1.25
    property int smlDotSze: Theme.fontSize*0.9
    property int vPad: 3

    type: Theme.BublDarkBordr
    col: Theme.colSecondary
    padding: 3
    radius: width*0.45
    implicitHeight: lay.implicitHeight + fullBordr*2 + vPad*2

    readonly property var palettePool: [
        [ // Reverse Rainbow
            Theme.colPurple, Theme.colIndigo, Theme.colBlue,
            Theme.colGreen, Theme.colYellow, Theme.colOrange, Theme.colRed,
        ],
        [ // Ocean
            Theme.colIndigo, Theme.colBlue, Qt.lighter(Theme.colBlue, 1.25),
            Theme.colGreen, Theme.colBlue, Theme.colIndigo,
        ],
        [ // Sunset
            Theme.colYellow, Theme.colOrange, Theme.colRed,
            Theme.colPurple, Theme.colRed, Theme.colOrange,
        ],
        [ // Forest
            Qt.darker(Theme.colGreen, 1.35), Theme.colGreen, Qt.lighter(Theme.colGreen, 1.2),
            Theme.colYellow, Theme.colOrange, Theme.colGreen,
        ],
        [ // "Fun pastels"
            "#8ac5e6", "#b58ae6", "#e78bc5", "#e9ebf5", "#e78bc5", "#b58ae6",
        ],
    ]
    property int paletteIndex: Math.floor(Math.random() * palettePool.length)
    property var palette: palettePool[paletteIndex]

    Timer {
        interval: 15 * 60 * 1000 // 15 minutes
        running: true
        repeat: true
        onTriggered: {
            let n = Math.floor(Math.random() * (wrect.palettePool.length - 1))
            wrect.paletteIndex = n >= wrect.paletteIndex ? n + 1 : n
        }
    }

    function colourForId(id, lighten) {
        return Qt.lighter(palette[(id >= 0? id : 0) % palette.length], lighten)
    }

    item: ColumnLayout {
        id: lay
        anchors.centerIn: parent
        spacing: 5

        Repeater {
            model: niri.workspaces

            Bubble { id: dot
                visible: (niri.workspaces.count == 1) || (model.index > 1 && model.index < niri.workspaces.count)

                Layout.preferredWidth: model.isActive ? wrect.dotSze : wrect.smlDotSze
                Layout.preferredHeight: Layout.preferredWidth
                Layout.alignment: Qt.AlignHCenter

                type: model.isActive? Theme.BublFill : Theme.BublFlat
                padding: 0
                shadowDrop: model.isActive ? 2 : 1
                radius: width / 2
                col: wrect.colourForId(model.index-2, model.isActive ? 1.1 : 1.2)

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

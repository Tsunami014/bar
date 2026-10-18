import QtQuick
import Quickshell.Io
import "../base"
import "../.."

Rectangle {
    id: b

    property list<string> cmd: []
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        Process {
            id: click
            command: cmd
            Component.onDestruction: {
                if (running) running = false
            }
        }
        onClicked: click.running = true
    }
    property Process proc: click


    property color col1: Theme.colRed
    property color col2: Theme.colYellow

    readonly property color midCol: Qt.rgba(
        (col1.r + col2.r) / 2,
        (col1.g + col2.g) / 2,
        (col1.b + col2.b) / 2,
        (col1.a + col2.a) / 2
    )

    property real rad: Theme.borderRadius
    radius: rad

    border.width: Theme.borderWidth
    border.color: Qt.darker(midCol, Theme.lighten)

    gradient: Gradient {
        GradientStop { position: 0.0; color: b.col1 }
        GradientStop { position: 1.0; color: b.col2 }
    }
}

import QtQuick
import Quickshell.Io
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
        }
        onClicked: click.running = true
    }
    property Process proc: click

    property color col1: Theme.colRed
    property color col2: Theme.colYellow

    property real rad: Theme.borderRadius
    radius: rad
    gradient: Gradient {
        GradientStop { position: 1.0; color: Qt.lighter(b.col1, 1.2) }
        GradientStop { position: 0.0; color: Qt.lighter(b.col2, 1.2) }
    }
    Rectangle {
        radius: rad-Theme.borderWidth
        anchors.fill: parent
        anchors.margins: Theme.borderWidth
        gradient: Gradient {
            GradientStop { position: 0.0; color: b.col1 }
            GradientStop { position: 1.0; color: b.col2 }
        }
    }
}

import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../base/"
import "../.."

Rectangle {
    id: f
    property color col: "#FFF"
    radius: Theme.borderRadius

    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.alignment: Qt.AlignHCenter

    color: Qt.rgba(
        col.r+0.3,
        col.g+0.3,
        col.b+0.3,
        0.05
    )

    property string text: ""
    Text {
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        text: f.text
        color: f.col
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize*1.2
        font.bold: true
    }

    property list<string> cmd: []
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        Process {
            id: click
            running: false
            command: cmd
            Component.onDestruction: {
                if (running) running = false
            }
        }
        onClicked: {
            click.running = !click.running
        }
    }
    property Process proc: click
}

import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../base"
import "../.."

FancyBubble {
    id: b
    Layout.fillHeight: true
    implicitWidth: parent.height*1.5
    rad: Theme.borderRadius/2

    property list<string> cmd: []
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        Process {
            id: click
            property bool run: false
            running: run
            command: cmd
            Component.onDestruction: {
                if (running) running = false
            }
        }
        onClicked: click.run = !click.run
    }
    property Process proc: click

    property color textColour: "#FFF"
    property string text: ""
    Text {
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        text: b.text
        color: b.textColour
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize*1.5
        font.bold: true
    }
}

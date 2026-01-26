import QtQuick
import QtQuick.Controls
import Quickshell.Io
import "../.."
Slider {
    id: slider
    property color col: "#FFF"
    property color fillcol: "#FFF"
    property color handlecol: "#FFF"

    property bool ready: false
    property Process initial: null
    property Process change: null

    property string text: ""

    from: 0
    to: 100
    Component.onCompleted: {
        if (initial) initial.running = true
    }
    onValueChanged: {
        if (ready && change) change.running = true
    }

    anchors.fill: parent
    background: Rectangle {
        id: bg
        border.color: Qt.darker(slider.col, 1.2)
        border.width: Theme.borderWidth
        color: Qt.lighter(slider.col, 1.2)
        radius: Theme.barRound*2

        Rectangle {
            width: bg.width
            height: bg.height * slider.position
            anchors.bottom: parent.bottom
            color: Theme.colTransparent
            clip: true
            Rectangle {
                // filled portion
                width: bg.width
                height: bg.height
                anchors.bottom: parent.bottom
                radius: bg.radius
                color: Qt.lighter(slider.fillcol, 1.2)
                border.color: Qt.darker(slider.fillcol, 1.2)
                border.width: Theme.borderWidth
            }
        }
    }

    handle: Rectangle {
        width: parent.width
        radius: Theme.barRound*2
        height: radius*2
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Math.min(Math.max(
            parent.height * slider.position - height/2,
        0), parent.height - height)
        color: Qt.lighter(slider.handlecol, 1.2)
        border.color: Qt.darker(slider.handlecol, 1.2)
        border.width: Theme.borderWidth
        Text {
            text: slider.text
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            color: Qt.darker(slider.handlecol, 1.6)
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            font.bold: true
        }
    }
}

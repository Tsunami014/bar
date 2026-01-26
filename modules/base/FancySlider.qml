import QtQuick
import QtQuick.Controls
import "../.."
Slider {
    id: slider
    property color col: "#FFF"
    property color fillcol: "#FFF"
    property color handlecol: fillcol
    anchors.fill: parent
    background: Rectangle {
        id: bg
        border.color: Qt.darker(col, 1.2)
        border.width: Theme.borderWidth
        color: Qt.lighter(col, 1.2)
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
                color: Qt.lighter(fillcol, 1.2)
                border.color: Qt.darker(fillcol, 1.2)
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
        color: Qt.lighter(handlecol, 1.2)
        border.color: Qt.darker(handlecol, 1.2)
        border.width: Theme.borderWidth
    }
}

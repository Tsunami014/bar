import QtQuick
import "../.."
import "../base/"

LeftBubble {
    id: b
    col: Theme.colPalette

    item: Text {
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter

        text: Theme.paletteName
        color: b.col
        font.family: Theme.fontFamily
        font.pixelSize: Math.round(Theme.fontSize * 0.6)
        font.bold: true
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor
        onClicked: mouse => {
            if (mouse.button === Qt.RightButton) Theme.resetPalette()
            else Theme.nextPalette()
        }
    }
}

import QtQuick

MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: undefined
    property MOBase area: null
    onEntered: if (area) area.enter()
    onExited: if (area) area.exit()
    onPressed: mouse => mouse.accepted = false
    onReleased: mouse => mouse.accepted = false
    onPositionChanged: mouse => mouse.accepted = false
}

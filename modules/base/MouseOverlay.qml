import QtQuick

MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: undefined
    property MOBase area: null
    onEntered: area.enter()
    onExited: area.exit()
    onPressed: mouse => mouse.accepted = false
    onReleased: mouse => mouse.accepted = false
    onPositionChanged: mouse => mouse.accepted = false
}

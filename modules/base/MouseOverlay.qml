import QtQuick

MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: undefined
    property MOBase area: null
    onEntered: {
        area.expandCounts += 1
        if (area.collapseTimer.running) area.collapseTimer.stop()
    }
    onExited: {
        area.expandCounts -= 1
        if (area.expandCounts <= 0) {
            area.collapseTimer.start()
        }
    }
    onPressed: mouse => mouse.accepted = false
    onReleased: mouse => mouse.accepted = false
    onPositionChanged: mouse => mouse.accepted = false
}

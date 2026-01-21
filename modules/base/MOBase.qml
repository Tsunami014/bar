import QtQuick

MouseArea {
    id: marea
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: undefined

    property int expandCounts: 0
    property bool doexpand: false

    property Timer collapseTimer: Timer {
        id: collapseTimer
        interval: 50
        repeat: false
        onTriggered: {
            if (marea.expandCounts <= 0 && !marea.containsMouse) {
                marea.doexpand = false
            }
        }
    }
    onEntered: {
        expandCounts += 1
        doexpand = true
        if (collapseTimer.running) collapseTimer.stop()
    }
    onExited: {
        expandCounts -= 1
        if (expandCounts <= 0) {
            collapseTimer.start()
        }
    }
}

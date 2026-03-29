import QtQuick
import "../.."

MouseArea {
    id: marea
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: undefined

    property int expandCounts: 0
    property int opaqueCounts: 0
    property bool opaque: doexpand || forcexpand
    property bool expand: opaque || opaqueCounts > 0
    property bool doexpand: false
    property bool forcexpand: false
    property bool allowhover: true

    property Timer collapseTimer: Timer {
        id: collapseTimer
        interval: 50
        repeat: false
        onTriggered: {
            if (Theme.expandLock) return;
            if (marea.expandCounts <= 0) {
                marea.doexpand = false
            }
        }
    }
    function forceShut() {
        if (Theme.expandLock) return;
        if (allowhover) {
            expandCounts = marea.containsMouse ? 1 : 0
        } else {
            expandCounts = 0
        }
        forcexpand = false
        marea.doexpand = false
        if (collapseTimer.running) collapseTimer.stop()
    }

    function enter() {
        if (Theme.expandLock) return;
        if (!allowhover) return;
        expandCounts += 1
        doexpand = true
        if (collapseTimer.running) collapseTimer.stop()
    }
    onEntered: enter()
    function exit() {
        if (Theme.expandLock) return;
        if (!allowhover) return;
        expandCounts -= 1
        if (expandCounts <= 0) {
            collapseTimer.start()
        }
    }
    onExited: exit()
    function press() {
        if (Theme.expandLock) return;
        forcexpand = !forcexpand
        if (!forcexpand) forceShut()
    }
    onPressed: press()
}

import QtQuick
import "../.."

MouseArea {
    id: marea
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: undefined

    property string group: ""

    property int expandCounts: 0
    property int opaqueCounts: 0
    property bool opaque: doexpand || stuckOpen || (forcexpand && !prioritiseHover)
    property bool expand: opaque || opaqueCounts > 0
    property bool doexpand: false
    property bool forcexpand: false
    property bool allowhover: true
    property bool stuckOpen: false
    property bool blockExit: false

    property bool prioritiseHover: false
    property bool touchdblstick: false

    property Timer blockExitTimer: Timer {
        id: blockExitTimer
        interval: 400
        repeat: false
        onTriggered: marea.blockExit = false
    }

    property Timer collapseTimer: Timer {
        id: collapseTimer
        interval: 300
        repeat: false
        onTriggered: {
            if (Theme.expandLock) return;
            if (marea.expandCounts <= 0) {
                if (prioritiseHover) forcexpand = false
                marea.doexpand = false
            }
        }
    }
    function forceShutHover() {
        if (Theme.expandLock) return;
        expandCounts = 0
        doexpand = false
        if (collapseTimer.running) collapseTimer.stop()
    }
    function forceShut() {
        if (Theme.expandLock) return;
        if (allowhover) {
            expandCounts = containsMouse ? 1 : 0
        } else {
            expandCounts = 0
        }
        forcexpand = false
        doexpand = false
        stuckOpen = false
        blockExit = false
        if (collapseTimer.running) collapseTimer.stop()
    }
    function shutIfTouch(mouse) {
        if (mouse.source !== undefined && mouse.source !== Qt.MouseEventNotSynthesized) {
            forceShut()
        }
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
        if (!blockExit) stuckOpen = false
    }
    onExited: exit()
    function press() {
        if (Theme.expandLock) return;
        if (stuckOpen) {
            forceShut()
            return
        }
        forcexpand = !forcexpand
        if (!forcexpand && !prioritiseHover) forceShut()
    }
    onPressed: press()

    onDoubleClicked: (mouse) => {
        if (touchdblstick && mouse.source !== undefined && mouse.source !== Qt.MouseEventNotSynthesized) {
            marea.stuckOpen = true
            marea.blockExit = true
            marea.blockExitTimer.restart()
        }
    }

    onDoexpandChanged: {
        if (!group) return
        if (doexpand) GroupMgr.hoverOpened(group, marea)
        else GroupMgr.hoverClosed(group, marea)
    }
}

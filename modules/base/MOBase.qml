import QtQuick
import "../.."

MouseArea {
    id: marea
    anchors.fill: parent
    cursorShape: undefined

    property string group: ""

    property int expandCounts: 0
    property int opaqueCounts: 0
    property bool opaque: doexpand || stuckOpen || (forcexpand && !prioritiseHover)
    property bool expand: opaque || opaqueCounts > 0
    property bool doexpand: false
    property bool forcexpand: false

    // 0 = hover never activates
    // 1 = hover activates only after being hovered for ~500ms
    // 2 = hover activates immediately
    property int allowhover: 2

    property bool stuckOpen: false
    property bool blockExit: false

    property bool prioritiseHover: false
    property bool touchdblstick: false

    // set by touch, cleared by mouse press
    property bool touching: false
    // finger currently down
    property bool touchHeld: false
    // how long touch keeps a prioritiseHover bar open after release
    property int touchDelay: 1000

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

    property Timer hoverDelayTimer: Timer {
        id: hoverDelayTimer
        interval: 300
        repeat: false
        onTriggered: marea.doEnter()
    }

    // touch fires stray enter/exit around presses, ignore hover while touched
    property Timer touchGuardTimer: Timer {
        id: touchGuardTimer
        interval: 500
        repeat: false
    }

    // touch has no hover, only real pointers count
    HoverHandler {
        id: hover
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad | PointerDevice.Stylus
        onHoveredChanged: {
            if (hovered) marea.enter()
            else marea.exit()
        }
    }

    function forceShutHover() {
        if (Theme.expandLock) return;
        expandCounts = 0
        doexpand = false
        if (collapseTimer.running) collapseTimer.stop()
        if (hoverDelayTimer.running) hoverDelayTimer.stop()
    }
    function forceShut() {
        if (Theme.expandLock) return;
        if (allowhover > 0) {
            expandCounts = hover.hovered && !touching ? 1 : 0
        } else {
            expandCounts = 0
        }
        forcexpand = false
        doexpand = false
        stuckOpen = false
        blockExit = false
        if (collapseTimer.running) collapseTimer.stop()
        if (hoverDelayTimer.running) hoverDelayTimer.stop()
    }
    function shutIfTouch(mouse) {
        if (mouse.source !== undefined && mouse.source !== Qt.MouseEventNotSynthesized) {
            forceShut()
        }
    }

    function collapse() {
        collapseTimer.interval = touching && prioritiseHover ? touchDelay : 300
        collapseTimer.restart()
    }

    function doEnter() {
        expandCounts += 1
        doexpand = true
        if (collapseTimer.running) collapseTimer.stop()
    }

    function enter() {
        if (Theme.expandLock) return;
        if (allowhover === 0) return;
        if (touchHeld || touchGuardTimer.running) return;
        if (allowhover === 1 && !doexpand) {
            hoverDelayTimer.restart()
            return
        }
        doEnter()
    }

    function exit() {
        if (Theme.expandLock) return;
        if (allowhover === 0) return;
        if (touchHeld || touchGuardTimer.running) return;
        if (hoverDelayTimer.running) {
            hoverDelayTimer.stop()
            return
        }
        expandCounts = Math.max(0, expandCounts - 1)
        if (expandCounts <= 0) {
            collapse()
        }
        if (!blockExit) stuckOpen = false
    }

    function press() {
        if (Theme.expandLock) return;
        if (stuckOpen) {
            forceShut()
            return
        }
        // first touch only wakes it, like a hover
        if (touching && prioritiseHover && !doexpand) {
            doexpand = true
            return
        }
        forcexpand = !forcexpand
        if (!forcexpand && !prioritiseHover) forceShut()
    }

    function touchDown() {
        touching = true
        touchHeld = true
        touchGuardTimer.restart()
        if (collapseTimer.running) collapseTimer.stop()
    }
    function touchUp() {
        touchHeld = false
        touchGuardTimer.restart()
        if (doexpand) collapse()
    }
    function touchTap() {
        if (prioritiseHover) press()
    }

    onPressed: (mouse) => {
        if (mouse.source !== Qt.MouseEventNotSynthesized) touchDown()
        else touching = false
        press()
    }
    onReleased: if (touchHeld) touchUp()
    onCanceled: if (touchHeld) touchUp()

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

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
    property int _rawval: Math.round(slider.value)
    property int val: Math.max(0, Math.min(100, _rawval))

    property int radius: width * Theme.sliderRound

    property bool handleHovered: false
    readonly property bool dragging: dragArea.pressed
    property bool recentlyChanged: false
    property int changeShowTime: 1000
    readonly property bool showValue: handleHovered || dragging || recentlyChanged

    onValChanged: {
        if (!ready) return
        recentlyChanged = true
        changeTimer.restart()
    }
    Timer {
        id: changeTimer
        interval: slider.changeShowTime
        onTriggered: slider.recentlyChanged = false
    }

    from: 0
    to: 100
    Component.onCompleted: {
        if (initial) initial.running = true
    }

    property bool _dirty: false
    onMoved: {
        if (!ready || !change) return
        if (change.running) _dirty = true
        else change.running = true
    }
    Connections {
        target: slider.change
        function onRunningChanged() {
            if (!slider.change.running && slider._dirty) {
                slider._dirty = false
                slider.change.running = true   // command re-evaluates with the latest slider.val
            }
        }
    }

    anchors.fill: parent
    background: Rectangle {
        id: bg
        border.color: Qt.darker(slider.col, Theme.lighten)
        border.width: Theme.borderWidth
        color: Qt.lighter(slider.col, Theme.lighten)
        radius: slider.radius

        Rectangle {
            width: bg.width
            // Fill reaches the handle's centre, so it lines up across the whole travel
            height: slider.handle.height / 2 + (bg.height - slider.handle.height) * slider.position
            anchors.bottom: parent.bottom
            color: Theme.colTransparent
            clip: true
            Rectangle {
                // Filled portion
                width: bg.width
                height: bg.height
                anchors.bottom: parent.bottom
                radius: bg.radius
                color: Qt.lighter(slider.fillcol, Theme.lighten)
                border.color: Qt.darker(slider.fillcol, Theme.lighten)
                border.width: Theme.borderWidth
            }
        }
    }

    handle: Rectangle {
        width: parent.width
        radius: slider.radius
        height: radius*2
        anchors.bottom: parent.bottom
        // Handle travels the full track: bottom edge at 0, top edge at 100
        anchors.bottomMargin: (parent.height - height) * slider.position
        color: Qt.lighter(slider.handlecol, Theme.lighten)
        border.color: Qt.darker(slider.handlecol, Theme.lighten)
        border.width: Theme.borderWidth
        HoverHandler {
            blocking: false
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad | PointerDevice.Stylus
            onHoveredChanged: slider.handleHovered = hovered
        }
        Text {
            text: slider.text
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            color: Qt.darker(slider.handlecol, Theme.lighten*1.5)
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            font.bold: true
        }
    }
    // Custom drag handler
    MouseArea {
        id: dragArea
        anchors.fill: parent
        preventStealing: true
        property real grabOffset: 0

        // handle centre sits hh/2 .. height-hh/2
        readonly property real hh: slider.handle.height
        readonly property real travel: Math.max(1, slider.height - hh)

        function apply(y) {
            const pos = Math.max(0, Math.min(1, (slider.height - y - grabOffset - hh / 2) / travel))
            slider.value = slider.from + pos * (slider.to - slider.from)
            slider.moved()
        }
        onPressed: mouse => {
            const h = slider.handle
            const onHandle = mouse.y >= h.y && mouse.y <= h.y + h.height
            grabOffset = onHandle ? (slider.height - mouse.y) - (hh / 2 + slider.position * travel) : 0
            if (!onHandle) apply(mouse.y)
        }
        onPositionChanged: mouse => { if (pressed) apply(mouse.y) }
    }
}

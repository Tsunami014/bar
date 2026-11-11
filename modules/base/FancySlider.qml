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
    property int val: (
        _rawval >= 99 ? 100 : (
            _rawval <= 1 ? 0 : _rawval
        )
    )

    property int radius: width * Theme.sliderRound

    property bool handleHovered: false
    readonly property bool dragging: dragArea.pressed
    readonly property bool showValue: handleHovered || dragging

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
        anchors.bottomMargin: Math.min(Math.max(
            parent.height * slider.position - height/2,
        0), parent.height - height)
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
    MouseArea {
        id: dragArea
        anchors.fill: parent
        preventStealing: true
        property real grabOffset: 0

        function apply(y) {
            const pos = Math.max(0, Math.min(1, (slider.height - y - grabOffset) / slider.height))
            slider.value = slider.from + pos * (slider.to - slider.from)
            slider.moved()
        }
        onPressed: mouse => {
            const h = slider.handle
            const onHandle = mouse.y >= h.y && mouse.y <= h.y + h.height
            grabOffset = onHandle ? (slider.height - mouse.y) - slider.position * slider.height : 0
            if (!onHandle) apply(mouse.y)
        }
        onPositionChanged: mouse => { if (pressed) apply(mouse.y) }
    }
}

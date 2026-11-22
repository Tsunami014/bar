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

    signal dragged(int nval)
    property bool overrideOnDrag: false

    function flashValue() {
        recentlyChanged = true
        changeTimer.restart()
    }
    onValChanged: {
        if (!ready) return
        flashValue()
    }
    onReadyChanged: if (ready) flashValue()
    Component.onCompleted: if (ready) flashValue()
    Timer {
        id: changeTimer
        interval: slider.changeShowTime
        onTriggered: slider.recentlyChanged = false
    }

    from: 0
    to: 100

    anchors.fill: parent
    background: Bubble {
        id: bg
        type: Theme.BublDarkBordr
        col: slider.col
        padding: 0
        shadowDrop: 2
        radius: slider.radius

        Rectangle {
            width: bg.width
            // Fill reaches the handle's centre, so it lines up across the whole travel
            height: slider.handle.height / 2 + (bg.height - slider.handle.height) * slider.position
            anchors.bottom: parent.bottom
            color: Theme.colTransparent
            clip: true
            // Filled portion
            Bubble {
                width: bg.width
                height: bg.height
                anchors.bottom: parent.bottom
                type: Theme.BublFill
                col: slider.fillcol
                padding: 0
                shadowDrop: 0
                radius: bg.radius
            }
        }
    }

    handle: Bubble { id: hnd
        width: parent.width
        radius: slider.radius
        height: radius*2
        anchors.bottom: parent.bottom
        // Handle travels the full track: bottom edge at 0, top edge at 100
        anchors.bottomMargin: (parent.height - height) * slider.position
        type: Theme.BublFill
        col: slider.handlecol
        padding: 0
        shadowDrop: 2
        HoverHandler {
            blocking: false
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad | PointerDevice.Stylus
            onHoveredChanged: slider.handleHovered = hovered
        }
        item: Text {
            text: slider.text
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            color: hnd.fg
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
            const nval = slider.from + pos * (slider.to - slider.from)
            if (overrideOnDrag) slider.value = nval
            slider.dragged(nval)
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

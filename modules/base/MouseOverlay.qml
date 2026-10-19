import QtQuick
import "../.."

MouseArea {
    id: overlay
    anchors.fill: parent
    cursorShape: undefined
    property MOBase area: null

    onPressed: mouse => mouse.accepted = false
    onReleased: mouse => mouse.accepted = false
    onPositionChanged: mouse => mouse.accepted = false

    // hoverEnabled is off, touch has no hover, only real pointers count
    HoverHandler {
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad | PointerDevice.Stylus
        onHoveredChanged: {
            if (!overlay.area) return
            if (hovered) overlay.area.enter()
            else overlay.area.exit()
        }
    }
    // finger down holds it open, lifting starts the close timer
    PointHandler {
        acceptedDevices: PointerDevice.TouchScreen
        onActiveChanged: {
            if (!overlay.area) return
            if (active) overlay.area.touchDown()
            else overlay.area.touchUp()
        }
    }
    TapHandler {
        acceptedDevices: PointerDevice.TouchScreen
        onTapped: if (overlay.area) overlay.area.touchTap()
    }

    Component.onDestruction: if (area) area.touchUp()
}

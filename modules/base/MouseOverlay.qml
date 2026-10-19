import QtQuick
import "../.."

MouseArea {
    id: overlay
    anchors.fill: parent
    cursorShape: undefined
    property MOBase area: null
    // last area we told about hovering, so a swapped area doesn't keep a stale entry
    property MOBase prevArea: null

    onPressed: mouse => mouse.accepted = false
    onReleased: mouse => mouse.accepted = false
    onPositionChanged: mouse => mouse.accepted = false

    onAreaChanged: {
        if (prevArea) prevArea.exit(overlay)
        prevArea = area
    }

    // hoverEnabled is off, touch has no hover, only real pointers count
    HoverHandler {
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad | PointerDevice.Stylus
        onHoveredChanged: {
            if (!overlay.area) return
            if (hovered) overlay.area.enter(overlay)
            else overlay.area.exit(overlay)
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

    Component.onDestruction: if (area) {
        area.exit(overlay)
        area.touchUp()
    }
}

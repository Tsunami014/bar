import QtQuick
import QtQuick.Shapes
import "../.."

Item {
    id: corner
    clip: true
    width: Theme.barRound
    height: Theme.barRound

    property int rx: 0   // which corner this notch is for
    property int ry: 0

    // center of the circle = the corner point the curve should hug
    property real cx: rx ? 0 : width
    property real cy: ry ? 0 : height

    Shape {
        anchors.fill: parent
        antialiasing: true
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            strokeWidth: Theme.barRound + Theme.barBorder*2
            strokeColor: Theme.colBorder
            fillColor: Theme.colTransparent
            PathAngleArc {
                centerX: corner.cx; centerY: corner.cy
                radiusX: Theme.barRound*1.5; radiusY: Theme.barRound*1.5
                startAngle: 0
                sweepAngle: 360
            }
        }
        ShapePath {
            strokeWidth: Theme.barRound
            strokeColor: Theme.colBg
            fillColor: Theme.colTransparent
            PathAngleArc {
                centerX: corner.cx; centerY: corner.cy
                radiusX: Theme.barRound*1.5; radiusY: Theme.barRound*1.5
                startAngle: 0
                sweepAngle: 360
            }
        }
    }
}

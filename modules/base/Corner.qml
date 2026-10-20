import QtQuick
import QtQuick.Shapes
import "../.."

Item {
    id: corner
    width: Theme.barRound
    height: Theme.barRound

    property int rx: 0   // which corner this notch is for
    property int ry: 0

    readonly property real r: Theme.barRound    // outer radius of the border
    readonly property real b: Theme.barBorder   // border thickness, inner radius is r - b
    readonly property real o: 2                 // drawn this far past the edges, the window trims it

    // coordinates below are for the top left, these mirror them for the others
    function mx(x) { return rx ? r - x : x }
    function my(y) { return ry ? r - y : y }
    readonly property int dir: rx === ry ? PathArc.Counterclockwise : PathArc.Clockwise

    Shape {
        anchors.fill: parent
        antialiasing: true
        preferredRendererType: Shape.CurveRenderer

        // border, the whole square minus the inner circle
        // it runs under the fill so the curve has no seam
        // the straight ends run on past the item so the edge pixels are never partial
        ShapePath {
            strokeWidth: -1
            fillColor: Theme.colBorder
            startX: corner.mx(0); startY: corner.my(0)
            PathLine { x: corner.mx(corner.r + corner.o); y: corner.my(0) }
            PathLine { x: corner.mx(corner.r + corner.o); y: corner.my(corner.b) }
            PathLine { x: corner.mx(corner.r);            y: corner.my(corner.b) }
            PathArc {
                x: corner.mx(corner.b); y: corner.my(corner.r)
                radiusX: corner.r - corner.b; radiusY: corner.r - corner.b
                direction: corner.dir
            }
            PathLine { x: corner.mx(corner.b); y: corner.my(corner.r + corner.o) }
            PathLine { x: corner.mx(0);        y: corner.my(corner.r + corner.o) }
        }
        // fill, everything outside the outer circle, also runs past the edges
        ShapePath {
            strokeWidth: -1
            fillColor: Theme.colBg
            startX: corner.mx(-corner.o); startY: corner.my(-corner.o)
            PathLine { x: corner.mx(corner.r + corner.o); y: corner.my(-corner.o) }
            PathLine { x: corner.mx(corner.r + corner.o); y: corner.my(0) }
            PathLine { x: corner.mx(corner.r);            y: corner.my(0) }
            PathArc {
                x: corner.mx(0); y: corner.my(corner.r)
                radiusX: corner.r; radiusY: corner.r
                direction: corner.dir
            }
            PathLine { x: corner.mx(0);         y: corner.my(corner.r + corner.o) }
            PathLine { x: corner.mx(-corner.o); y: corner.my(corner.r + corner.o) }
        }
    }
}

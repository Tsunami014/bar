import QtQuick
import "../.."

Rectangle { id: root
    property var type: Theme.BublDarkBordr
    // Everything marked CHNG is theme-dependent

    property color col: "#FFF"
    Behavior on col { ColorAnimation { duration: 120 } }

    property color col2: col
    property int gradOrient: Gradient.Vertical
    readonly property bool hasGrad: !Qt.colorEqual(col, col2)
    readonly property color mid: hasGrad? Qt.rgba(
        (col.r + col2.r)/2,
        (col.g + col2.g)/2,
        (col.b + col2.b)/2,
        (col.a + col2.a)/2
    ) : col

    property int padding: 4

    property real creamWidth: 3
    readonly property real activeCreamWid: cream.active? creamWidth : 0
    property real shadowDrop: 4

    readonly property real fullBordr: padding + Theme.borderWidth + activeCreamWid

    // CHNG
    property bool hang: type !== Theme.BublFlat && type !== Theme.BublFlatDark && type !== Theme.BublFlat

    implicitWidth: content.childrenRect.width + fullBordr*2
    implicitHeight: content.childrenRect.height + fullBordr*2

    radius: Theme.borderRadius

    // CHNG
    property color fg:
        type === Theme.BublFill||type === Theme.BublFlat? Qt.darker(mid, Theme.lighten*2.2) :
        type === Theme.BublFlatDark? Qt.lighter(mid, Theme.lighten*2) :
        type === Theme.BublBorder? Qt.darker(mid, Theme.lighten*2) :
        type === Theme.BublDark || type === Theme.BublDarkBordr? Qt.lighter(mid, Theme.lighten) :
        mid

    // CHNG
    function fillOf(c) {
        return type === Theme.BublDarkBordr? shadowOf(c) :
        type === Theme.BublFlatDark? shadowOf(c) :
        type === Theme.BublDark? Qt.hsla(
            c.hslHue,
            c.hslSaturation * 0.05,
            c.hslLightness*0.3,
        ) :
        type === Theme.BublBorder? Qt.hsla(
            c.hslHue,
            Theme.colFg.hslSaturation * 0.3,
            c.hslLightness + 0.1,
        ) :
        type === Theme.BublOutline? Qt.hsla(
            c.hslHue,
            0,
            (c.hslLightness + Theme.colBg.hslLightness*2)/3,
        ) :
        type === Theme.BublFill || type === Theme.BublFlat? Qt.hsla(
            c.hslHue,
            c.hslSaturation*0.95,
            c.hslLightness*1.02,
        ) : c
    }

    // CHNG
    function shadowOf(c) {
        return type === Theme.BublOutline? c :
        type === Theme.BublFlat? fillOf(c) :
        type === Theme.BublBorder? Qt.hsla(
            c.hslHue,
            c.hslSaturation * 0.3,
            (c.hslLightness + Theme.colBg.hslLightness*3)/4,
        ) :
        type === Theme.BublFill? Qt.hsla(
            c.hslHue,
            c.hslSaturation * 0.4,
            c.hslLightness / Theme.lighten*0.7,
        ) :
        type === Theme.BublDarkBordr? Qt.hsla(
            c.hslHue,
            c.hslSaturation * 0.1,
            (c.hslLightness + Theme.colBg.hslLightness*3)/4,
        ) :
        type === Theme.BublDark? Qt.hsla(
            c.hslHue,
            c.hslSaturation * 0.4,
            c.hslLightness / Theme.lighten*0.6,
        ) :
        Qt.darker(c, Theme.lighten*2)
    }

    color: fillOf(col)
    property color shadowCol: shadowOf(mid)

    gradient: hasGrad? fillGrad : null
    Gradient {
        id: fillGrad
        orientation: root.gradOrient
        GradientStop { position: 0.0; color: root.fillOf(root.col) }
        GradientStop { position: 1.0; color: root.fillOf(root.col2) }
    }

    // Hard shadow
    Loader {
        z: -1
        active: hang
        sourceComponent: Rectangle {
            y: root.shadowDrop
            width: root.width
            height: root.height
            radius: root.radius*0.9
            color: root.shadowCol
        }
    }
    border.color: shadowCol
    border.width: type === Theme.BublFlat? 0 : Theme.borderWidth

    // Thin cream border
    Loader {
        id: cream
        // CHNG
        active: root.type === Theme.BublDarkBordr || root.type === Theme.BublFill
        sourceComponent: Rectangle {
            x: Theme.borderWidth
            y: Theme.borderWidth
            width: root.width - Theme.borderWidth*2
            height: root.height - Theme.borderWidth*2
            radius: Math.max(0, root.radius - Theme.borderWidth)
            color: Theme.colTransparent
            // CHNG
            border.color:
                root.type == Theme.BublFill? Qt.lighter(root.mid, Theme.lighten*1.3) :
                root.fg
            border.width: root.creamWidth
        }
    }

    property Item item
    Item {
        id: content
        anchors.fill: parent
        anchors.margins: root.fullBordr

        Component.onCompleted: {
            if (root.item) {
                root.item.parent = content
            }
        }
    }
}

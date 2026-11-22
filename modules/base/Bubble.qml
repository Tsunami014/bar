import QtQuick
import "../.."

Rectangle { id: root
    property var type: Theme.BublDarkBordr
    // Everything marked CHNG is theme-dependent

    property color col: "#FFF"
    Behavior on col { ColorAnimation { duration: 120 } }

    property int padding: 4

    property real creamWidth: 3
    readonly property real activeCreamWid: cream.active? creamWidth : 0
    property real shadowDrop: 4

    readonly property real fullBordr: padding + Theme.borderWidth + activeCreamWid

    // CHNG
    property bool hang: type !== Theme.BublPlain && type !== Theme.BublPlainDark

    implicitWidth: content.childrenRect.width + fullBordr*2
    implicitHeight: content.childrenRect.height + fullBordr*2

    radius: Theme.borderRadius

    // CHNG
    property color fg:
        type === Theme.BublFill||type === Theme.BublPlain? Qt.darker(col, Theme.lighten*2.2) :
        type === Theme.BublPlainDark? Qt.lighter(col, Theme.lighten*2) :
        type === Theme.BublBorder? Qt.darker(col, Theme.lighten*2) :
        type === Theme.BublDark || type === Theme.BublDarkBordr? Qt.lighter(col, Theme.lighten) :
        col

    // CHNG
    color:
        type === Theme.BublDarkBordr? shadowCol :
        type === Theme.BublPlainDark? shadowCol :
        type === Theme.BublDark? Qt.hsla(
            col.hslHue,
            col.hslSaturation * 0.05,
            col.hslLightness*0.3,
        ) :
        type === Theme.BublBorder? Qt.hsla(
            col.hslHue,
            Theme.colFg.hslSaturation * 0.3,
            col.hslLightness + 0.1,
        ) :
        type === Theme.BublOutline? Qt.hsla(
            col.hslHue,
            0,
            (col.hslLightness + Theme.colBg.hslLightness*2)/3,
        ) :
        type === Theme.BublFill || type === Theme.BublPlain? Qt.hsla(
            col.hslHue,
            col.hslSaturation*0.95,
            col.hslLightness*1.02,
        ) : col

    // CHNG
    property color shadowCol:
        type === Theme.BublOutline? col :
        type === Theme.BublPlain? color :
        type === Theme.BublBorder? Qt.hsla(
            col.hslHue,
            col.hslSaturation * 0.3,
            (col.hslLightness + Theme.colBg.hslLightness*3)/4,
        ) :
        type === Theme.BublFill? Qt.hsla(
            col.hslHue,
            col.hslSaturation * 0.4,
            col.hslLightness / Theme.lighten*0.7,
        ) :
        type === Theme.BublDarkBordr? Qt.hsla(
            col.hslHue,
            col.hslSaturation * 0.1,
            (col.hslLightness + Theme.colBg.hslLightness*3)/4,
        ) :
        type === Theme.BublDark? Qt.hsla(
            col.hslHue,
            col.hslSaturation * 0.4,
            col.hslLightness / Theme.lighten*0.6,
        ) :
        Qt.darker(col, Theme.lighten*2)

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
    border.width: Theme.borderWidth

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
                root.type == Theme.BublFill? Qt.lighter(root.col, Theme.lighten*1.3) :
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

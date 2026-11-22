import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import Quickshell
import ".."
import "base"

Bubble { id: root
    col: Theme.colPalette

    item: Text {
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter

        text: Theme.paletteName
        color: root.fg
        font.family: Theme.fontFamily
        font.pixelSize: Math.round(Theme.fontSize * 0.6)
        font.bold: true
    }

    readonly property int optionHeight: Math.round(Theme.fontSize * 1.3)
    readonly property int popPad: 5
    readonly property int popHeight: hits.height + popPad * 2

    property int hoverIndex: -1
    property real popTop: 0

    function updatePopTop() {
        var wy = root.mapToItem(null, 0, 0).y
        var top = root.height / 2 - popHeight / 2
        if (root.Window.height > 0) {
            top = Math.min(top, root.Window.height - wy - popHeight)
            top = Math.max(top, -wy)
        }
        popTop = top
    }

    // Invisible column (as mouse tracking only works on the window first clicked on, not the popup)
    Column {
        id: hits
        x: root.width + root.popPad
        y: root.popTop + root.popPad
        opacity: 0
        Repeater {
            model: Theme.palettes.length
            delegate: Item {
                required property int index
                readonly property int optIndex: index
                width: 2
                height: root.optionHeight
            }
        }
    }

    function indexAt(mx, my) {
        var p = ma.mapToItem(hits, mx, my)
        if (p.x < 0) return -1   // still over the bubble
        var it = hits.childAt(1, p.y)
        return it ? it.optIndex : -1
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor
        preventStealing: true

        property bool armed: false
        readonly property bool open: armed && pressed && (pressedButtons & Qt.LeftButton)

        onPressed: mouse => {
            root.updatePopTop()
            armed = (mouse.button === Qt.LeftButton)
            root.hoverIndex = (mouse.button === Qt.LeftButton) ? root.indexAt(mouse.x, mouse.y) : -1
        }
        onPositionChanged: mouse => {
            if (open) root.hoverIndex = root.indexAt(mouse.x, mouse.y)
        }
        onReleased: mouse => {
            if (mouse.button === Qt.LeftButton && root.hoverIndex >= 0)
                Theme.setPalette(root.hoverIndex)
            root.hoverIndex = -1
            armed = false
        }
        onClicked: mouse => {
            if (mouse.button === Qt.RightButton) Theme.resetPalette()
        }
        onCanceled: { root.hoverIndex = -1; armed = false }
        onOpenChanged: if (!open) root.hoverIndex = -1
    }

    Loader {
        active: ma.open
        sourceComponent: PopupWindow {
            anchor {
                item: root
                edges: Edges.Top | Edges.Left
                gravity: Edges.Bottom | Edges.Right
                adjustment: PopupAdjustment.None
                rect {
                    x: root.width
                    y: root.popTop
                    width: 1
                    height: 1
                }
            }
            implicitWidth: Math.max(1, list.implicitWidth + root.popPad * 2)
            implicitHeight: root.popHeight
            visible: true
            color: Theme.colTransparent
            // Purely visual
            mask: Region {}

            Rectangle {
                anchors.fill: parent
                radius: Theme.borderRadius
                color: Theme.colBg
                border.color: Theme.colBorder
                border.width: Theme.barBorder

                // implicitWidth = widest option
                ColumnLayout {
                    id: list
                    anchors.centerIn: parent
                    spacing: 0
                    Repeater {
                        model: Theme.palettes.length
                        delegate: Rectangle {
                            id: opt
                            required property int index
                            readonly property bool hovered: root.hoverIndex === index
                            readonly property color optCol: Theme.palettes[index].button

                            Layout.fillWidth: true
                            Layout.preferredHeight: root.optionHeight
                            implicitWidth: label.implicitWidth + 16
                            radius: Theme.borderRadius
                            // color: hovered ? Qt.rgba(optCol.r, optCol.g, optCol.b, 0.3) : "transparent"
                            color: hovered ? optCol : "transparent"
                            border.width: hovered ? Theme.borderWidth : 0
                            // border.color: optCol
                            border.color: Qt.darker(optCol, Theme.lighten*2)

                            Text {
                                id: label
                                anchors.centerIn: parent
                                text: Theme.palettes[opt.index].name
                                // color: opt.optCol
                                color: opt.hovered? Theme.colBg : opt.optCol
                                font.family: Theme.fontFamily
                                font.pixelSize: Math.round(Theme.fontSize * 0.6)
                                font.bold: true
                            }
                        }
                    }
                }
            }
        }
    }
}

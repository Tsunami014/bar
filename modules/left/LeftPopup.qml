import QtQuick
import Quickshell
import "../base"
import "../.."

MOBase {
    id: marea
    group: "left"

    Item {
        id: outerItems
        property int margin: 5
        anchors {
            fill: parent
            topMargin: margin + Theme.barBorder
            bottomMargin: margin + Theme.barBorder
            leftMargin: margin + Theme.barPadding
            rightMargin: margin + Theme.barBorder
        }
        visible: false
        Item { id: innerItems }
    }
    Loader {
        id: loader
        anchors.fill: parent
        active: marea.expand
        sourceComponent: PopupWindow {
            id: pop
            anchor {
                item: marea
                gravity: Edges.Right
                adjustment: PopupAdjustment.Slide
                rect {
                    x: marea.width
                    y: marea.height/2
                }
            }
            mask: Region { item: popRect }
            implicitWidth: Theme.align((innerItems.childrenRect.width || 1) + outerItems.margin*2 + Theme.barPadding + Theme.barBorder)
            implicitHeight: Theme.align((innerItems.childrenRect.height || 1) + outerItems.margin*2 + Theme.barRound*2)
            visible: true
            color: Theme.colTransparent

            Rectangle {
                id: popRect
                anchors {
                    fill: parent
                    topMargin: Theme.barRound - Theme.barBorder
                    bottomMargin: Theme.barRound - Theme.barBorder
                }
                topRightRadius: 10
                bottomRightRadius: 10
                color: Theme.colBg
                border.color: Theme.colBorder
                border.width: Theme.barBorder
                Component.onCompleted: {
                    outerItems.parent = popRect
                    outerItems.visible = true
                }
            }
            Rectangle {
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                }
                width: Math.max(Theme.barBorder, Theme.barPadding)
                color: Theme.colBg
            }
            Corner {
                anchors {
                    top: parent.top
                    left: parent.left
                    leftMargin: Theme.barPadding
                }
                ry: 1
            }
            Corner {
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    leftMargin: Theme.barPadding
                }
            }
            MouseOverlay { area: marea }
        }
    }
    default property alias contentIts: innerItems.data
}

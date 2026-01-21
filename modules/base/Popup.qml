import QtQuick
import Quickshell
import "../.."

MOBase {
    id: marea

    Item {
        id: outerItems
        property int margin: 5
        anchors {
            fill: parent
            topMargin: margin
            bottomMargin: margin
            leftMargin: margin
            rightMargin: margin
        }
        visible: false
        Item { id: innerItems }
    }
    Loader {
        id: loader
        anchors.fill: parent
        active: marea.doexpand
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
            implicitWidth: (innerItems.childrenRect.width || 1) + outerItems.margin*2 + Theme.barPadding
            implicitHeight: (innerItems.childrenRect.height || 1) + outerItems.margin*2
            visible: true
            color: Theme.colTransparent

            PopupWindow {
                anchor {
                    item: popRect
                    gravity: Edges.Right
                    adjustment: PopupAdjustment.None
                    rect {
                        y: popRect.height/2 - 1
                    }
                }
                color: Theme.colTransparent
                implicitWidth: Theme.barRound
                implicitHeight: popRect.height+Theme.barRound*2 - 1
                visible: true
                Corner {
                    anchors {
                        top: parent.top
                        left: parent.left
                    }
                    ry: 1
                }
                Corner {
                    anchors {
                        bottom: parent.bottom
                        left: parent.left
                    }
                }
                MouseOverlay { area: marea }
            }
            Rectangle {
                id: popRect
                anchors.fill: parent
                anchors.leftMargin: Theme.barPadding
                topRightRadius: 10
                bottomRightRadius: 10
                color: Theme.colBg
                Component.onCompleted: {
                    outerItems.parent = popRect
                    outerItems.visible = true
                }
            }
            MouseOverlay { area: marea }
        }
    }
    default property alias contentIts: innerItems.data
}

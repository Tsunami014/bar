import QtQuick
import Quickshell
import "../.."

MouseArea {
    id: area
    hoverEnabled: true
    anchors.fill: parent

    property int expandCounts: 0
    property bool doexpand: false

    Timer {
        id: collapseTimer;
        interval: 50;
        repeat: false;
        onTriggered: {
            if (expandCounts <= 0) {
                doexpand = false
            }
        }
    }

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
        active: area.doexpand
        sourceComponent: PopupWindow {
            id: pop
            anchor {
                item: area
                gravity: Edges.Right
                adjustment: PopupAdjustment.Slide
                rect {
                    x: area.width
                    y: area.height/2
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
                        y: popRect.height/2
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
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    area.expandCounts += 1
                }
                onExited: {
                    area.expandCounts -= 1
                    if (area.expandCounts <= 0) {
                        collapseTimer.start()
                    }
                }
            }
        }
    }
    onEntered: {
        area.expandCounts += 1
        area.doexpand = true
    }
    onExited: {
        area.expandCounts -= 1
        if (area.expandCounts <= 0) {
            collapseTimer.start()
        }
    }
    default property alias contentIts: innerItems.data
}

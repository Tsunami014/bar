import QtQuick
import Quickshell
import ".."
import "../sides/"
import "../modules/base/"

PanelWindow {
    id: bar
    anchors { bottom: true; left: true; right: true }
    exclusiveZone: Theme.barBaseSze
    implicitHeight: Theme.barBaseSze
    color: Theme.colTransparent

    Rectangle {
        id: rect
        anchors.fill: parent
        color: Theme.colBg

        MOBase {
            id: marea
            prioritiseHover: true
            touchDelay: 3000
        }
    }

    PanelWindow {
        id: panelWin
        anchors { bottom: true; left: true; right: true }
        exclusiveZone: 0
        implicitHeight: Screen.desktopAvailableHeight / 2
        color: "transparent"
        visible: true

        mask: Region { item: marea.expand ? mainR : null }

        Rectangle {
            id: mainR
            visible: marea.expand
            color: Theme.colBg
            border.color: Theme.colBorder
            border.width: Theme.barBorder
            anchors.bottom: parent.bottom
            x: Theme.snap((parent.width - width + Theme.rightBarWidth - Theme.leftBarWidth) / 2)
            height: Theme.snap((content.item ? content.item.height : 0) + Theme.barBaseSze + Theme.barBorder)
            width: Theme.snap((content.item ? content.item.width  : 0) + Theme.barPadding*4 + Theme.barBorder*2)

            topLeftRadius: 20
            topRightRadius: 20
            opacity: marea.opaque ? 1 : 0

            onHeightChanged: if (height > panelWin.height)
                console.warn("panel taller than window:", height, ">", panelWin.height)

            Rectangle {
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }
                height: Theme.barBorder
                color: Theme.colBg
            }
            Loader {
                id: content
                active: marea.expand
                anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom }
                sourceComponent: Bottom {
                    full: marea.forcexpand
                    Component.onCompleted: {
                        children.forEach(child => {
                            if (child.proc) {
                                child.proc.started.connect(() => marea.opaqueCounts += 1)
                                child.proc.exited.connect(() => marea.opaqueCounts -= 1)
                            }
                        })
                    }
                }
            }

            MouseOverlay { area: marea }
        }

        Corner {
            visible: marea.expand
            anchors { bottom: parent.bottom; left: mainR.right; leftMargin: -Theme.barBorder }
            ry: 1
        }
        Corner {
            visible: marea.expand
            anchors { bottom: parent.bottom; right: mainR.left; rightMargin: -Theme.barBorder }
            rx: 1
            ry: 1
        }
    }
}

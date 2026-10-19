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

        Corner {
            visible: marea.expand
            anchors { bottom: parent.bottom; left: mainR.right; leftMargin: -1 }
            ry: 1
        }
        Corner {
            visible: marea.expand
            anchors { bottom: parent.bottom; right: mainR.left; rightMargin: -1 }
            rx: 1
            ry: 1
        }

        Rectangle {
            id: mainR
            visible: marea.expand
            color: Theme.colBg
            anchors {
                horizontalCenter: parent.horizontalCenter
                horizontalCenterOffset: (Theme.rightBarWidth - Theme.leftBarWidth) / 2
                bottom: parent.bottom
            }
            height: (content.item ? content.item.height : 0) + Theme.barBaseSze + 1
            width:  (content.item ? content.item.width  : 0) + Theme.barPadding*4

            topLeftRadius: 20
            topRightRadius: 20
            opacity: marea.opaque ? 1 : 0

            onHeightChanged: if (height > panelWin.height)
                console.warn("panel taller than window:", height, ">", panelWin.height)

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
    }
}

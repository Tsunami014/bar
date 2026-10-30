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

        function colAt(i) {
            return marea.expand && content.item && content.item.columns
                ? content.item.columns[i] : null
        }
        mask: Region {
            Region { item: panelWin.colAt(0) }
            Region { item: panelWin.colAt(1) }
            Region { item: panelWin.colAt(2) }
            Region { item: panelWin.colAt(3) }
        }

        // just sizes/positions the columns, they draw the panel themselves
        Item {
            id: mainR
            visible: marea.expand
            anchors.bottom: parent.bottom
            x: Theme.snap((parent.width - width + Theme.rightBarWidth - Theme.leftBarWidth) / 2)
            width: content.item ? content.item.width : 0
            height: content.item ? content.item.height : 0
            opacity: marea.opaque ? 1 : 0

            onHeightChanged: if (height > panelWin.height)
                console.warn("panel taller than window:", height, ">", panelWin.height)

            Loader {
                id: content
                active: marea.expand
                anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom }
                sourceComponent: Bottom {
                    area: marea
                    full: marea.forcexpand
                    Component.onCompleted: {
                        modules.forEach(child => {
                            if (child.proc) {
                                child.proc.started.connect(() => marea.opaqueCounts += 1)
                                child.proc.exited.connect(() => marea.opaqueCounts -= 1)
                            }
                        })
                    }
                }
            }
        }
    }
}

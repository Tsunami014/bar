import QtQuick
import Quickshell
import ".."
import "../sides/"
import "../modules/base/"

PanelWindow {
    id: bar
    anchors {
        top: true
        left: true
        right: true
    }

    property bool expanded: false
    exclusiveZone: Theme.barBaseSze
    implicitHeight: (expanded ? Theme.barSze-Theme.barBaseSze : Theme.barBaseSze)+Theme.barRound

    color: Theme.colTransparent

    Rectangle {
        anchors.fill: rect
        color: Theme.colBg

        // Expand on hover
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                bar.expanded = true
            }
            onExited: {
                bar.expanded = false
            }
        }
    }
    Rectangle {
        id: rect
        opacity: bar.expanded ? 1 : 0
        //Behavior on opacity { NumberAnimation { duration: 40 } }

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        height: bar.implicitHeight - Theme.barRound

        color: Theme.colBg

        Loader {
            anchors.fill: parent
            active: bar.expanded
            sourceComponent: Top {
                anchors.fill: parent
                color: Theme.colBg
            }
        }
    }
    Corner {
        anchors {
            top: rect.bottom
            left: rect.left
        }
    }
    Corner {
        anchors {
            top: rect.bottom
            right: rect.right
        }
        rx: 1
    }
}

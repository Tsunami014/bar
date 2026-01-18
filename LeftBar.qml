import QtQuick
import QtQuick.Layouts
import Quickshell
import "./modules/"

PanelWindow {
    id: bar
    anchors {
        top: true
        bottom: true
        left: true
    }

    property int barSze: 3

    property bool expanded: false
    exclusiveZone: Theme.barBaseSze
    implicitWidth: (expanded ? Theme.barSze*barSze : Theme.barBaseSze)+Theme.barRound

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
        Behavior on opacity { NumberAnimation { duration: 40 } }

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
        }
        width: bar.implicitWidth - Theme.barRound
        Behavior on width { NumberAnimation { duration: 30 } }

        color: Theme.colBg

        // Fill Me!
    }
    Corner {
        anchors {
            top: rect.top
            left: rect.right
        }
    }
    Corner {
        anchors {
            bottom: rect.bottom
            left: rect.right
        }
        ry: 1
    }
}


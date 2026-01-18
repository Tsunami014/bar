import QtQuick
import QtQuick.Layouts
import Quickshell
import "./modules/"

PanelWindow {
    id: rbar
    anchors {
        top: true
        bottom: true
        right: true
    }

    exclusiveZone: Theme.barBaseSze
    implicitWidth: Theme.barSze2

    color: Theme.colTransparent

    Rectangle {
        anchors.fill: rect
        color: Theme.colBg

        // Expand on hover
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            
            onEntered: {
                rect.width = Theme.barSze2
                rect.opacity = 1
            }
            
            onExited: {
                rect.width = Theme.barBaseSze
                rect.opacity = 0
            }
        }
    }
    Rectangle {
        id: rect
        opacity: 0
        Behavior on opacity { NumberAnimation { duration: 40 } }

        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
        }
        width: Theme.barBaseSze
        Behavior on width { NumberAnimation { duration: 30 } }

        color: Theme.colBg

        // Fill Me!
    }
}


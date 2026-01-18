import QtQuick
import QtQuick.Layouts
import Quickshell
import "./modules/"

PanelWindow {
    id: bbar
    anchors {
        left: true
        bottom: true
        right: true
    }

    property double scale: 1/5

    exclusiveZone: Theme.barBaseSze
    implicitHeight: Theme.barSze3

    color: Theme.colTransparent

    Rectangle {
        id: outer
        anchors {
            left: parent.left
            bottom: parent.bottom
            right: parent.right
        }
        height: Theme.barBaseSze
        color: Theme.colBg
    }
    Rectangle {
        id: rect
        anchors {
            left: parent.left
            bottom: parent.bottom
            right: parent.right
        }
        anchors.leftMargin: bbar.width*bbar.scale
        anchors.rightMargin: bbar.width*bbar.scale

        opacity: 0
        Behavior on opacity { NumberAnimation { duration: 40 } }
        height: Theme.barBaseSze
        Behavior on height { NumberAnimation { duration: 30 } }
        color: Theme.colBg

        topLeftRadius: 30
        topRightRadius: 30

        // Expand on hover
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            
            onEntered: {
                rect.height = Theme.barSze3
                rect.opacity = 1
            }
            
            onExited: {
                rect.height = Theme.barBaseSze
                rect.opacity = 0
            }
        }

        // Fill Me!
    }
}


import QtQuick
import QtQuick.Layouts
import Quickshell
import "./modules/"

PanelWindow {
    id: bar
    anchors {
        top: true
        bottom: true
        right: true
    }

    property double scale: 1/2
    property int barSze: 10

    exclusiveZone: Theme.barBaseSze
    implicitWidth: Theme.barBaseSze+Theme.barRound
    property bool expanded: (mouseAreaBar.containsMouse || mouseAreaRect.containsMouse) && wantExpand
    property bool wantExpand: false
    color: Theme.colTransparent

    Rectangle {
        id: fillr
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
        }
        width: Theme.barBaseSze
        color: Theme.colBg
    }

    Timer {
        id: collapseTimer;
        interval: 150;
        repeat: false;
        onTriggered: {
            if (!mouseAreaBar.containsMouse && !mouseAreaRect.containsMouse) {
                wantExpand = false
            }
        }
    }

    // Expand on hover
    MouseArea {
        id: mouseAreaBar
        anchors.fill: parent
        hoverEnabled: true
        
        onClicked: {
            bar.wantExpand = true
        }
        
        onExited: {
            if (!mouseAreaRect.containsMouse) {
                collapseTimer.start()
            }
        }
    }

    PanelWindow {
        id: rect
        anchors {
            top: true
            bottom: true
            right: true
        }
        margins {
            bottom: bar.height*bar.scale - Theme.barRound
            right: -Theme.barBaseSze
        }

        exclusiveZone: 0
        implicitWidth: bar.expanded != 0 ? Theme.barSze*bar.barSze + Theme.barRound : 0
        //Behavior on implicitWidth { NumberAnimation { duration: 20 } }
        color: "transparent"

        MouseArea {
            id: mouseAreaRect
            anchors.fill: parent
            hoverEnabled: true
            
            onClicked: {
                bar.wantExpand = true
            }
            
            onExited: {
                if (!mouseAreaBar.containsMouse) {
                    collapseTimer.start()
                }
            }
        }

        Corner {
            anchors {
                top: parent.top
                left: parent.left
            }
            rx: 1
        }
        Corner {
            anchors {
                bottom: parent.bottom
                right: parent.right
            }
            anchors.rightMargin: Theme.barRound
            rx: 1
        }

        Rectangle {
            anchors.fill: parent
            anchors.leftMargin: Theme.barRound
            anchors.bottomMargin: Theme.barRound

            opacity: bar.expanded != 0 ? 1:0
            //Behavior on opacity { NumberAnimation { duration: 40 } }
            bottomLeftRadius: 10
            color: Theme.colBg

            // Fill Me!
        }
    }
    Corner {
        anchors {
            top: fillr.top
            right: fillr.left
        }
        rx: 1
    }
    Corner {
        anchors {
            bottom: fillr.bottom
            right: fillr.left
        }
        rx: 1
        ry: 1
    }
}


import QtQuick
import QtQuick.Layouts
import Quickshell
import "./modules/"

PanelWindow {
    id: bar
    anchors {
        bottom: true
        left: true
        right: true
    }

    property double scale: 1/6
    property int barSze: 8

    exclusiveZone: Theme.barBaseSze
    implicitHeight: Theme.barBaseSze
    property bool expanded: (mouseAreaBar.containsMouse || mouseAreaRect.containsMouse) && wantExpand
    property bool wantExpand: false
    color: Theme.colBg

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
            bottom: true
            left: true
            right: true
        }
        margins {
            left: bar.width*bar.scale
            right: bar.width*bar.scale
            bottom: -Theme.barBaseSze
        }

        exclusiveZone: 0
        implicitHeight: bar.expanded!=0 ? Theme.barSze*bar.barSze : 0
        //Behavior on implicitHeight { NumberAnimation { duration: 20 } }
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
                bottom: parent.bottom
                left: parent.left
            }
            rx: 1
            ry: 1
            anchors.bottomMargin: Theme.barRound
        }
        Corner {
            anchors {
                bottom: parent.bottom
                right: parent.right
            }
            ry: 1
            anchors.bottomMargin: Theme.barRound
        }

        Rectangle {
            anchors.fill: parent

            anchors.leftMargin: Theme.barRound
            anchors.rightMargin: Theme.barRound

            topLeftRadius: 20
            topRightRadius: 20
            opacity: bar.expanded != 0 ? 1:0
            //Behavior on opacity { NumberAnimation { duration: 40 } }
            color: Theme.colBg

            // Fill Me!
        }
    }
}


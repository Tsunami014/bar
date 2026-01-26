import QtQuick
import Quickshell
import ".."
import "../sides/"
import "../modules/base/"

PanelWindow {
    id: bar
    anchors {
        bottom: true
        left: true
        right: true
    }

    property double scale: 1/6
    property int barSze: 3

    exclusiveZone: Theme.barBaseSze
    implicitHeight: Theme.barBaseSze + Theme.barRound
    color: Theme.colTransparent
    Rectangle {
        id: rect
        anchors.fill: parent
        anchors.topMargin: Theme.barRound
        color: Theme.colBg

        Loader {
            anchors.fill: parent
            active: marea.doexpand
            sourceComponent: PanelWindow {
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
                implicitHeight: Theme.barSze*bar.barSze
                color: "transparent"

                MouseOverlay { area: marea }

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

                Bottom {
                    color: Theme.colBg
                    anchors {
                        fill: parent
                        leftMargin: Theme.barRound
                        rightMargin: Theme.barRound
                        topMargin: Theme.barPadding
                        bottomMargin: Theme.barPadding
                    }

                    topLeftRadius: 20
                    topRightRadius: 20
                    opacity: marea.doexpand != 0 ? 1:0
                    //Behavior on opacity { NumberAnimation { duration: 40 } }
                }
            }
        }
        MOBase { id: marea }
    }
    Corner {
        anchors {
            bottom: rect.top
            left: rect.left
        }
        ry: 1
    }
    Corner {
        anchors {
            bottom: rect.top
            right: rect.right
        }
        rx: 1
        ry: 1
    }
}

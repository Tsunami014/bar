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

    exclusiveZone: Theme.barBaseSze
    implicitHeight: Theme.barBaseSze + Theme.barRound
    color: Theme.colTransparent
    Rectangle {
        id: rect
        anchors.fill: parent
        anchors.topMargin: Theme.barRound
        color: Theme.colBg

        Loader {
            active: marea.expand
            sourceComponent: PanelWindow {
                id: rect
                anchors {
                    bottom: true
                    left: true
                    right: true
                }

                exclusiveZone: 0
                implicitHeight: Theme.barSze*1.5
                color: "transparent"

                MouseOverlay { area: marea }

                Corner {
                    anchors {
                        bottom: parent.bottom
                        left: mainR.right
                        leftMargin: -1
                    }
                    ry: 1
                }
                Corner {
                    anchors {
                        bottom: parent.bottom
                        right: mainR.left
                        rightMargin: -1
                    }
                    rx: 1
                    ry: 1
                }

                Rectangle {
                    id: mainR
                    color: Theme.colBg
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        top: parent.top; bottom: parent.bottom
                    }
                    width: bot.childrenRect.width + Theme.barPadding*2

                    topLeftRadius: 20
                    topRightRadius: 20
                    opacity: marea.expand != 0 ? 1:0
                    //Behavior on opacity { NumberAnimation { duration: 40 } }

                    Bottom {
                        id: bot
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            top: parent.top; bottom: parent.bottom
                            margins: Theme.barPadding
                        }
                    }
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

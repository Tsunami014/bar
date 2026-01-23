import QtQuick
import Quickshell
import ".."
import "../sides/"
import "../modules/base/"

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

    Loader {
        anchors.fill: fillr
        active: marea.doexpand
        sourceComponent: Item { anchors.fill: parent; PanelWindow {
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
            implicitWidth: Theme.barSze*bar.barSze + Theme.barRound
            color: "transparent"

            MouseOverlay { area: marea }

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

            Right {
                anchors.fill: parent
                anchors.leftMargin: Theme.barRound
                anchors.bottomMargin: Theme.barRound
                color: Theme.colBg

                opacity: marea.doexpand != 0 ? 1:0
                //Behavior on opacity { NumberAnimation { duration: 40 } }
                bottomLeftRadius: 10
            }
        }
        Corner {
            anchors {
                top: parent.top
                right: parent.left
            }
            rx: 1
        }
        Corner {
            anchors {
                bottom: parent.bottom
                right: parent.left
            }
            rx: 1
            ry: 1
        }
    }}
    MOBase { id: marea }
}

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

        MOBase { id: marea }
    }

    Loader {
        anchors.fill: fillr
        active: marea.expand
        sourceComponent: Item { anchors.fill: parent; PanelWindow {
            id: rect
            anchors {
                top: true
                bottom: true
                right: true
            }

            exclusiveZone: 0
            implicitWidth: Theme.barSze*1.5
            color: Theme.colTransparent

            Right {
                id: rite
                anchors.fill: parent
                color: Theme.colTransparent

                opacity: marea.opaque ? 1:0
                //Behavior on opacity { NumberAnimation { duration: 40 } }
            }
            Repeater {
                model: rite.children

                MouseOverlay {
                    area: marea
                    anchors.fill: null

                    width: rect.width
                    height: modelData.implicitHeight
                    x: modelData.x
                    y: modelData.y
                }
            }
        }
    }}
}

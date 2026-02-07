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

    exclusiveZone: Theme.barBaseSze
    implicitHeight: (marea.expand ? Theme.barSze*0.8 : Theme.barBaseSze)+Theme.barRound

    color: Theme.colTransparent

    Rectangle {
        anchors.fill: rect
        color: Theme.colBg

        MOBase { id: marea }
    }
    Rectangle {
        id: rect
        opacity: marea.expand ? 1 : 0
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
            active: marea.expand
            sourceComponent: Top {
                anchors.fill: parent
                anchors.topMargin: Theme.barPadding/2
                anchors.bottomMargin: Theme.barPadding/2
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

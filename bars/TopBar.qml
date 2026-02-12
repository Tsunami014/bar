import QtQuick
import Quickshell
import Quickshell.Io
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

    exclusiveZone: marea.expand ? Theme.barSze*0.8 : Theme.barBaseSze
    implicitHeight: exclusiveZone

    color: Theme.colTransparent

    Rectangle {
        anchors.fill: rect
        color: Theme.colBg

        MOBase {
            id: marea
            allowhover: false
        }
    }
    Process {
        id: outerproc
        running: false
        property string cmd: ""
        command: ['sh', '-c', cmd]
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
        height: bar.implicitHeight

        color: Theme.colBg

        Loader {
            anchors.fill: parent
            active: marea.expand
            sourceComponent: Top {
                anchors.fill: parent
                anchors.topMargin: Theme.barPadding/2
                anchors.bottomMargin: Theme.barPadding/2
                color: Theme.colBg
                Component.onDestruction: {
                    outerproc.cmd = exitproc;
                    outerproc.running = true;
                }
            }
        }
    }
}

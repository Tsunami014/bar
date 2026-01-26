import QtQuick
import QtQuick.Layouts
import "../.."
import "../base/"

Rectangle {
    property color col: "#FFF"
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignHCenter
    implicitHeight: Theme.barSliderLen + Theme.barPadding*2
    color: Theme.colBg
    topLeftRadius: Theme.barRound*2.5
    bottomLeftRadius: Theme.barRound*2.5
    Slider {
        col: parent.col
        anchors {
            fill: parent
            margins: Theme.barPadding
        }
    }
    Corner {
        anchors {
            bottom: parent.top
            right: parent.right
            bottomMargin: -1
        }
        rx: 1
        ry: 1
    }
    Corner {
        anchors {
            top: parent.bottom
            right: parent.right
            topMargin: -1
        }
        rx: 1
    }
}

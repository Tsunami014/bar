import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../.."
import "../base/"

Rectangle {
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignHCenter
    implicitHeight: Theme.barSliderLen + Theme.barPadding*2
    color: Theme.colBg
    topLeftRadius: Theme.barRound*2.5
    bottomLeftRadius: Theme.barRound*2.5
    FancySlider {
        id: fslider
        col: parent.col
        fillcol: parent.fillcol
        handlecol: parent.handlecol
        anchors {
            fill: parent
            margins: Theme.barPadding
        }
    }
    property alias slider: fslider
    Component.onCompleted: {
        fslider.orientation = Qt.Vertical
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

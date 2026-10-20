import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../.."
import "../base/"

Rectangle {
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignHCenter
    implicitHeight: Theme.barSliderLen + Theme.barPadding*2 + Theme.barBorder*2
    color: Theme.colBg
    topLeftRadius: Theme.barRound*2
    bottomLeftRadius: Theme.barRound*2
    border.color: Theme.colBorder
    border.width: Theme.barBorder

    Rectangle {
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
        }
        color: Theme.colBg
        width: Theme.barBorder
    }

    FancySlider {
        id: fslider
        col: parent.col
        fillcol: parent.fillcol
        handlecol: parent.handlecol
        radius: width/2
        anchors {
            fill: parent
            margins: Theme.barPadding+Theme.barBorder
            rightMargin: 0
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
            bottomMargin: -Theme.barBorder
        }
        rx: 1
        ry: 1
    }
    Corner {
        anchors {
            top: parent.bottom
            right: parent.right
            topMargin: -Theme.barBorder
        }
        rx: 1
    }
}

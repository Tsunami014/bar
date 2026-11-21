import QtQuick
import QtQuick.Layouts
import "../base/"
import "../.."

Bubble { id: root
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignHCenter

    property string ico
    property double txtSize: 1.5
    item: Text {
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter

        text: root.ico
        color: root.col
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize*root.txtSize
        font.bold: true
    }

    property Component pop
    LeftPopup {
        id: basepop
        prioritiseHover: true
        touchdblstick: true
        Loader { sourceComponent: root.pop }
    }
    property alias popup: basepop
}

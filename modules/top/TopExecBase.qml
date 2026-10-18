import QtQuick
import QtQuick.Layouts
import "../base"
import "../.."

Bubble {
    id: b
    Layout.fillHeight: true
    implicitWidth: parent.height*1.5
    radius: Theme.borderRadius/2

    property string text: ""
    item: Text {
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        text: b.text
        color: b.col
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize*1.5
        font.bold: true
    }
}

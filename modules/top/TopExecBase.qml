import QtQuick
import QtQuick.Layouts
import "../base"
import "../.."

FancyBubble {
    id: b
    Layout.fillHeight: true
    implicitWidth: parent.height*1.5
    rad: Theme.borderRadius/2

    property color textColour: "#FFF"
    property string text: ""
    Text {
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        text: b.text
        color: b.textColour
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize*1.5
        font.bold: true
    }
}

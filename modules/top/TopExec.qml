import QtQuick
import QtQuick.Layouts
import "../all"
import "../.."

Execute {
    id: exe
    Layout.fillHeight: true
    implicitWidth: parent.height*1.5
    rad: Theme.borderRadius/2
    property color textColour: "#FFF"
    property string text: ""
    Text {
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        text: exe.text
        color: exe.textColour
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize*1.5
        font.bold: true
    }
}

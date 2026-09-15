import QtQuick
import QtQuick.Layouts
import "../all"
import "../.."

Execute {
    id: b
    Layout.preferredHeight: Theme.fontSize*2.5 + Theme.barPadding*2
    Layout.preferredWidth: Layout.preferredHeight

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

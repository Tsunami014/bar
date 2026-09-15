import QtQuick
import QtQuick.Layouts
import "../.."
import "../base/"

Bubble {
    id: root
    property string ico
    property string bottomtxt
    property Item topit
    item: ColumnLayout {
        id: cont
        spacing: Theme.barSpacing
    }
    Text {
        id: bottxtit
        Layout.alignment: Qt.AlignHCenter
        horizontalAlignment: Text.AlignHCenter
        text: ` ${ico}  ${bottomtxt} `
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
        color: root.col
    }
    Component.onCompleted: {
        if (topit) {
            topit.parent = cont
            bottxtit.parent = cont
        }
    }
}

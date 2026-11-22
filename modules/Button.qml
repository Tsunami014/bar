import QtQuick
import "base"
import ".."

Bubble { id: root
    property string text: ""
    property double txtSize: 1
    property bool bold: false

    item: Text {
        anchors.centerIn: parent
        text: root.text
        color: root.fg
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize*root.txtSize
        font.bold: root.bold
    }

    signal pressed()
    ClickArea { id: click; onPressed: root.pressed() }
}

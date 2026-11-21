import QtQuick
import "base"
import ".."

Bubble { id: root
    property string text: ""
    property double txtSize: 1

    item: Text {
        anchors.centerIn: parent
        text: root.text
        color: root.col
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize*root.txtSize
    }

    signal pressed()
    ClickArea { id: click; onPressed: root.pressed() }
}

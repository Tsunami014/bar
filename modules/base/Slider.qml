import QtQuick
import "../.."
Rectangle {
    property color col: "#FFF"
    border.color: Qt.darker(col, 1.2)
    border.width: Theme.borderWidth
    color: Qt.lighter(col, 1.2)
    radius: Theme.barRound*2
    implicitWidth: content.childrenRect.width + border.width
    implicitHeight: content.childrenRect.height + border.width

    property Item item
    Item {
        id: content
        anchors.fill: parent

        Component.onCompleted: {
            if (root.item) {
                root.item.parent = content
            }
        }
    }
}

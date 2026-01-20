import QtQuick
import "../.."
Rectangle {
    property color col: "#FFF"
    property int padding: 5
    property int spacing: 3

    border.color: Qt.lighter(col, 1.2)
    border.width: Theme.borderWidth
    radius: Theme.borderRadius
    color: Qt.rgba(
        border.color.r+0.3,
        border.color.g+0.3,
        border.color.b+0.3,
        0.25
    )
    implicitWidth: content.childrenRect.width + border.width + padding*2
    implicitHeight: content.childrenRect.height + border.width + padding*2

    Item {
        id: content
        anchors.fill: parent
        anchors.margins: padding
    }
    default property alias contentData: content.data
}

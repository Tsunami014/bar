import QtQuick
Rectangle {
    property color col: "#FFF"
    property int padding: 5
    property int spacing: 3

    border.color: Qt.lighter(col, 1.4)
    border.width: 2.5
    radius: 15
    color: Qt.rgba(
        border.color.r+0.2,
        border.color.g+0.2,
        border.color.b+0.2,
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

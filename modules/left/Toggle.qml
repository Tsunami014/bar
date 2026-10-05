import QtQuick
import "../.."

Rectangle {
    id: root

    property bool checked: false
    property color accent: Theme.colFg

    signal clicked()

    height: Theme.fontSize * 1.3
    width: height * 1.8
    radius: height / 2
    color: checked ? accent : Theme.colMuted2

    Behavior on color { ColorAnimation { duration: 120 } }

    Rectangle {
        height: parent.height - 4
        width: height
        radius: height / 2
        color: Theme.colFg
        anchors.verticalCenter: parent.verticalCenter
        x: root.checked ? parent.width - width - 2 : 2
        Behavior on x { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}

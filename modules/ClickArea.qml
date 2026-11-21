import QtQuick

Item {
    id: root
    anchors.fill: parent
    signal pressed()
    property bool mouse: true
    property bool touch: true

    MouseArea {
        anchors.fill: parent
        cursorShape: root.mouse? Qt.PointingHandCursor : null
        propagateComposedEvents: true

        onPressed: mouse => {
            if (mouse.source === Qt.MouseEventNotSynthesized? root.mouse : root.touch) {
                root.pressed()
            } else {
                mouse.accepted = false
            }
        }
    }
}

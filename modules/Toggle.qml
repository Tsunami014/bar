import QtQuick
import ".."
import "base"

Item {
    id: root

    property bool checked: false
    property color accent: Theme.colFg
    property var type: Theme.BublFill
    property int gap: 2

    signal pressed()

    height: Theme.fontSize * 1.4
    width: height * 1.8

    Bubble { id: track
        anchors.fill: parent

        type: root.type
        padding: 0
        shadowDrop: 2
        radius: height / 2

        col: root.checked ? root.accent : Theme.colMuted2

        Bubble { id: knob
            readonly property real inset: track.fullBordr + root.gap

            type: Theme.BublFlat
            padding: 0
            col: track.fg

            height: track.height - inset * 2
            width: height
            radius: height / 2
            anchors.verticalCenter: parent.verticalCenter

            x: root.checked ? track.width - width - inset : inset
            Behavior on x { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onPressed: root.pressed()
    }
}

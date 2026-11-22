import QtQuick
import QtQuick.Layouts
import "../.."
import "../base/"

Item {
    id: col
    property bool first: false
    property bool last: false
    property MOBase area: null
    property real minH: 0

    readonly property real pad: Theme.barSpacing
    readonly property real mid: pad/2 + Theme.barBorder
    readonly property real padL: first ? pad + Theme.barBorder : mid
    readonly property real padR: last ? pad + Theme.barBorder : mid
    readonly property real padT: Theme.barBorder + pad
    readonly property real padB: Theme.barBorder + pad
    readonly property real ownH: Theme.snap(slot.height + padT + padB)
    default property alias content: slot.data

    Layout.alignment: Qt.AlignBottom
    implicitWidth: Theme.snap(slot.width + padL + padR)
    implicitHeight: Math.max(ownH, minH)

    Item {
        id: slot
        anchors {
            bottom: parent.bottom; bottomMargin: col.padB
            left: parent.left; leftMargin: col.padL
        }
        width: childrenRect.width
        height: childrenRect.height
    }

    MouseOverlay { area: col.area; clickable: true; z: 100 }

    Corner {
        visible: col.first
        anchors { bottom: parent.bottom; right: parent.left; rightMargin: -Theme.barBorder }
        rx: 1
        ry: 1
    }
    Corner {
        visible: col.last
        anchors { bottom: parent.bottom; left: parent.right; leftMargin: -Theme.barBorder }
        ry: 1
    }
}

import QtQuick
import QtQuick.Layouts
import "../.."

Item { id: root
    Layout.fillWidth: true
    implicitWidth: txt.implicitWidth + sw.width + 8
    implicitHeight: Math.max(txt.implicitHeight, sw.height)

    property string title: "Title"
    property color col: Theme.colFg
    property bool checked: false
    property bool centre: false
    signal pressed()

    Txt { id: txt
        anchors.left: parent.left
        anchors.right: sw.left
        anchors.rightMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        horizontalAlignment: root.centre ? Text.AlignHCenter : Text.AlignLeft
        text: root.title
        col: root.col
    }

    Toggle { id: sw
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        checked: root.checked
        accent: root.col
        onPressed: root.pressed()
    }
}

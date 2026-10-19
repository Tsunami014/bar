import QtQuick
import QtQuick.Layouts
import "../.."

ColumnLayout {
    id: root
    property color col: Theme.colGreen
    property string title: ""
    property bool titleBold: false
    property real titleOpacity: 0.6
    property int titleSize: Theme.fontSize - 2
    property var rows: []  // [{ label, value }]
    property var footer: []  // same shape, shown under a divider
    spacing: 3

    component Rows: ColumnLayout {
        id: rowsRoot
        property var items: []
        property color tint
        spacing: 2

        Repeater {
            model: rowsRoot.items
            delegate: RowLayout {
                required property var modelData
                Layout.fillWidth: true
                spacing: 14

                Text {
                    text: modelData.label
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                    color: rowsRoot.tint
                    opacity: 0.6
                }
                Item { Layout.fillWidth: true }
                Text {
                    text: modelData.value
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                    color: rowsRoot.tint
                }
            }
        }
    }

    Text {
        visible: root.title !== ""
        Layout.alignment: Qt.AlignHCenter
        text: root.title
        font.family: Theme.fontFamily
        font.pixelSize: root.titleSize
        font.bold: root.titleBold
        color: root.col
        opacity: root.titleOpacity
    }

    Rows { Layout.fillWidth: true; items: root.rows; tint: root.col }

    Rectangle {
        visible: root.footer.length > 0
        Layout.fillWidth: true
        implicitHeight: 1
        color: root.col
        opacity: 0.25
    }

    Rows {
        visible: root.footer.length > 0
        Layout.fillWidth: true
        items: root.footer
        tint: root.col
    }
}

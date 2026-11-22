import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Bluetooth
import ".."
import "base"

ColumnLayout { id: root
    Layout.fillWidth: true
    spacing: 4

    property color col: Theme.colFg

    Repeater {
        model: Bluetooth.devices

        delegate: RowLayout {
            id: row
            property var device: modelData
            Layout.fillWidth: true
            spacing: 8

            IconImage {
                implicitSize: 18
                source: Quickshell.iconPath(row.device.icon, "bluetooth")
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 0
                Text {
                    Layout.fillWidth: true
                    text: row.device.name
                    color: root.col
                    elide: Text.ElideRight
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize*0.85
                }
                Text {
                    Layout.fillWidth: true
                    text: row.device.connected ? "Connected" : (row.device.paired ? "Paired" : "")
                    color: root.col
                    opacity: 0.6
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize*0.65
                }
            }

            Button {
                type: Theme.BublBorder
                col: root.col
                text: row.device.connected ? "Disconnect" : "Connect"
                txtSize: 0.65
                onPressed: row.device.connected ? row.device.disconnect() : row.device.connect()
            }

            Bubble { id: delbtn
                type: Theme.BublBorder
                col: Qt.tint(root.col, Theme.colRed)
                item: Text {
                    anchors.centerIn: parent
                    text: "󰆴"
                    color: delbtn.fg
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize*0.75
                }
                ClickArea { onPressed: row.device.forget() }
            }
        }
    }

    Text {
        visible: Bluetooth.devices.values.length === 0
        text: "No devices found"
        color: root.col
        opacity: 0.5
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize*0.8
    }
}

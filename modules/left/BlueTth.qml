import QtQuick
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Widgets
import Quickshell.Io
import "../.."
import "../base/"

LeftBubble {
    id: b

    col: Theme.colIndigo
    property color lightcol: Qt.rgba(col.r, col.g, col.b, 0.15)

    property bool btEnabled: Bluetooth.defaultAdapter && Bluetooth.defaultAdapter.enabled
    property int btConnectedCount: {
        let n = 0
        if (Bluetooth.devices && Bluetooth.devices.values)
            for (let i = 0; i < Bluetooth.devices.values.length; i++)
                if (Bluetooth.devices.values[i].connected) n++
        return n
    }

    item: Text {
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter

        text:
            b.btEnabled == 0? "󰂲" :
            b.btConnectedCount == 0? "" :
            "󰂱"
        color: b.col
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize*1.5
    }

    // Clears a soft rfkill block, then powers the adapter on once that's done.
    Process {
        id: rfkillUnblock
        command: ["rfkill", "unblock", "bluetooth"]
        onExited: {
            if (Bluetooth.defaultAdapter)
                Bluetooth.defaultAdapter.enabled = true
        }
    }

    Popup {
        Column {
            id: popupColumn
            width: 260
            spacing: 8

            // Header: title + power switch
            Item {
                width: parent.width
                height: 24

                Text {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Bluetooth"
                    color: b.col
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                    font.bold: true
                }

                Rectangle {
                    id: btSwitchTrack
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: Theme.fontSize*1.3
                    width: height*1.8
                    radius: height / 2
                    color: b.btEnabled ? b.col : Theme.colMuted2

                    Behavior on color { ColorAnimation { duration: 120 } }

                    Rectangle {
                        height: parent.height - 4
                        width: height
                        radius: height / 2
                        color: Theme.colFg
                        anchors.verticalCenter: parent.verticalCenter
                        x: b.btEnabled ? parent.width - width - 2 : 2
                        Behavior on x { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (!Bluetooth.defaultAdapter) return
                            if (Bluetooth.defaultAdapter.enabled) {
                                Bluetooth.defaultAdapter.enabled = false
                            } else {
                                rfkillUnblock.running = true
                            }
                        }
                    }
                }
            }

            // Scan for devices switch
            Item {
                width: parent.width
                height: 24

                Text {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Scan"
                    color: b.col
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                    font.bold: true
                }

                Rectangle {
                    id: scanSwitchTrack
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: Theme.fontSize*1.3
                    width: height*1.8
                    radius: height / 2
                    property bool on: b.btEnabled && Bluetooth.defaultAdapter && Bluetooth.defaultAdapter.discovering
                    color: on ? b.col : Theme.colMuted2

                    Behavior on color { ColorAnimation { duration: 120 } }

                    Rectangle {
                        height: parent.height - 4
                        width: height
                        radius: height / 2
                        color: Theme.colFg
                        anchors.verticalCenter: parent.verticalCenter
                        x: scanSwitchTrack.on ? parent.width - width - 2 : 2
                        Behavior on x { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (b.btEnabled && Bluetooth.defaultAdapter) {
                                Bluetooth.defaultAdapter.discovering = !Bluetooth.defaultAdapter.discovering
                            }
                        }
                    }
                }
            }

            // Device list
            Column {
                width: parent.width
                spacing: 4

                Repeater {
                    model: Bluetooth.devices

                    delegate: Item {
                        width: popupColumn.width
                        height: 36

                        property var device: modelData

                        IconImage {
                            id: devIcon
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            implicitSize: 18
                            source: Quickshell.iconPath(device.icon, "bluetooth")
                        }

                        Column {
                            anchors.left: devIcon.right
                            anchors.leftMargin: 8
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                text: device.name
                                color: b.col
                                elide: Text.ElideRight
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSize*0.85
                            }
                            Text {
                                text: device.connected ? "Connected" : (device.paired ? "Paired" : "")
                                color: b.col
                                opacity: 0.6
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSize*0.65
                            }
                        }

                        Row {
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            height: parent.height * (2/3)
                            spacing: 4

                            Rectangle {
                                width: connLabel.width + parent.height - connLabel.height
                                height: parent.height
                                radius: Theme.barRound
                                color: b.lightcol

                                Text {
                                    id: connLabel
                                    anchors.centerIn: parent
                                    text: device.connected ? "Disconnect" : "Connect"
                                    color: b.col
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontSize*0.65
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: device.connected ? device.disconnect() : device.connect()
                                }
                            }

                            Rectangle {
                                height: parent.height
                                width: height
                                radius: Theme.barRound
                                color: b.lightcol

                                Text {
                                    anchors.centerIn: parent
                                    text: "󰆴"
                                    color: b.col
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontSize*0.75
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: device.forget()
                                }
                            }
                        }
                    }
                }

                Text {
                    visible: Bluetooth.devices.values.length === 0
                    text: "No devices found"
                    color: b.col
                    opacity: 0.5
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize*0.8
                }
            }

            // Settings button
            Rectangle {
                width: parent.width
                height: 28
                radius: Theme.barRound
                color: b.lightcol

                Text {
                    anchors.centerIn: parent
                    text: "Bluetooth Settings"
                    color: b.col
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: click.running = true
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        Process {
            id: click
            command: ["blueman-manager"]
        }
        onClicked: click.running = true
    }
}

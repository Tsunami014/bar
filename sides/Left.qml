import QtQuick
import QtQuick.Layouts
import ".."
import "../components"
import "../modules"
import "../modules/left"

Rectangle {
    ColumnLayout {
        id: top
        anchors {
            left: parent.left; right: parent.right
            top: parent.top
        }
        spacing: Theme.barSpacing

        Execute {
            Layout.fillWidth: true
            implicitHeight: parent.width
            col1: Theme.colIndigo
            col2: Theme.colPurple
            cmd: ["sh", "-c", "$EXECUTE"]
        }
        LeftBubble {
            col: Theme.colOrange
            ico: Clock.format(Clock.ico+"\nhh\nmm")
            txtSize: 1.3
            pop: Txt { col: Theme.colOrange; text:
                Clock.format("h:mm:ss AP\nddd d MMM yyyy\ndd/MM/yy\nt")
            }
        }
        LeftBubble { id: wifi
            col: Theme.colPurple
            ico: Wifi.ico
            pop: ColumnLayout {
                spacing: 8

                TitleSwitch { col: wifi.col
                    centre: true
                    title: Wifi.enabled ? (
                        Wifi.name + (
                            Wifi.linked ? "\n"+Wifi.strength+"% strength" : ""
                        )
                    ) : "-"

                    checked: Wifi.enabled
                    onPressed: Wifi.toggle()
                }
                Txt { col: wifi.col
                    Layout.fillWidth: true
                    font.bold: false
                    text: Wifi.wifiText
                }
                Button { col: wifi.col
                    Layout.fillWidth: true
                    text: Wifi.scanning ? "Scanning..." : "Rescan Wifi"
                    onPressed: Wifi.rescan()
                }
                Button { col: wifi.col
                    Layout.fillWidth: true
                    text: "Wifi Settings"
                    onPressed: Wifi.open()
                }
            }
            popup.onExpandChanged: if (popup.expand) Wifi.refreshDetails()
            ClickArea { onPressed: Wifi.open(); touch: false }
        }
        LeftBubble { id: bltth
            col: Theme.colIndigo
            ico: BlueTth.ico
            pop: ColumnLayout {
                spacing: 8

                TitleSwitch { col: bltth.col
                    title: "Bluetooth"
                    checked: BlueTth.enabled
                    onPressed: BlueTth.toggle()
                }
                TitleSwitch { col: bltth.col
                    title: "Scan"
                    checked: BlueTth.scanning
                    onPressed: BlueTth.toggleScan()
                }
                BlueTthDevices { col: bltth.col }
                Button { col: bltth.col
                    Layout.fillWidth: true
                    text: "Settings"
                    txtSize: 0.8
                    onPressed: BlueTth.open()
                }
            }
            ClickArea { onPressed: BlueTth.open(); touch: false }
        }
    }
    ColumnLayout {
        id: middle
        anchors {
            left: parent.left; right: parent.right
            top: top.bottom; bottom: bottom.top
            topMargin: Theme.barSpacing
            bottomMargin: Theme.barSpacing
        }
        spacing: Theme.barSpacing

        Tray {}
    }
    ColumnLayout {
        id: bottom
        anchors {
            left: parent.left; right: parent.right
            bottom: parent.bottom
        }
        spacing: Theme.barSpacing

        Workspaces {}
        LeftBubble {
            col: Battery.col
            ico: Battery.ico
            pop: Txt { col: Battery.col; text:
                Battery.batChargeStatus + "\n" + Battery.batteryLevel + "%\n" + Battery.batteryExtra
            }
        }
        ThemeButton { Layout.fillWidth: true }
    }
}

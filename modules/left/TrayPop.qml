import QtQuick
import QtQuick.Layouts
import Quickshell
import "../.."
import "../base/"

Popup {
    id: pop
    allowhover: 1
    ColumnLayout {
        Text {
            text: modelData.title || modelData.tooltipTitle
            color: b.col
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize*1.2
            font.bold: true
        }
        Repeater {
            model: menuItems.children
            Loader {
                id: main
                Layout.fillWidth: true
                sourceComponent: modelData.isSeparator ? dividerComponent : itemComponent

                property color col: modelData.enabled ? Theme.colFg : Theme.colMuted1
                property color lightcol: Qt.rgba(col.r, col.g, col.b, 0.15)

                Component {
                    id: dividerComponent
                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: main.col
                    }
                }

                Component {
                    id: itemComponent
                    Rectangle {
                        Layout.fillWidth: true
                        implicitWidth: rowLayout2.implicitWidth + 6
                        implicitHeight: rowLayout2.implicitHeight + 6
                        radius: height / 2
                        color: main.lightcol

                        RowLayout {
                            id: rowLayout2
                            anchors.fill: parent
                            anchors.margins: 3
                            spacing: 6

                            Rectangle {
                                visible: !!modelData.icon
                                Layout.preferredWidth: Theme.fontSize * 1.3
                                Layout.preferredHeight: Theme.fontSize * 1.3
                                radius: width / 2
                                color: Theme.colFg

                                Image {
                                    anchors.centerIn: parent
                                    width: Theme.fontSize * 0.9
                                    height: Theme.fontSize * 0.9
                                    sourceSize.width: width * Screen.devicePixelRatio
                                    sourceSize.height: height * Screen.devicePixelRatio
                                    source: modelData.icon
                                    fillMode: Image.PreserveAspectFit
                                }
                            }
                            Text {
                                text: modelData.text
                                color: main.col
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSize * 0.9
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                modelData.triggered()
                                pop.expandCounts = 0
                                pop.forceShut()
                            }
                        }
                    }
                }
            }
        }
    }

    QsMenuOpener {
        id: menuItems
        menu: modelData.menu
    }
}

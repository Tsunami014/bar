import QtQuick
import QtQuick.Layouts
import Quickshell
import ".."
import "../.."
import "../base/"

LeftPopup {
    id: pop
    allowhover: 1
    externalPress: true
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
                Layout.bottomMargin: modelData.isSeparator? 0 : Theme.barBorder
                sourceComponent: modelData.isSeparator? dividerComponent : itemComponent

                property color col: modelData.enabled? Theme.colPrimary : Theme.colMuted1

                Component {
                    id: dividerComponent
                    Rectangle {
                        height: 3
                        radius: height / 2
                        color: main.col
                    }
                }

                Component {
                    id: itemComponent
                    Button {
                        type: Theme.BublDark
                        implicitWidth: rowLayout2.implicitWidth + Theme.barBorder * 2
                        implicitHeight: rowLayout2.implicitHeight + Theme.barBorder * 2
                        radius: height / 2
                        col: main.col

                        RowLayout {
                            id: rowLayout2
                            anchors.centerIn: parent
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

                        onPressed: {
                            modelData.triggered()
                            pop.expandCounts = 0
                            pop.forceShut()
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

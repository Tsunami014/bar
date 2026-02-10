import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import "../.."
import "../base/"

ColumnLayout {
    id: lay
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignHCenter

    Repeater {
        model: SystemTray.items

        LeftBubble {
            id: b
            col: modelData.status == Status.NeedsAttention ? Theme.colRed :
                modelData.status == Status.Active ? Theme.colFg : Theme.colMuted2
            item: Image {
                anchors { left: parent.left; right: parent.right }
                source: modelData.icon
                fillMode: Image.PreserveAspectFit
            }
            Loader {
                anchors.fill: parent
                active: modelData.hasMenu
                sourceComponent: Popup {
                    id: pop
                    allowhover: false
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
                            Bubble {
                                id: b2
                                radius: Theme.borderRadius/2
                                col: modelData.isSeparator ? "transparent" :
                                    modelData.enabled ? Theme.colFg : Theme.colMuted1
                                item: RowLayout{
                                    Image {
                                        source: modelData.icon
                                        sourceSize.height: Theme.fontSize*0.9
                                        sourceSize.width: height
                                    }
                                    Text {
                                        text: modelData.isSeparator ? "───" : modelData.text
                                        color: b2.col
                                        font.family: Theme.fontFamily
                                        font.pixelSize: Theme.fontSize*0.9
                                    }
                                }
                                Loader {
                                    anchors.fill: parent
                                    active: !modelData.isSeparator
                                    sourceComponent: MouseArea {
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
                    QsMenuOpener {
                        id: menuItems
                        menu: modelData.menu
                    }
                }
            }
            MouseOverlay {
                anchors.fill: parent
                acceptedButtons: Qt.RightButton
                cursorShape: Qt.PointingHandCursor
                onPressed: modelData.activate()
                onWheel: wheel => modelData.scroll(wheel.angleDelta.y, false)
            }
        }
    }
}

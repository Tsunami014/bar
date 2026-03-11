import QtQuick
import Quickshell
import ".."
import "../sides/"
import "../modules/base/"
import "../modules/bottom/"

PanelWindow {
    id: bar
    anchors {
        bottom: true
        left: true
        right: true
    }

    property double scale: 1/6

    exclusiveZone: Theme.barBaseSze
    implicitHeight: Theme.barBaseSze
    color: Theme.colTransparent
    Rectangle {
        id: rect
        anchors.fill: parent
        color: Theme.colBg

        Loader {
            active: marea.expand
            sourceComponent: PanelWindow {
                id: rect
                anchors {
                    bottom: true
                    left: true
                    right: true
                }
                margins.left: (
                    (
                        Screen.desktopAvailableWidth -
                        (Theme.barBaseSze + Theme.barRound) - // RightBar.implicitWidth
                        (Theme.barSze*1.5) // LeftBar.implicitWidth
                    ) - (mainR.width+Theme.barRound*2)
                )/2
                margins.right: margins.left

                exclusiveZone: 0
                implicitHeight: (
                    Theme.barBottomBubbleSze*bot.rows +
                    Theme.barSpacing*2*(bot.rows-1) +
                    Theme.barPadding*3
                )
                color: "transparent"

                Corner {
                    anchors {
                        bottom: parent.bottom
                        left: mainR.right
                        leftMargin: -1
                    }
                    ry: 1
                }
                Corner {
                    anchors {
                        bottom: parent.bottom
                        right: mainR.left
                        rightMargin: -1
                    }
                    rx: 1
                    ry: 1
                }

                Rectangle {
                    id: mainR
                    color: Theme.colBg
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        top: parent.top; bottom: parent.bottom
                    }
                    width: bot.width + Theme.barPadding*4

                    topLeftRadius: 20
                    topRightRadius: 20
                    opacity: marea.opaque ? 1:0
                    //Behavior on opacity { NumberAnimation { duration: 40 } }

                    Bottom {
                        id: bot
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            top: parent.top; bottom: parent.bottom
                            margins: Theme.barPadding*2
                        }
                        Component.onCompleted: {
                            children.forEach(child => {
                                if (child.proc) {
                                    child.proc.started.connect(function() {
                                        marea.opaqueCounts += 1
                                    })
                                    child.proc.exited.connect(function() {
                                        marea.opaqueCounts -= 1
                                    })
                                }
                            })
                        }
                        FancyBubble {
                            col1: Theme.colOrange
                            col2: Theme.colPurple
                            implicitWidth: Theme.barBottomBubbleSze
                            implicitHeight: implicitWidth
                            Text {
                                anchors.centerIn: parent
                                horizontalAlignment: Text.AlignHCenter
                                text: ""
                                color: "#FFF"
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSize*1.5
                                font.bold: true
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onPressed: {
                                    marea.press()
                                }
                            }
                        }
                    }

                    MouseOverlay { area: marea }
                }
            }
        }
        MOBase {
            id: marea
            allowhover: false
        }
    }
}

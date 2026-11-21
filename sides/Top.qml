import QtQuick
import QtQuick.Layouts
import ".."
import "../components/"
import "../modules/all/"
import "../modules/top/"

Rectangle {
    property string exitproc: "kill -CONT $(pidof swayidle)"
    // left
    RowLayout {
        id: tleft
        anchors {
            left: parent.left
            leftMargin: Theme.barSpacing
            top: parent.top
            bottom: parent.bottom
        }
        spacing: Theme.barSpacing
        Lock { Layout.fillHeight: true
            text: run ? "" : ""
            runcol: Theme.colPurple
        }
        TogglCmdBtn { Layout.fillHeight: true
            text: run ? "󰛐" : ""
            txtSize: 1.5
            runcol: Theme.colOrange
            cmd: Utils.killIdleStart; stopcmd: Utils.killIdleStop
        }
    }
    // center
    RowLayout {
        id: tcentre
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: Theme.snap((Theme.leftBarWidth - Theme.rightBarWidth) / -2)
        height: parent.height - 6
        spacing: Theme.barSpacing*2

        Txt {
            property string title: niri.focusedWindow?.title ?? ""
            property int mxlen: 55
            text: title.length > mxlen
                ? title.substring(0, mxlen) + "…"
                : title
            font.bold: false
        }
    }
    // right
    RowLayout {
        id: tright
        anchors {
            right: parent.right
            rightMargin: Theme.barSpacing
            top: parent.top
            bottom: parent.bottom
        }
        spacing: Theme.barSpacing
        CmdBtn { Layout.fillHeight: true
            text: run ? "󰆡" : "󰢆"
            runcol: Theme.colYellow
            cmd: Utils.noAutoRot
        }
        CmdBtn { Layout.fillHeight: true
            text: "󰌌"
            runcol: Theme.colBlue
            cmd: Utils.popupKbd
        }
        CmdBtn { Layout.fillHeight: true
            text: "󰓾"
            runcol: Theme.colGreen
            cmd: Utils.touchDebug
        }
    }
    // Left side
    TopFillLay {
        anchors.left: tleft.right
        anchors.right: tcentre.left
        TopFill {
            text: ""
            col: Theme.colSecondary
            cmd: ["niri", "msg", "action", "focus-column-or-monitor-left"]
        }
    }
    // Right side
    TopFillLay {
        anchors.left: tcentre.right
        anchors.right: tright.left
        TopFill {
            text: ""
            col: Theme.colSecondary
            cmd: ["niri", "msg", "action", "focus-column-or-monitor-right"]
        }
    }
}

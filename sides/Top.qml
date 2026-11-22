import QtQuick
import QtQuick.Layouts
import ".."
import "../components/"
import "../modules/"
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
            bottomMargin: Theme.barPadding/2
        }
        spacing: Theme.barSpacing
        Lock { Layout.fillHeight: true
            type: Theme.BublDark
            text: run ? "" : ""
            runcol: Theme.colPurple
        }
        TogglCmdBtn { Layout.fillHeight: true
            type: Theme.BublDark
            text: run ? "󰛐" : ""
            txtSize: 1.5
            runcol: Theme.colOrange
            cmd: Cmds.killIdleStart; stopcmd: Cmds.killIdleStop
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
            bottomMargin: Theme.barPadding/2
        }
        spacing: Theme.barSpacing
        CmdBtn { Layout.fillHeight: true
            type: Theme.BublDark
            text: run ? "󰆡" : "󰢆"
            runcol: Theme.colYellow
            cmd: Cmds.noAutoRot
        }
        CmdBtn { Layout.fillHeight: true
            type: Theme.BublDark
            text: "󰌌"
            runcol: Theme.colBlue
            cmd: Cmds.popupKbd
        }
        CmdBtn { Layout.fillHeight: true
            type: Theme.BublDark
            text: "󰓾"
            runcol: Theme.colGreen
            cmd: Cmds.touchDebug
        }
    }
    // Left side
    TopFillLay {
        anchors.left: tleft.right
        anchors.right: tcentre.left
        TopFill {
            text: ""
            cmd: ["niri", "msg", "action", "focus-column-or-monitor-left"]
        }
    }
    // Right side
    TopFillLay {
        anchors.left: tcentre.right
        anchors.right: tright.left
        TopFill {
            text: ""
            cmd: ["niri", "msg", "action", "focus-column-or-monitor-right"]
        }
    }
}

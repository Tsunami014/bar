import QtQuick
import QtQuick.Layouts
import ".."
import "../modules/all/"
import "../modules/bottom/"

RowLayout {
    id: top
    spacing: Theme.barSpacing*2

    Execute {
        Layout.fillHeight: true
        implicitWidth: parent.height
        col1: Theme.colIndigo
        col2: Theme.colPurple
        cmd: ["sh", "-c", "$EXECUTE"]
    }
    Exec {
        text: "󰕮"
        col1: Theme.colGreen
        col2: Theme.colBlue
        cmd: ["niri", "msg", "action", "open-overview"]
    }
    Exec {
        text: ""
        col1: Theme.colRed
        col2: Theme.colYellow
        cmd: ["niri", "msg", "action", "close-window"]
    }
    Exec {
        text: ""
        col1: Theme.colBlue
        col2: Theme.colFg
        cmd: ["niri", "msg", "action", "move-column-left-or-to-monitor-left"]
    }
    Exec {
        text: ""
        col1: Theme.colOrange
        col2: Theme.colIndigo
        cmd: ["niri", "msg", "action", "move-column-right-or-to-monitor-right"]
    }
    Exec {
        text: ""
        col1: Theme.colGreen
        col2: Theme.colRed
        cmd: ["niri", "msg", "action", "move-window-up-or-to-workspace-up"]
    }
    Exec {
        text: ""
        col1: Theme.colPurple
        col2: Theme.colYellow
        cmd: ["niri", "msg", "action", "move-window-down-or-to-workspace-down"]
    }
    Exec {
        text: ""
        col1: Theme.colMuted2
        col2: Theme.colIndigo
        cmd: ["niri", "msg", "action", "center-column"]
    }
    Exec {
        text: "󰊓"
        col1: Theme.colGreen
        col2: Theme.colYellow
        cmd: ["niri", "msg", "action", "maximize-column"]
    }
}

import QtQuick
import QtQuick.Layouts
import ".."
import "../modules/all/"
import "../modules/bottom/"
//   
//   

GridLayout {
    id: top
    columns: 7
    rowSpacing: Theme.barSpacing*2
    columnSpacing: rowSpacing

    property int rows: 2

    Execute {
        Layout.fillHeight: true
        implicitWidth: Theme.barBottomBubbleSze
        col1: Theme.colIndigo
        col2: Theme.colPurple
        cmd: ["sh", "-c", "$EXECUTE"]
    }
    Exec {
        text: ""
        col1: Theme.colBlue
        col2: Theme.colFg
        cmd: ["niri", "msg", "action", "focus-column-or-monitor-left"]
    }
    Exec {
        text: ""
        col1: Theme.colOrange
        col2: Theme.colIndigo
        cmd: ["niri", "msg", "action", "focus-column-or-monitor-right"]
    }
    Exec {
        text: ""
        col1: Theme.colGreen
        col2: Theme.colRed
        cmd: ["niri", "msg", "action", "focus-window-or-workspace-up"]
    }
    Exec {
        text: ""
        col1: Theme.colPurple
        col2: Theme.colYellow
        cmd: ["niri", "msg", "action", "focus-window-or-workspace-down"]
    }
    Exec {
        text: "󰊓"
        col1: Theme.colGreen
        col2: Theme.colYellow
        cmd: ["niri", "msg", "action", "maximize-column"]
    }
    Exec {
        text: ""
        col1: Theme.colRed
        col2: Theme.colYellow
        cmd: ["niri", "msg", "action", "close-window"]
    }

    Exec {
        Layout.column: 0
        Layout.row: 1
        text: "󰕮"
        col1: Theme.colGreen
        col2: Theme.colBlue
        cmd: ["niri", "msg", "action", "open-overview"]
    }
    Exec {
        text: ""
        col2: Theme.colBlue
        col1: Theme.colFg
        cmd: ["niri", "msg", "action", "move-column-left-or-to-monitor-left"]
    }
    Exec {
        text: ""
        col2: Theme.colOrange
        col1: Theme.colIndigo
        cmd: ["niri", "msg", "action", "move-column-right-or-to-monitor-right"]
    }
    Exec {
        text: ""
        col2: Theme.colGreen
        col1: Theme.colRed
        cmd: ["niri", "msg", "action", "move-window-up-or-to-workspace-up"]
    }
    Exec {
        text: ""
        col2: Theme.colPurple
        col1: Theme.colYellow
        cmd: ["niri", "msg", "action", "move-window-down-or-to-workspace-down"]
    }
    Exec {
        text: ""
        col1: Theme.colMuted2
        col2: Theme.colIndigo
        cmd: ["niri", "msg", "action", "center-column"]
    }
}

import Quickshell
import "./sides/"

PanelWindow {
    id: bar
    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: Theme.barSze
    color: Theme.colTransparent

    Top{}
}

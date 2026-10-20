import Quickshell
import QtQuick
import QtQuick.Layouts
import ".."
import "../modules/right/"

ColumnLayout {
    id: middle
    anchors.fill: parent

    property list<Region> maskRegions: [
        Region { item: bright },
        Region { item: vol },
    ]

    Item {
        Layout.fillHeight: true
        Layout.verticalStretchFactor: 3
    }
    Brightness{ id: bright }
    Item {
        Layout.fillHeight: true
        Layout.verticalStretchFactor: 1
    }
    Volume{ id: vol }
    Item {
        Layout.fillHeight: true
        Layout.verticalStretchFactor: 3
    }
}

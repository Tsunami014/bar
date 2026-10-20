import Quickshell
import QtQuick
import QtQuick.Layouts
import ".."
import "../modules/right/"

ColumnLayout {
    id: middle
    anchors.fill: parent
    spacing: 0

    property list<Region> maskRegions: [
        Region { item: bright },
        Region { item: vol },
    ]

    // free space is split 3:1:3
    property real unit: (height - bright.height - vol.height) / 7

    Item { Layout.preferredHeight: Theme.snap(middle.unit * 3) }
    Brightness{ id: bright }
    Item { Layout.preferredHeight: Theme.snap(middle.unit) }
    Volume{ id: vol }
    Item { Layout.fillHeight: true }
}

import Quickshell
import QtQuick
import QtQuick.Layouts
import ".."
import "../components"
import "../modules/right"

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
    RightSlider { id: bright
        slider.col: Theme.colYellow
        slider.fillcol: Theme.colRed
        slider.handlecol: Theme.colOrange

        slider.ready: Brightness.ready
        slider.value: Brightness.value
        slider.onDragged: v => Brightness.set(v)
        slider.text: slider.showValue ? slider.val : Brightness.ico

        Timer {
            interval: 300
            repeat: true
            running: Brightness.ready && !parent.slider.dragging
            onTriggered: Brightness.refresh()
        }
    }
    Item { Layout.preferredHeight: Theme.snap(middle.unit) }
    RightSlider { id: vol
        slider.col: Theme.colIndigo
        slider.fillcol: Theme.colBlue
        slider.handlecol: Theme.colBlue

        slider.ready: Volume.ready
        slider.value: Volume.val
        slider.onDragged: v => Volume.set(v)
        slider.text: slider.showValue ? Volume.val : Volume.ico
    }
    Item { Layout.fillHeight: true }
}

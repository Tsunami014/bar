import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import ".."
import "../modules/base/"
import "../modules/bottom/"

Item {
    id: top
    property bool full: false
    property MOBase area: null
    property real rad: 20

    readonly property var columns: [weatherCol, cpuCol, memCol, diskCol]
    readonly property var modules: [weather, cpu, memory, disk]

    // collapsed columns all share the tallest height so their tops line up exactly
    readonly property real baseH: full ? 0 : Math.max(
        weatherCol.ownH, cpuCol.ownH, memCol.ownH, diskCol.ownH
    )

    readonly property string outline: buildOutline()

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    function buildOutline() {
        const cs = columns
        const h = Theme.barBorder/2
        const R = rad - h
        const H = row.height

        // between bubbles the outline is barSpacing from the taller bubble and barBorder from the
        // shorter one, so from the column boundary it shifts by k towards the shorter bubble
        const k = (Theme.barBorder - Theme.barSpacing)/2

        // x of each column boundary (the outer sides are placed so they come out inside the bar)
        // y of each column top, with the bottom as a virtual column at both ends so the
        // outer sides are just steps like any other
        const xs = [cs[0].x + h - k, ...cs.slice(1).map(c => c.x), cs[cs.length - 1].x + cs[cs.length - 1].width - h + k]
        const ys = [H, ...cs.map(c => c.y + h), H]

        let d = `M ${xs[0] + k} ${H}`

        for (let i = 0; i < xs.length; i++) {
            const x = xs[i]
            const ya = ys[i]
            const yn = ys[i + 1]
            const r = Math.min(R, Math.abs(ya - yn))

            if (Math.abs(ya - yn) < 0.01) {
                continue
            } else if (yn < ya) {
                // next one is taller, go up its left side
                d += ` L ${x + k} ${ya} L ${x + k} ${yn + r}`
                d += ` A ${r} ${r} 0 0 1 ${x + k + r} ${yn}`
            } else {
                // this one is taller, round off and come down its right side
                d += ` L ${x - k - r} ${ya} A ${r} ${r} 0 0 1 ${x - k} ${ya + r}`
                d += ` L ${x - k} ${yn}`
            }
        }
        return d
    }

    Shape {
        width: row.width
        height: row.height
        layer.enabled: true
        layer.samples: 4

        ShapePath {
            fillColor: Theme.colBg
            strokeColor: Theme.colBorder
            strokeWidth: Theme.barBorder
            joinStyle: ShapePath.MiterJoin
            capStyle: ShapePath.FlatCap
            PathSvg { path: top.outline }
        }
    }

    component Col: Item {
        id: col
        property bool first: false
        property bool last: false
        property MOBase area: null
        property real minH: 0

        // bubbles are barSpacing from the outline on the outer sides and top, and
        // barSpacing + 2*barBorder apart, split evenly over the column boundary
        readonly property real pad: Theme.barSpacing
        readonly property real mid: pad/2 + Theme.barBorder
        readonly property real padL: first ? pad + Theme.barBorder : mid
        readonly property real padR: last ? pad + Theme.barBorder : mid
        readonly property real ownH: Theme.snap(slot.height + Theme.barBorder + pad)
        default property alias content: slot.data

        Layout.alignment: Qt.AlignBottom
        implicitWidth: Theme.snap(slot.width + padL + padR)
        implicitHeight: Math.max(ownH, minH)

        Item {
            id: slot
            anchors { bottom: parent.bottom; left: parent.left; leftMargin: col.padL }
            width: childrenRect.width
            height: childrenRect.height
        }

        MouseOverlay { area: col.area; clickable: true; z: 100 }

        Corner {
            visible: col.first
            anchors { bottom: parent.bottom; right: parent.left; rightMargin: -Theme.barBorder }
            rx: 1
            ry: 1
        }
        Corner {
            visible: col.last
            anchors { bottom: parent.bottom; left: parent.right; leftMargin: -Theme.barBorder }
            ry: 1
        }
    }

    RowLayout {
        id: row
        spacing: 0

        Col {
            id: weatherCol
            minH: top.baseH
            first: true
            area: top.area
            Weather { id: weather; full: top.full }
        }
        Col {
            id: cpuCol
            minH: top.baseH
            area: top.area
            Cpu { id: cpu; full: top.full }
        }
        Col {
            id: memCol
            minH: top.baseH
            area: top.area
            Memory { id: memory; full: top.full }
        }
        Col {
            id: diskCol
            minH: top.baseH
            last: true
            area: top.area
            Disk { id: disk; full: top.full }
        }
    }
}

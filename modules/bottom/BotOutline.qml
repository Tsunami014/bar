import QtQuick
import QtQuick.Shapes
import "../.."

Shape {
    id: root
    property var columns: []
    property real rad: 20

    readonly property string outline: buildOutline()

    layer.enabled: true
    layer.samples: 4

    function buildOutline() {
        const cs = columns
        const h = Theme.barBorder/2
        const R = rad - h
        const H = height

        const k = (Theme.barBorder - Theme.barSpacing)/2

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

    ShapePath {
        fillColor: Theme.colBg
        strokeColor: Theme.colBorder
        strokeWidth: Theme.barBorder
        joinStyle: ShapePath.MiterJoin
        capStyle: ShapePath.FlatCap
        PathSvg { path: root.outline }
    }
}

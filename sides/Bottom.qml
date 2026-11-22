import QtQuick
import QtQuick.Layouts
import ".."
import "../components"
import "../modules/base"
import "../modules/bottom"

Item {
    id: top
    property bool full: false
    property MOBase area: null

    readonly property var columns: [weatherCol, cpuCol, memCol, diskCol]
    readonly property var modules: [weatherbbl, cpubbl, memorybbl, diskbbl]

    // collapsed columns all share the tallest height so their tops line up exactly
    readonly property real baseH: full ? 0 : Math.max(
        weatherCol.ownH, cpuCol.ownH, memCol.ownH, diskCol.ownH
    )

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    BotOutline {
        columns: top.columns
        width: row.width
        height: row.height
    }

    RowLayout {
        id: row
        spacing: 0

        BotCol {
            id: weatherCol
            minH: top.baseH
            first: true
            area: top.area
            BotBubble {
                id: weatherbbl
                col: Theme.colYellow
                ico: Weather.ico

                bottomtxt: Weather.ok ? (Weather.w.temp + Weather.w.tunit) : "-"
                topit: DetailList {
                    visible: top.full
                    col: weatherbbl.fg
                    title: (Weather.ok? Weather.w.desc + (Weather.w.city ? " · " + Weather.w.city : "")
                        : (Weather.w ? "Weather error" : "No weather data"))
                    titleBold: true
                    titleOpacity: 1
                    titleSize: Theme.fontSize
                    rows: (Weather.ok ? [
                        { label: "Feels like", value: Weather.w.feels + Weather.w.tunit },
                        { label: "Humidity",   value: Weather.w.humidity + "%" },
                        { label: "High / Low", value: Weather.w.high + "° / " + Weather.w.low + "°" },
                        { label: "Rain",       value: Weather.w.rain + "%" },
                        { label: "Wind",       value: Weather.w.wind + " " + Weather.w.wunit }
                    ] : (Weather.w ? [{ label: "", value: String(Weather.w.error) }] : []))
                    footer: Weather.ok && Weather.w.updated !== undefined ? [{ label: "Updated", value: String(Weather.w.updated) }] : []

                }
            }
        }
        BotCol {
            id: cpuCol
            minH: top.baseH
            area: top.area
            BotBubble {
                id: cpubbl
                col: Theme.colGreen
                ico: Cpu.ico
                bottomtxt: (Cpu.usage == -1 ? '-' : Cpu.usage) + "%"
                topit: DetailList {
                    visible: top.full
                    col: cpubbl.fg
                    title: "Top processes"
                    rows: Cpu.topProcs
                    footer: Cpu.temp !== "" ? [{ label: "Temp", value: Cpu.temp }] : []
                }
            }
        }
        BotCol {
            id: memCol
            minH: top.baseH
            area: top.area
            BotBubble {
                id: memorybbl
                col: Theme.colBlue
                ico: Memory.ico
                bottomtxt: Memory.usage + "%"
                topit: DetailList {
                    visible: top.full
                    col: memorybbl.fg
                    title: "Top processes"
                    rows: Memory.topProcs
                    footer: [{
                        label: "Used / Total",
                        value: Memory.usedGb.toFixed(1) + " / " + Memory.totalGb.toFixed(1) + " GiB"
                    }]
                }
            }
        }
        BotCol {
            id: diskCol
            minH: top.baseH
            last: true
            area: top.area
            BotBubble {
                id: diskbbl
                col: Theme.colPurple
                ico: Disk.ico
                bottomtxt: `${Disk.free} (${Disk.used == -1 ? '-' : Disk.used}%)`
                topit: DetailList {
                    visible: top.full
                    col: diskbbl.fg
                    title: "Used / Total"
                    rows: Disk.mounts
                    footer: [{ label: "Free (/)", value: Disk.diskFree }]
                }
            }
        }
    }
}

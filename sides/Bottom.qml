import QtQuick
import QtQuick.Layouts
import ".."
import "../modules/bottom/"

RowLayout {
    id: top
    property bool full: false
    spacing: Theme.barSpacing*2

    Weather { full: top.full }
    Cpu     { full: top.full }
    Memory  { full: top.full }
    Disk    { full: top.full }
}

import QtQuick
import "../.."
import ".."

Button {
    property color runcol: Theme.colRed
    property bool run
    col: run ? runcol : Theme.colFg
    radius: Theme.smallRadius
    txtSize: 1.5
}

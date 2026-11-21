import QtQuick
import "../.."

Text {
    property color col: Theme.colFg
    color: col
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSize
    font.bold: true
}

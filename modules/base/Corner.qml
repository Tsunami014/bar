import QtQuick
import "../.."

Item {
    id: corner
    clip: true

    width: Theme.barRound
    height: Theme.barRound 

    property int rx: 0
    property int ry: 0

    // Outer quarter-circle
    Rectangle {
        anchors.fill: parent
        anchors {
            leftMargin: (-corner.rx-1)*Theme.barRound
            rightMargin: (corner.rx-2)*Theme.barRound
            topMargin: (-corner.ry-1)*Theme.barRound
            bottomMargin: (corner.ry-2)*Theme.barRound
        }
        color: Theme.colTransparent
        border.color: Theme.colBg
        border.width: Theme.barRound 
        radius: Theme.barRound*2
    }
}

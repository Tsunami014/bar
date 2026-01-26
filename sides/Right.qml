import QtQuick
import QtQuick.Layouts
import ".."
import "../modules/right/"

Rectangle {
    ColumnLayout {
        id: middle
        anchors {
            left: parent.left; right: parent.right
            verticalCenter: parent.verticalCenter;
        }
        spacing: Theme.barSpacing + Theme.barRound*2

        Volume{}
        Volume{}
    }
}

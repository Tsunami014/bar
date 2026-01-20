import QtQuick
import QtQuick.Layouts
import ".."
import "../modules/"

Rectangle {
    // Top
    ColumnLayout {
        anchors {
            left: parent.left; right: parent.right
            top: parent.top
        }
        spacing: Theme.barSpacing

        Battery {}
        Clock {}
    }
}

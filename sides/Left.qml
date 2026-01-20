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
    // Middle
    Workspaces {
        anchors.centerIn: parent
    }
    // Bottom
    ColumnLayout {
        anchors {
            left: parent.left; right: parent.right
            bottom: parent.bottom
        }
        spacing: Theme.barSpacing

        Wifi {}
    }
}

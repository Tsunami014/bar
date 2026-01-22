import QtQuick
import QtQuick.Layouts
import ".."
import "../modules/vertical/"

Rectangle {
    ColumnLayout {
        id: top
        anchors {
            left: parent.left; right: parent.right
            top: parent.top
        }
        spacing: Theme.barSpacing

        Execute {
            col1: Theme.colIndigo
            col2: Theme.colPurple
            cmd: ["sh", "-c", "$EXECUTE"]
        }
        Clock {}
        Wifi {}
    }
    ColumnLayout {
        id: bottom
        anchors {
            left: parent.left; right: parent.right
            bottom: parent.bottom
        }
        spacing: Theme.barSpacing

        Workspaces {}
        Battery {}
    }
    ColumnLayout {
        id: middle
        anchors {
            left: parent.left; right: parent.right
            top: top.bottom; bottom: bottom.top
            topMargin: Theme.barSpacing
            bottomMargin: Theme.barSpacing
        }
        spacing: Theme.barSpacing

        Tray {}
    }
}

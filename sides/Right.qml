import QtQuick
import QtQuick.Layouts
import ".."
import "../modules/right/"

Rectangle {
    ColumnLayout {
        id: middle
        anchors {
            left: parent.left; right: parent.right
            top: parent.top; bottom: parent.bottom
            verticalCenter: parent.verticalCenter;
        }

        Item {
            Layout.fillHeight: true
            Layout.verticalStretchFactor: 3
        }
        Brightness{}
        Item {
            Layout.fillHeight: true
            Layout.verticalStretchFactor: 2
        }
        Volume{}
        Item {
            Layout.fillHeight: true
            Layout.verticalStretchFactor: 3
        }
    }
}

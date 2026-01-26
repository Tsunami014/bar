import QtQuick
import QtQuick.Layouts
import ".."
import "../modules/all/"
import "../modules/bottom/"

RowLayout {
    id: top
    spacing: Theme.barSpacing*2

    Execute {
        Layout.fillHeight: true
        implicitWidth: parent.height
        col1: Theme.colIndigo
        col2: Theme.colPurple
        cmd: ["sh", "-c", "$EXECUTE"]
    }
    Exec {
        text: "HI"
    }
}

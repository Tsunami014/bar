import QtQuick
import QtQuick.Layouts
import ".."
import "../modules/all/"

RowLayout {
    id: top
    spacing: Theme.barSpacing

    Execute {
        Layout.fillHeight: true
        Layout.preferredWidth: parent.height
        col1: Theme.colIndigo
        col2: Theme.colPurple
        cmd: ["sh", "-c", "$EXECUTE"]
    }
}

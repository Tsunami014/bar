import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick

ShellRoot {
    id: root

    // Output the touchscreen is mapped to, e.g. "eDP-1". Empty = first screen.
    property string touchScreenName: ""
    readonly property string targetName: touchScreenName !== ""
        ? touchScreenName
        : (Quickshell.screens.length > 0 ? Quickshell.screens[0].name : "")
    property bool shown: true
    property real now: Date.now()

    ListModel { id: pts }   // slot, fx, fy (percent), since

    Timer {
        interval: 250; running: true; repeat: true
        onTriggered: root.now = Date.now()
    }

    function indexOfSlot(slot) {
        for (let i = 0; i < pts.count; i++)
            if (pts.get(i).slot === slot) return i;
        return -1;
    }

    function handle(line) {
        const m = line.match(/TOUCH_(DOWN|MOTION|UP|CANCEL)\s+\+?[\d.]+s\s+(-?\d+) \((-?\d+)\)(?:\s+([\d.]+)\/([\d.]+))?/);
        if (!m) return;
        const type = m[1], slot = parseInt(m[2]);
        const i = indexOfSlot(slot);

        if (type === "UP" || type === "CANCEL") {
            if (i >= 0) pts.remove(i);
            return;
        }
        const fx = parseFloat(m[4]), fy = parseFloat(m[5]);
        if (isNaN(fx) || isNaN(fy)) return;
        if (i < 0) {
            pts.append({ slot: slot, fx: fx, fy: fy, since: Date.now() });
        } else {
            pts.setProperty(i, "fx", fx);
            pts.setProperty(i, "fy", fy);
        }
    }

    Process {
        running: true
        command: ["stdbuf", "-oL", "libinput", "debug-events"]
        stdout: SplitParser { onRead: line => root.handle(line) }
        stderr: SplitParser { onRead: line => console.warn("libinput:", line) }
    }

    IpcHandler {
        target: "touchdebug"
        function toggle(): void { root.shown = !root.shown }
        function clear(): void { pts.clear() }
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: win
            required property var modelData
            screen: modelData

            visible: root.shown && modelData.name === root.targetName

            anchors { top: true; bottom: true; left: true; right: true }
            color: "transparent"
            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
            mask: Region {}   // empty input region = click-through

            Repeater {
                model: pts

                delegate: Item {
                    id: marker
                    required property int slot
                    required property real fx
                    required property real fy
                    required property real since

                    readonly property real held: (root.now - since) / 1000
                    readonly property bool stuck: held > 2
                    readonly property color col: stuck ? "#ff3b30" : "#34c759"

                    x: fx / 100 * win.width
                    y: fy / 100 * win.height

                    Rectangle {
                        width: 60; height: 60; radius: 30
                        x: -30; y: -30
                        color: Qt.rgba(marker.col.r, marker.col.g, marker.col.b, 0.25)
                        border.width: 3
                        border.color: marker.col
                    }
                    Rectangle { x: -40; y: -1; width: 80; height: 2; color: marker.col }
                    Rectangle { x: -1; y: -40; width: 2; height: 80; color: marker.col }

                    Text {
                        x: 38; y: 38
                        color: "white"
                        style: Text.Outline
                        styleColor: "black"
                        font.pixelSize: 16
                        text: "#" + marker.slot
                              + "  " + Math.round(marker.x) + "," + Math.round(marker.y)
                              + "  " + marker.held.toFixed(1) + "s"
                    }
                }
            }
        }
    }
}

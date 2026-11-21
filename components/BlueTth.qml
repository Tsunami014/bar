pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Io
import "../modules"
import ".."

Singleton { id: root
    readonly property bool enabled: Bluetooth.defaultAdapter && Bluetooth.defaultAdapter.enabled
    //! Connected count
    readonly property int connCount: {
        let n = 0
        if (Bluetooth.devices && Bluetooth.devices.values)
            for (let i = 0; i < Bluetooth.devices.values.length; i++)
                if (Bluetooth.devices.values[i].connected) n++
        return n
    }

    property string ico: (
        enabled == 0? "󰂲" :
        connCount == 0? "" :
        "󰂱")


    // Clears a soft rfkill block, then powers the adapter on once that's done
    Process {
        id: rfkillUnblock
        command: ["rfkill", "unblock", "bluetooth"]
        onExited: {
            if (Bluetooth.defaultAdapter)
                Bluetooth.defaultAdapter.enabled = true
        }
    }

    function toggle() {
        if (!Bluetooth.defaultAdapter) return
        if (Bluetooth.defaultAdapter.enabled) {
            Bluetooth.defaultAdapter.enabled = false
        } else {
            rfkillUnblock.running = true
        }
    }

    readonly property bool scanning: !!(enabled && Bluetooth.defaultAdapter && Bluetooth.defaultAdapter.discovering)
    function toggleScan() {
        if (enabled && Bluetooth.defaultAdapter) {
            Bluetooth.defaultAdapter.discovering = !Bluetooth.defaultAdapter.discovering
        }
    }


    Process {
        id: opencmd
        command: ["blueman-manager"]
    }
    function open() { opencmd.running = true }
}

pragma Singleton
import QtQuick

QtObject {
    id: root
    property var openHover: ({})

    function hoverOpened(group, item) {
        if (!group) return
        const prev = openHover[group]
        openHover[group] = item
        if (prev && prev !== item && prev.forceShutHover) {
            prev.forceShutHover()
        }
    }

    function hoverClosed(group, item) {
        if (!group) return
        if (openHover[group] === item) {
            delete openHover[group]
        }
    }
}

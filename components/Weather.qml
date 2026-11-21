pragma Singleton
import Quickshell
import Quickshell.Io

Singleton { id: root
    //! Raw weather data
    property var w: null
    readonly property bool ok: w !== null && !w.error

    property string ico: w && w.icon ? w.icon : "󰼯"

    FileView {
        path: Quickshell.env("HOME") + "/.cache/weather.json"
        watchChanges: true
        blockLoading: true
        printErrors: false
        onFileChanged: reload()
        onLoadFailed: root.w = null
        onLoaded: {
            const raw = text().trim()
            if (!raw) return
            try {
                root.w = JSON.parse(raw)
            } catch (e) {
                console.warn("weather: bad JSON", e)
            }
        }
    }
}

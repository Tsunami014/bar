pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton { id: root
    readonly property PwNode sink: Pipewire.defaultAudioSink

    readonly property bool ready: sink?.audio != null
    readonly property bool muted: sink?.audio?.muted ?? false
    readonly property int val: Math.round((sink?.audio?.volume ?? 0) * 100)

    property string ico: muted ? "" :
        val == 0 ? "" :
        val <= 40 ? "" :
        ""

    function set(pct) {
        if (sink?.audio)
            sink.audio.volume = Math.max(0, Math.min(100, pct)) / 100
    }

    PwObjectTracker { objects: [root.sink] }
}

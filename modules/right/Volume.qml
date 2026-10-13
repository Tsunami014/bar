import "../.."
import QtQuick
import Quickshell.Services.Pipewire
import Quickshell.Io

RightSlider {
    slider.col: Theme.colIndigo
    slider.fillcol: Theme.colBlue
    slider.handlecol: Theme.colBlue

    property bool muted: false

    slider.initial: Process {
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                const spl = data.trim().split(" ")
                slider.value = parseFloat(spl[1])*100 || 1
                muted = spl.includes("[MUTED]")
                slider.ready = true
            }
        }
    }

    slider.change: Process {
        command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", slider.val+"%"]
    }

    property string ico: muted ? "" :
        slider.val == 0 ? "" :
        slider.val <= 40 ? "" :
        ""
    slider.text: slider.pressed? slider.val : ico

    PwObjectTracker { objects: [Pipewire.defaultAudioSink] }  // required, or volume stays unbound

    Connections {
        target: Pipewire.defaultAudioSink?.audio ?? null
        function onVolumeChanged() {
            if (!slider.pressed)
                slider.value = Pipewire.defaultAudioSink.audio.volume * 100
        }
        function onMutedChanged() {
            muted = Pipewire.defaultAudioSink.audio.muted
        }
    }
}

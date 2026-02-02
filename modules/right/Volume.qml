import "../.."
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
        slider.value <= 30 ? "" :
        slider.value <= 60 ? "" :
        ""
    slider.text: ico + "\n" + slider.val+"%"
}

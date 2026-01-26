import "../.."
import Quickshell.Io

RightSlider {
    slider.col: Theme.colYellow
    slider.fillcol: Theme.colRed
    slider.handlecol: Theme.colOrange

    slider.initial: Process {
        command: ["sh", "-c", "brightnessctl info | grep -o -P '[0-9]+(?=%)' -m 1"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                slider.value = parseInt(data.trim()) || 1
                slider.ready = true
            }
        }
    }

    slider.change: Process {
        command: ["brightnessctl", "set", slider.value+"%"]
    }

    property string ico:
        slider.value <= 5 ? "" :
        slider.value <= 10 ? "" :
        slider.value <= 20 ? "" :
        slider.value <= 30 ? "" :
        slider.value <= 40 ? "" :
        slider.value <= 48 ? "" :
        slider.value <= 52 ? "" :
        slider.value <= 60 ? "" :
        slider.value <= 70 ? "" :
        slider.value <= 80 ? "" :
        slider.value <= 90 ? "" :
        slider.value <= 95 ? "" :
        ""
    slider.text: ico + "\n" + Math.round(slider.value)+"%"
}

pragma Singleton
import Quickshell

Singleton { id: root
    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
    property string ico: ""

    function format(fmt) {
        return Qt.formatDateTime(clock.date, fmt)
    }
}

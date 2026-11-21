pragma Singleton
import Quickshell

Singleton { id: root
    readonly property var killIdleStart: ["sh", "-c", "kill -STOP $(pidof swayidle)"]
    readonly property var killIdleStop: ["sh", "-c", "kill -CONT $(pidof swayidle)"]
    readonly property var noAutoRot: ["sh", "-c", `touch /tmp/"NOAUTOROTATE-$USER" && trap "rm \\"/tmp/NOAUTOROTATE-$USER\\"" EXIT && sleep infinity`]
    readonly property var popupKbd: ["sh", "-c", "pgrep wvkbd-mobintl >/dev/null || wvkbd-mobintl --bg 000000C0 -H 350 -L 200"]
    readonly property var touchDebug: ["sh", "-c", "qs -p ~/.config/quickshell/bar/touchdebug"]
}

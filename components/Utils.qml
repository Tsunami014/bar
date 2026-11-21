pragma Singleton
import Quickshell

Singleton { id: root
    property list<string> killIdleStart: ["sh", "-c", "kill -STOP $(pidof swayidle)"]
    property list<string> killIdleStop: ["sh", "-c", "kill -CONT $(pidof swayidle)"]
    property list<string> noAutoRot: ["sh", "-c", `touch /tmp/"NOAUTOROTATE-$USER" && trap "rm \\"/tmp/NOAUTOROTATE-$USER\\"" EXIT && sleep infinity`]
    property list<string> popupKbd: ["sh", "-c", "pgrep wvkbd-mobintl >/dev/null || wvkbd-mobintl --bg 000000C0 -H 350 -L 200"]
    property list<string> touchDebug: ["sh", "-c", "qs -p ~/.config/quickshell/bar/touchdebug"]
}

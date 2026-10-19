pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Window

Singleton {
    id: root

    property bool theme2: false
    onTheme2Changed: {
        const n = theme2 ? 2 : 1
        if (n !== pal.variant) setVariant(n)
    }

    function setVariant(n) {
        setter.command = ["upd-theme-variant", String(n)]
        setter.running = true
    }
    Process { id: setter }

    FileView {
        path: Quickshell.env("HOME") + "/.local/state/theme/current/palette.json"
        watchChanges: true
        onFileChanged: reload()
        adapter: JsonAdapter {
            id: pal
            onVariantChanged: root.theme2 = (variant === 2)

            // Fallbacks
            property int variant: 1
            property string bg: "#1a1b26"
            property string bg2: "#222436"
            property string bg3: "#2f334d"
            property string fg: "#c0caf5"
            property string muted1: "#9aa5ce"
            property string muted2: "#545c7e"
            property string accent: "#7ca1f2"
            property string primary: "#7ca1f2"
            property string secondary: "#9aa5ce"
            property string tertiary: "#c099ff"
            property string red: "#ff757f"
            property string orange: "#ff966c"
            property string yellow: "#ffc777"
            property string green: "#b8db87"
            property string cyan: "#89ddff"
            property string blue: "#7ca1f2"
            property string purple: "#c099ff"
        }
    }

    readonly property color colTransparent: "transparent"  // Fully transparent background
    readonly property color colFg: pal.fg
    readonly property color colMuted1: pal.muted1
    readonly property color colMuted2: pal.muted2
    readonly property color colBg: pal.bg2

    readonly property color colRed: pal.red
    readonly property color colOrange: pal.orange
    readonly property color colYellow: pal.yellow
    readonly property color colGreen: pal.green
    readonly property color colBlue: pal.cyan
    readonly property color colIndigo: pal.blue
    readonly property color colPurple: pal.purple

    readonly property color colPrimary: pal.primary
    readonly property color colSecondary: pal.secondary
    readonly property color colTertiary: pal.tertiary

    // Font
    readonly property string fontFamily: "Ubuntu Nerd Font"
    readonly property int fontSize: 16

    // Bar sizing
    readonly property int barPadding: 7
    readonly property int barBaseSze: 12
    readonly property int barSpacing: 8
    readonly property int barRound: 15
    readonly property int barSliderLen: Screen.desktopAvailableHeight * (2/9)

    // Border stuff
    readonly property int borderRadius: 15
    readonly property double borderWidth: 2.5

    // Properties that need to be used in multiple places
    readonly property real leftBarWidth:  fontSize*2.5 + barPadding*2 + 1
    readonly property real rightBarWidth: barBaseSze

    // Misc
    property bool expandLock: false
    readonly property double sliderRound: 0.45 // Must be >0 and <=0.5
    readonly property real lighten: theme2? 1.1 : 1.2
}

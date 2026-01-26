pragma Singleton
import QtQuick
import QtQuick.Window

QtObject {
    // Theme colors - Chroma Glow style (matching waybar)

    readonly property color colTransparent: "transparent"  // Fully transparent background
    readonly property color colFg: "#c0caf5"
    readonly property color colMuted1: "#9aa5ce"
    readonly property color colMuted2: "#545c7e"
    readonly property color colBg: "#222436"

    readonly property color colRed: "#ff757f"
    readonly property color colOrange: "#ff966c"
    readonly property color colYellow: "#ffc777"
    readonly property color colGreen: "#b8db87"
    readonly property color colBlue: "#89ddff"
    readonly property color colIndigo: "#7ca1f2"
    readonly property color colPurple: "#c099ff"

    // Font
    readonly property string fontFamily: "JetBrainsMono Nerd Font"
    readonly property int fontSize: 16

    // Bar sizing
    readonly property int barPadding: 7
    readonly property int barSze: fontSize*2 + barPadding*2
    readonly property int barBaseSze: 10
    readonly property int barSpacing: 10
    readonly property int barRound: 10
    readonly property int barSliderLen: Screen.desktopAvailableHeight * (3/9)

    // Border stuff
    readonly property int borderRadius: 15
    readonly property double borderWidth: 2.5
}

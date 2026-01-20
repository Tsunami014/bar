pragma Singleton
import QtQuick

QtObject {
    // Theme colors - Chroma Glow style (matching waybar)

    readonly property color colTransparent: "transparent"  // Fully transparent background
    readonly property color colFg: "#c0caf5"
    readonly property color colMuted1: "#9aa5ce"
    readonly property color colMuted2: "#565f89"
    readonly property color colBg: "#1a1b26"

    readonly property color colRed: "#f7768e"
    readonly property color colOrange: "#ff9e64"
    readonly property color colYellow: "#e0af68"
    readonly property color colGreen: "#9ece6a"
    readonly property color colBlue: "#2ac3de"
    readonly property color colIndigo: "#7aa2f7"
    readonly property color colPurple: "#bb9af7"

    // Font
    readonly property string fontFamily: "JetBrainsMono Nerd Font"
    readonly property int fontSize: 16

    // Bar sizing
    readonly property int barPadding: 7
    readonly property int barSze: fontSize*2 + barPadding*2
    readonly property int barBaseSze: 10
    readonly property int barSpacing: 10
    readonly property int barRound: 10
}

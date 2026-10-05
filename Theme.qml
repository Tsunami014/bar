pragma Singleton
import QtQuick
import QtQuick.Window

QtObject {
    property bool theme2: false

    readonly property color colTransparent: "transparent"  // Fully transparent background
    readonly property color colFg: theme2? "#c6d0f5" : "#c0caf5"
    readonly property color colMuted1: theme2? "#838ba7" : "#9aa5ce"
    readonly property color colMuted2: theme2? "#626880" : "#545c7e"
    readonly property color colBg: theme2? "#414559" : "#222436"

    readonly property color colRed: theme2? "#e78284" : "#ff757f"
    readonly property color colOrange: theme2? "#ef9f76" : "#ff966c"
    readonly property color colYellow: theme2? "#e5c890" : "#ffc777"
    readonly property color colGreen: theme2? "#a6d189" : "#b8db87"
    readonly property color colBlue: theme2? "#85c1dc" : "#89ddff"
    readonly property color colIndigo: theme2? "#8caaee" : "#7ca1f2"
    readonly property color colPurple: theme2? "#ca9ee6" : "#c099ff"

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

    // Misc
    property bool expandLock: false
    readonly property double sliderRound: 0.45 // Must be >0 and <=0.5
    readonly property real lighten: theme2? 1.1 : 1.2
}

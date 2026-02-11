//@ pragma UseQApplication
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Niri 0.1
import "./bars/"

ShellRoot{
    id: root

    Niri {
        id: niri
        Component.onCompleted: connect()

        onConnected: console.info("Connected to niri")
        onErrorOccurred: function(error) {
            console.error("Niri error:", error)
        }
    }

    LeftBar{}
    RightBar{}
    TopBar{}
    BotBar{}

    CornerBar {
        anchors {
            top: true
            left: true
        }
    }
    CornerBar {
        anchors {
            top: true
            right: true
        }
        rx: 1
    }
    CornerBar {
        anchors {
            bottom: true
            left: true
        }
        ry: 1
    }
    CornerBar {
        anchors {
            bottom: true
            right: true
        }
        rx: 1
        ry: 1
    }
}

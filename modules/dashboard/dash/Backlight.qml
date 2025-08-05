import QtQuick 2.15
import Quickshell.Io

Item {
    id: root
    property bool toggled: false

    Process {
        id: getBrightnessProc
        command: ["brightnessctl", "--device=asus::kbd_backlight", "g"]
        onExited: {
            const currentBrightness = parseInt(stdout.trim(), 10);
            root.toggled = (currentBrightness > 0);
        }
    }

    Process {
        id: setBrightnessProc
    }

    function toggle(value) {
        setBrightnessProc.command = ["brightnessctl", "--device=asus::kbd_backlight", "s", value ? "100%" : "0"];
        setBrightnessProc.start();
    }

    Component.onCompleted: {
        getBrightnessProc.start();
    }
}

import QtQuick 2.15
import Quickshell
import Quickshell.Io

Item {
    id: root
    property bool toggled: false

    Process {
        id: getBrightnessProc
        command: ["brightnessctl", "--device=asus::kbd_backlight", "g"]
        onExited: {
            console.log("getBrightness exitCode:", exitCode, "stdout:", stdout.trim());
            if (exitCode === 0) {
                const currentBrightness = parseInt(stdout.trim(), 10);
                const newToggled = (currentBrightness > 0);
                if (root.toggled !== newToggled) {
                    root.toggled = newToggled;
                    console.log("Backlight state updated to:", newToggled);
                }
            } else {
                console.error("Failed to get brightness:", stderr);
            }
        }
    }

    function toggle(value) {
        console.log("Backlight toggle called with value:", value);
        // Use execDetached for immediate execution
        Quickshell.execDetached([
            "brightnessctl", 
            "--device=asus::kbd_backlight", 
            "s", 
            value ? "3" : "0"
        ]);
        
        // Update local state immediately for responsive UI
        root.toggled = value;
        
        // Refresh actual state after a short delay
        refreshTimer.start();
    }

    function refreshState() {
        console.log("Refreshing backlight state...");
        getBrightnessProc.start();
    }

    Timer {
        id: refreshTimer
        interval: 200
        onTriggered: refreshState()
    }

    Component.onCompleted: {
        console.log("Backlight component initialized");
        refreshState();
    }
}

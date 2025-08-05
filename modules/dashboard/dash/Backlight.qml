import QtQuick 2.15
import Quickshell
import Quickshell.Io

Item {
    id: root
    property bool toggled: false

    Process {
        id: getBrightnessProc
        command: ["brightnessctl", "--device=asus::kbd_backlight", "g"]
        
        stdout: StdioCollector {
            id: stdoutCollector
            onStreamFinished: {
                const output = stdoutCollector.text;
                console.log("getBrightness stdout:", output ? output.trim() : null);
                if (output) {
                    const currentBrightness = parseInt(output.trim(), 10);
                    const newToggled = (currentBrightness > 0);
                    if (root.toggled !== newToggled) {
                        root.toggled = newToggled;
                        console.log("Backlight state updated to:", newToggled);
                    }
                }
            }
        }

        stderr: StdioCollector {
            id: stderrCollector
            onStreamFinished: {
                const errorOutput = stderrCollector.text;
                if (errorOutput) {
                    console.error("Failed to get brightness:", errorOutput);
                }
            }
        }

        onExited: (exitCode) => {
            console.log("getBrightness exitCode:", exitCode);
            if (exitCode !== 0) {
                console.error("brightnessctl process failed with exit code:", exitCode);
            }
        }
    }

    function toggle(value) {
        console.log("Backlight toggle called with value:", value);
        Quickshell.execDetached([
            "brightnessctl", 
            "--device=asus::kbd_backlight", 
            "s", 
            value ? "3" : "0"
        ]);
        root.toggled = value;
        refreshTimer.start();
    }

    function refreshState() {
        console.log("Refreshing backlight state...");
        getBrightnessProc.running = true;
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

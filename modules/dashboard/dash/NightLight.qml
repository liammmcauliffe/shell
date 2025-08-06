import QtQuick 2.15
import QtQuick.Timers
import Quickshell
import Quickshell.Io

Item {
    id: root
    property bool toggled: false

    Process {
        id: checkNightLightProc
        command: ["pgrep", "-f", "wlsunset"]
        
        stdout: StdioCollector {
            id: stdoutCollector
            onStreamFinished: {
                const output = stdoutCollector.text;
                console.log("checkNightLight stdout:", output ? output.trim() : null);
                if (output) {
                    const isRunning = output.trim().length > 0;
                    if (root.toggled !== isRunning) {
                        root.toggled = isRunning;
                        console.log("NightLight state updated to:", isRunning);
                    }
                } else {
                    // wlsunset is not running
                    if (root.toggled !== false) {
                        root.toggled = false;
                        console.log("NightLight state updated to: false (no service running)");
                    }
                }
            }
        }

        stderr: StdioCollector {
            id: stderrCollector
            onStreamFinished: {
                const errorOutput = stderrCollector.text;
                if (errorOutput) {
                    console.error("Failed to check wlsunset:", errorOutput);
                }
            }
        }

        onExited: (exitCode) => {
            console.log("checkNightLight exitCode:", exitCode);
            if (exitCode !== 0 && exitCode !== 1) {
                console.error("pgrep process failed with exit code:", exitCode);
            }
        }
    }

    function toggle(value) {
        console.log("NightLight toggle called with value:", value);
        
        if (value) {
            Quickshell.execDetached([
                "wlsunset", 
                "-l", "29.651979", 
                "-L", "-82.325020", 
                "-t", "4000", 
                "-T", "6500"
            ]);
        } else {
            // Kill wlsunset process
            Quickshell.execDetached(["pkill", "-f", "wlsunset"]);
        }
        
        root.toggled = value;
        refreshTimer.start();
    }

    function refreshState() {
        console.log("Refreshing night light state...");
        checkNightLightProc.running = true;
    }

    Timer {
        id: refreshTimer
        interval: 500
        onTriggered: refreshState()
    }

    Component.onCompleted: {
        console.log("NightLight component initialized");
        refreshState();
    }
} 
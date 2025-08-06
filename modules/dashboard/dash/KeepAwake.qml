import QtQuick 2.15
import Quickshell
import Quickshell.Io
import qs.modules.common

Item {
    id: root
    property bool toggled: false
    property bool manualToggle: false

    function toggle() {
        console.log("KeepAwake toggle called, current state:", toggled);
        
        // Prevent automatic refreshes during operation
        root.manualToggle = true;
        refreshTimer.stop();
        
        if (toggled) {
            // Turn off keep awake
            root.toggled = false;
            Quickshell.execDetached(["pkill", "-f", "wayland-idle-inhibitor.py"]);
            
            // Verify after delay
            Qt.callLater(function() {
                checkActiveStateProc.running = true;
                // Re-enable checks after longer delay
                Qt.callLater(function() {
                    refreshTimer.restart();
                    root.manualToggle = false;
                }, 1000);
            }, 300);
        } else {
            // Turn on keep awake
            root.toggled = true;
            Quickshell.execDetached(["/home/liam/.config/quickshell/caelestia/utils/scripts/wayland-idle-inhibitor.py"]);
            
            // Verify after delay
            Qt.callLater(function() {
                checkActiveStateProc.running = true;
                // Re-enable checks after longer delay
                Qt.callLater(function() {
                    refreshTimer.restart();
                    root.manualToggle = false;
                }, 1000);
            }, 300);
        }
    }

    function refreshState() {
        console.log("Refreshing keep awake state...");
        checkActiveStateProc.running = true;
    }

    // Process to check if wayland-idle-inhibitor is running
    Process {
        id: checkActiveStateProc
        command: ["pgrep", "-f", "wayland-idle-inhibitor.py"]
        running: false
        
        stdout: StdioCollector {
            id: stdoutCollector
            onStreamFinished: {
                if (!root.manualToggle) {
                    const output = stdoutCollector.text;
                    const isRunning = output && output.trim().length > 0;
                    
                    if (root.toggled !== isRunning) {
                        root.toggled = isRunning;
                        console.log("KeepAwake state updated to:", isRunning);
                    }
                }
            }
        }

        stderr: StdioCollector {
            onStreamFinished: {
                const errorOutput = text;
                if (errorOutput) console.error("wayland-idle-inhibitor check error:", errorOutput);
            }
        }

        onExited: exitCode => {
            if (exitCode > 1) console.error("pgrep failed, code:", exitCode);
        }
    }

    Timer {
        id: refreshTimer
        interval: 3000  // 3 second refresh interval
        running: false  // Don't run automatically
        onTriggered: refreshState()
    }

    Component.onCompleted: {
        // Initial check with delay
        Qt.callLater(function() {
            refreshState();
            refreshTimer.restart();
        }, 1000);
    }
}
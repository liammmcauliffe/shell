import QtQuick 2.15
import Quickshell
import Quickshell.Io

Item {
    id: root
    property bool toggled: false
    property bool manualToggle: false

    // Dedicated process for killing wlsunset
    Process {
        id: killProcess
        command: ["pkill", "-f", "wlsunset"]
        running: false  // Don't run automatically
        onExited: {
            console.log("Kill command completed with exit code:", exitCode);
            if (typeof root.killCallback === "function") {
                root.killCallback();
                root.killCallback = undefined;
            }
        }
    }

    Process {
        id: checkNightLightProc
        command: ["pgrep", "-f", "wlsunset"]
        running: false  // Don't run automatically
        
        stdout: StdioCollector {
            id: stdoutCollector
            onStreamFinished: {
                if (!root.manualToggle) {
                    const output = stdoutCollector.text;
                    const isRunning = output && output.trim().length > 0;
                    
                    if (root.toggled !== isRunning) {
                        root.toggled = isRunning;
                        console.log("NightLight state updated to:", isRunning);
                    }
                }
            }
        }

        stderr: StdioCollector {
            onStreamFinished: {
                const errorOutput = text;
                if (errorOutput) console.error("wlsunset check error:", errorOutput);
            }
        }

        onExited: exitCode => {
            if (exitCode > 1) console.error("pgrep failed, code:", exitCode);
        }
    }

    // Callback storage for kill operation
    property var killCallback: undefined

    function toggle(value) {
        console.log("NightLight toggle called with value:", value);
        
        // Prevent automatic refreshes during operation
        root.manualToggle = true;
        refreshTimer.stop();
        
        // Update UI immediately
        root.toggled = value;
        
        if (value) {
            // Store callback for after kill completes
            root.killCallback = function() {
                // Start new process after kill completes
                Quickshell.execDetached([
                    "wlsunset", 
                    "-l", "29.651979", 
                    "-L", "-82.325020", 
                    "-t", "4000", 
                    "-T", "6500"
                ]);
                
                // Verify after delay
                Qt.callLater(function() {
                    checkNightLightProc.running = true;
                    // Re-enable checks after longer delay
                    Qt.callLater(function() {
                        refreshTimer.restart();
                        root.manualToggle = false;
                    }, 1000);
                }, 300);
            };
            
            // Start kill process by setting running to true
            killProcess.running = true;
        } else {
            // Store callback for after kill completes
            root.killCallback = function() {
                // Re-enable state checks after delay
                Qt.callLater(function() {
                    refreshTimer.restart();
                    root.manualToggle = false;
                }, 500);
            };
            
            // Start kill process by setting running to true
            killProcess.running = true;
        }
    }

    function refreshState() {
        console.log("Refreshing night light state...");
        checkNightLightProc.running = true;
    }

    Timer {
        id: refreshTimer
        interval: 3000  // 3 second refresh interval
        running: false  // Don't run automatically
        onTriggered: refreshState()
    }

    Component.onCompleted: {
        console.log("NightLight component initialized");
        // Initial check with delay to avoid startup race conditions
        Qt.callLater(function() {
            checkNightLightProc.running = true;
        }, 1000);
    }
}
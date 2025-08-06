import QtQuick 2.15
import Quickshell
import Quickshell.Io

Item {
    id: root
    property bool toggled: false
    property bool manualToggle: false

    // Process to check current warp-cli status
    Process {
        id: checkWarpStatusProc
        command: ["warp-cli", "--accept-tos", "status"]
        running: false
        
        stdout: StdioCollector {
            id: stdoutCollector
            onStreamFinished: {
                if (!root.manualToggle) {
                    const output = stdoutCollector.text;
                    let isConnected = false;
                    
                    if (output && output.includes("Connected")) {
                        isConnected = true;
                    } else if (output && output.includes("Unable")) {
                        // If unable to connect, we need to register first
                        console.log("Warp needs registration");
                    }
                    
                    if (root.toggled !== isConnected) {
                        root.toggled = isConnected;
                        console.log("Cloudflare WARP state updated to:", isConnected);
                    }
                }
            }
        }

        stderr: StdioCollector {
            onStreamFinished: {
                const errorOutput = text;
                if (errorOutput) console.error("warp-cli status check error:", errorOutput);
            }
        }

        onExited: exitCode => {
            if (exitCode !== 0) {
                console.error("warp-cli status failed with exit code:", exitCode);
            }
        }
    }

    // Process for connecting to WARP
    Process {
        id: connectProc
        command: ["warp-cli", "--accept-tos", "connect"]
        running: false
        
        onExited: (exitCode, exitStatus) => {
            if (exitCode !== 0) {
                console.error("WARP connection failed with exit code:", exitCode);
                // If connection fails, try registration first
                registrationProc.running = true;
            } else {
                // Verify connection after delay
                Qt.callLater(function() {
                    checkWarpStatusProc.running = true;
                    Qt.callLater(function() {
                        refreshTimer.restart();
                        root.manualToggle = false;
                    }, 1000);
                }, 500);
            }
        }
    }

    // Process for disconnecting from WARP
    Process {
        id: disconnectProc
        command: ["warp-cli", "--accept-tos", "disconnect"]
        running: false
        
        onExited: (exitCode, exitStatus) => {
            // Verify disconnection after delay
            Qt.callLater(function() {
                checkWarpStatusProc.running = true;
                Qt.callLater(function() {
                    refreshTimer.restart();
                    root.manualToggle = false;
                }, 1000);
            }, 500);
        }
    }

    // Process for registering WARP (if needed)
    Process {
        id: registrationProc
        command: ["warp-cli", "--accept-tos", "registration", "new"]
        running: false
        
        onExited: (exitCode, exitStatus) => {
            console.log("Warp registration exited with code and status:", exitCode, exitStatus);
            if (exitCode === 0) {
                // Registration successful, try connecting
                connectProc.running = true;
            } else {
                console.error("WARP registration failed");
                // Re-enable checks after failure
                Qt.callLater(function() {
                    refreshTimer.restart();
                    root.manualToggle = false;
                }, 1000);
            }
        }
    }

    function toggle(value) {
        console.log("Cloudflare WARP toggle called with value:", value);
        
        // Prevent automatic refreshes during operation
        root.manualToggle = true;
        refreshTimer.stop();
        
        // Update UI immediately
        root.toggled = value;
        
        if (value) {
            // Try to connect
            connectProc.running = true;
        } else {
            // Disconnect
            disconnectProc.running = true;
        }
    }

    function refreshState() {
        console.log("Refreshing Cloudflare WARP state...");
        checkWarpStatusProc.running = true;
    }

    Timer {
        id: refreshTimer
        interval: 5000  // 5 second refresh interval
        running: false
        onTriggered: refreshState()
    }

    Component.onCompleted: {
        console.log("Cloudflare WARP component initialized");
        // Initial check with delay to avoid startup race conditions
        Qt.callLater(function() {
            checkWarpStatusProc.running = true;
        }, 1000);
    }
} 
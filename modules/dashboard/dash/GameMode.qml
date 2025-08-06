import QtQuick 2.15
import Quickshell
import Quickshell.Io

Item {
    id: root
    property bool toggled: false
    property bool manualToggle: false

    // Dedicated process for checking game mode state
    Process {
        id: checkGameModeProc
        command: ["bash", "-c", `test "$(hyprctl getoption animations:enabled -j | jq ".int")" -ne 0`]
        running: false  // Don't run automatically
        
        onExited: exitCode => {
            if (!root.manualToggle) {
                const isGameMode = exitCode !== 0; // Inverted because enabled = nonzero exit
                if (root.toggled !== isGameMode) {
                    root.toggled = isGameMode;
                    console.log("GameMode state updated to:", isGameMode);
                }
            }
        }
    }

    // Callback storage for operations
    property var operationCallback: undefined

    function toggle(value) {
        console.log("GameMode toggle called with value:", value);
        
        // Prevent automatic refreshes during operation
        root.manualToggle = true;
        
        // Update UI immediately
        root.toggled = value;
        
        if (value) {
            // Enable game mode - disable visual effects
            Quickshell.execDetached([
                "bash", "-c", 
                `hyprctl --batch "keyword animations:enabled 0; keyword decoration:shadow:enabled 0; keyword decoration:blur:enabled 0; keyword general:gaps_in 0; keyword general:gaps_out 0; keyword general:border_size 1; keyword decoration:rounding 0; keyword general:allow_tearing 1"`
            ]);
            
            // Verify after delay
            Qt.callLater(function() {
                checkGameModeProc.running = true;
                // Re-enable checks after longer delay
                Qt.callLater(function() {
                    root.manualToggle = false;
                }, 1000);
            }, 300);
        } else {
            // Disable game mode - reload hyprland config
            Quickshell.execDetached(["hyprctl", "reload"]);
            
            // Verify after delay
            Qt.callLater(function() {
                checkGameModeProc.running = true;
                // Re-enable checks after longer delay
                Qt.callLater(function() {
                    root.manualToggle = false;
                }, 1000);
            }, 500);
        }
    }

    function refreshState() {
        console.log("Refreshing game mode state...");
        checkGameModeProc.running = true;
    }

    Timer {
        id: refreshTimer
        interval: 3000  // 3 second refresh interval
        running: false  // Don't run automatically
        onTriggered: refreshState()
    }

    Component.onCompleted: {
        console.log("GameMode component initialized");
        // Initial check with delay to avoid startup race conditions
        Qt.callLater(function() {
            checkGameModeProc.running = true;
        }, 1000);
    }
} 
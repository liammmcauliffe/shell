import QtQuick 2.15
import Quickshell
import Quickshell.Io
import qs.modules.common

Item {
    id: root
    property bool toggled: false
    property bool manualToggle: false

    function toggle() {
        root.manualToggle = true;
        refreshTimer.stop();
        
        if (toggled) {
            root.toggled = false;
            Quickshell.execDetached(["pkill", "-f", "wayland-idle-inhibitor.py"]);
            
            Qt.callLater(function() {
                checkActiveStateProc.running = true;
                Qt.callLater(function() {
                    refreshTimer.restart();
                    root.manualToggle = false;
                }, 1000);
            }, 300);
        } else {
            root.toggled = true;
            Quickshell.execDetached(["/home/liam/.config/quickshell/caelestia/utils/scripts/wayland-idle-inhibitor.py"]);
            
            Qt.callLater(function() {
                checkActiveStateProc.running = true;
                Qt.callLater(function() {
                    refreshTimer.restart();
                    root.manualToggle = false;
                }, 1000);
            }, 300);
        }
    }

    function refreshState() {
        checkActiveStateProc.running = true;
    }

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
        interval: 3000
        running: false
        onTriggered: refreshState()
    }

    Component.onCompleted: {
        Qt.callLater(function() {
            refreshState();
            refreshTimer.restart();
        }, 1000);
    }
}
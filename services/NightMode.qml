pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property alias enabled: props.enabled

    PersistentProperties {
        id: props

        property bool enabled: false

        reloadableId: "nightMode"
    }

    // Check if hyprsunset is available
    property bool available: false

    Process {
        id: checkHyprsunset
        running: true
        command: ["which", "hyprsunset"]
        onExited: (exitCode, exitStatus) => {
            root.available = exitCode === 0;
            if (available) {
                // Start with night mode disabled
                root.enabled = false;
            }
        }
    }

    // Watch for enabled changes
    onEnabledChanged: {
        if (!available) return;
        
        if (enabled) {
            // Kill any existing hyprsunset process first
            Quickshell.execDetached(["pkill", "hyprsunset"]);
            // Wait a moment then enable night mode - set warm temperature (4000K)
            Quickshell.execDetached(["bash", "-c", "sleep 0.13 && hyprsunset --temperature 4000"]);
        } else {
            // Disable night mode - kill hyprsunset process to reset colors
            Quickshell.execDetached(["pkill", "hyprsunset"]);
        }
    }

    // Toggle function
    function toggle(): void {
        if (!available) return;
        root.enabled = !root.enabled;
    }

    IpcHandler {
        target: "nightMode"

        function isEnabled(): bool {
            return root.enabled;
        }

        function toggle(): void {
            root.toggle();
        }

        function enable(): void {
            root.enabled = true;
        }

        function disable(): void {
            root.enabled = false;
        }

        function isAvailable(): bool {
            return root.available;
        }
    }
}

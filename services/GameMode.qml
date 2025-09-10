pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property alias enabled: props.enabled

    PersistentProperties {
        id: props

        property bool enabled

        reloadableId: "gameMode"
    }

    // Process to check current gamemode state
    Process {
        id: checkStateProcess
        running: true
        command: ["bash", "-c", `test "$(hyprctl getoption animations:enabled -j | jq ".int")" -ne 0`]
        
        onExited: (exitCode, exitStatus) => {
            // Inverted because enabled = nonzero exit (animations disabled = gamemode on)
            props.enabled = exitCode !== 0;
        }
    }

    // Watch for enabled changes
    onEnabledChanged: {
        if (enabled) {
            // Apply gamemode optimizations using batch command
            Quickshell.execDetached(["bash", "-c", `hyprctl --batch "keyword animations:enabled 0; keyword decoration:shadow:enabled 0; keyword decoration:blur:enabled 0; keyword general:gaps_in 0; keyword general:gaps_out 0; keyword general:border_size 1; keyword decoration:rounding 0; keyword general:allow_tearing 1; keyword decoration:active_opacity 1.0; keyword decoration:inactive_opacity 1.0"`]);
        } else {
            // Restore settings by reloading Hyprland config
            Quickshell.execDetached(["hyprctl", "reload"]);
        }
    }

    IpcHandler {
        target: "gameMode"

        function isEnabled(): bool {
            return root.enabled;
        }

        function toggle(): void {
            root.enabled = !root.enabled;
        }

        function enable(): void {
            root.enabled = true;
        }

        function disable(): void {
            root.enabled = false;
        }
    }
}

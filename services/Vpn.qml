pragma Singleton

import qs.components.misc
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property bool enabled: false
    property bool available: false
    property string status: "Disconnected"
    property bool needsRegistration: false

    // Persistent storage
    PersistentProperties {
        id: props

        property bool enabled: false

        reloadableId: "vpn"
    }

    // Initialize on startup
    Component.onCompleted: {
        checkAvailability();
    }

    // Check if warp-cli is available
    function checkAvailability(): void {
        checkWarpCli.running = true;
    }

    Process {
        id: checkWarpCli
        command: ["which", "warp-cli"]
        onExited: (exitCode, exitStatus) => {
            root.available = exitCode === 0;
            if (available) {
                checkStatus();
            }
        }
    }

    // Check current VPN status
    function checkStatus(): void {
        if (!available) return;
        fetchStatus.running = true;
    }

    Process {
        id: fetchStatus
        command: ["bash", "-c", "warp-cli status 2>/dev/null || echo 'Not Available'"]
        onExited: (exitCode, exitStatus) => {
            // For now, we'll use a simple approach and check status differently
            // The actual status checking will be done when user interacts with the toggle
            root.status = "Disconnected";
            root.enabled = false;
        }
    }

    // Connect to VPN
    function connect(): void {
        if (!available) return;
        
        if (needsRegistration) {
            register();
        } else {
            connectProcess.running = true;
        }
    }

    // Disconnect from VPN
    function disconnect(): void {
        if (!available) return;
        disconnectProcess.running = true;
    }

    // Toggle VPN connection
    function toggle(): void {
        if (!available) return;
        
        if (enabled) {
            disconnect();
        } else {
            connect();
        }
    }

    // Register with Cloudflare WARP
    function register(): void {
        if (!available) return;
        registrationProcess.running = true;
    }

    Process {
        id: connectProcess
        command: ["warp-cli", "connect"]
        onExited: (exitCode, exitStatus) => {
            if (exitCode === 0) {
                root.enabled = true;
                root.status = "Connected";
                Quickshell.execDetached(["notify-send", "-a", "caelestia-shell", "-u", "low", "Cloudflare WARP", "Connected to Cloudflare WARP"]);
            } else {
                Quickshell.execDetached(["notify-send", "-a", "caelestia-shell", "-u", "critical", "Cloudflare WARP", "Connection failed. Please check manually with 'warp-cli'"]);
            }
        }
    }

    Process {
        id: disconnectProcess
        command: ["warp-cli", "disconnect"]
        onExited: (exitCode, exitStatus) => {
            if (exitCode === 0) {
                root.enabled = false;
                root.status = "Disconnected";
                Quickshell.execDetached(["notify-send", "-a", "caelestia-shell", "-u", "low", "Cloudflare WARP", "Disconnected from Cloudflare WARP"]);
            } else {
                Quickshell.execDetached(["notify-send", "-a", "caelestia-shell", "-u", "critical", "Cloudflare WARP", "Disconnect failed. Please check manually with 'warp-cli'"]);
            }
        }
    }

    Process {
        id: registrationProcess
        command: ["warp-cli", "registration", "new"]
        onExited: (exitCode, exitStatus) => {
            if (exitCode === 0) {
                root.needsRegistration = false;
                root.status = "Registered";
                connectProcess.running = true;
            } else {
                Quickshell.execDetached(["notify-send", "-a", "caelestia-shell", "-u", "critical", "Cloudflare WARP", "Registration failed. Please check manually with 'warp-cli'"]);
            }
        }
    }

    // Note: We don't auto-connect/disconnect on enabled changes
    // to avoid infinite loops and let user control the connection

    // IPC handler for external control
    IpcHandler {
        target: "vpn"

        function isEnabled(): bool {
            return root.enabled;
        }

        function getStatus(): string {
            return root.status;
        }

        function isAvailable(): bool {
            return root.available;
        }

        function needsRegistration(): bool {
            return root.needsRegistration;
        }

        function toggle(): void {
            root.toggle();
        }

        function connect(): void {
            root.connect();
        }

        function disconnect(): void {
            root.disconnect();
        }

        function register(): void {
            root.register();
        }
    }
}
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
    property bool connecting: false
    property bool disconnecting: false

    // Persistent storage
    PersistentProperties {
        id: props

        property bool enabled: false

        reloadableId: "vpn"
    }

    Component.onCompleted: {
        enabled = false;
        status = "Disconnected";
        checkAvailability();
        startupTimer.start();
    }
    
    Timer {
        id: startupTimer
        interval: 1000
        repeat: false
        onTriggered: {
            if (available) {
                checkStatus();
            }
        }
    }

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

    function checkStatus(): void {
        if (!available) return;
        fetchStatus.running = true;
    }

    Process {
        id: fetchStatus
        command: ["bash", "-c", "warp-cli status 2>/dev/null | head -1 || echo 'Disconnected'"]
        stdout: StdioCollector {
            onStreamFinished: {
                const statusText = text.trim().toLowerCase();
                if (statusText.includes("connected") && !statusText.includes("disconnected")) {
                    root.enabled = true;
                    root.status = "Connected";
                } else {
                    root.enabled = false;
                    root.status = "Disconnected";
                }
            }
        }
    }

    function connect(): void {
        if (!available || connecting) return;
        
        if (needsRegistration) {
            register();
        } else {
            startConnection();
        }
    }

    function startConnection(): void {
        connecting = true;
        status = "Connecting";
        connectProcess.running = true;
        statusCheckTimer.start();
        connectionTimeoutTimer.start();
    }

    function disconnect(): void {
        if (!available || disconnecting) return;
        
        if (connecting) {
            connecting = false;
            statusCheckTimer.stop();
            connectionTimeoutTimer.stop();
        }
        
        disconnecting = true;
        status = "Disconnecting";
        disconnectProcess.running = true;
    }

    function toggle(): void {
        if (!available) return;
        
        if (enabled || connecting) {
            disconnect();
        } else {
            connect();
        }
    }

    function register(): void {
        if (!available) return;
        registrationProcess.running = true;
    }

    Timer {
        id: statusCheckTimer
        interval: 1000
        repeat: true
        onTriggered: {
            if (!connecting) {
                stop();
                return;
            }
            statusCheckProcess.running = true;
        }
    }

    Process {
        id: statusCheckProcess
        command: ["bash", "-c", "warp-cli status 2>/dev/null | head -1 || echo 'Disconnected'"]
        stdout: StdioCollector {
            onStreamFinished: {
                if (!connecting) return;
                
                const statusText = text.trim().toLowerCase();
                if (statusText.includes("connected") && !statusText.includes("disconnected")) {
                    connecting = false;
                    enabled = true;
                    status = "Connected";
                    statusCheckTimer.stop();
                    connectionTimeoutTimer.stop();
                    
                    Quickshell.execDetached(["notify-send", "-a", "caelestia-shell", "-u", "low", "Cloudflare WARP", "Connected to Cloudflare WARP"]);
                }
            }
        }
    }

    Timer {
        id: connectionTimeoutTimer
        interval: 5000
        onTriggered: {
            if (connecting) {
                connecting = false;
                statusCheckTimer.stop();
                Quickshell.execDetached(["warp-cli", "disconnect"]);
                Quickshell.execDetached([
                    "notify-send", 
                    "-a", "caelestia-shell", 
                    "-u", "critical", 
                    "-t", "5000",
                    "-i", "network-vpn",
                    "Cloudflare WARP", 
                    "Failed to connect within 5 seconds. Use the VPN toggle to try again."
                ]);
                status = "Disconnected";
            }
        }
    }

    Process {
        id: connectProcess
        command: ["warp-cli", "connect"]
        onExited: (exitCode, exitStatus) => {
            if (!connecting) return;
            
            if (exitCode !== 0) {
                connecting = false;
                statusCheckTimer.stop();
                connectionTimeoutTimer.stop();
                status = "Disconnected";
                Quickshell.execDetached([
                    "notify-send", 
                    "-a", "caelestia-shell", 
                    "-u", "critical", 
                    "-t", "5000",
                    "-i", "network-vpn",
                    "Cloudflare WARP", 
                    "Connection command failed. Use the VPN toggle to try again."
                ]);
            }
        }
    }

    Process {
        id: disconnectProcess
        command: ["warp-cli", "disconnect"]
        onExited: (exitCode, exitStatus) => {
            disconnecting = false;
            
            if (exitCode === 0) {
                enabled = false;
                status = "Disconnected";
                Quickshell.execDetached(["notify-send", "-a", "caelestia-shell", "-u", "low", "Cloudflare WARP", "Disconnected from Cloudflare WARP"]);
            } else {
                enabled = false;
                status = "Disconnected";
                Quickshell.execDetached(["notify-send", "-a", "caelestia-shell", "-u", "critical", "Cloudflare WARP", "Disconnect command failed, but state updated"]);
            }
        }
    }

    Process {
        id: registrationProcess
        command: ["warp-cli", "registration", "new"]
        onExited: (exitCode, exitStatus) => {
            if (exitCode === 0) {
                needsRegistration = false;
                status = "Registered";
                startConnection();
            } else {
                Quickshell.execDetached([
                    "notify-send", 
                    "-a", "caelestia-shell", 
                    "-u", "critical", 
                    "-t", "5000",
                    "-i", "network-vpn",
                    "Cloudflare WARP", 
                    "Registration failed. Use the VPN toggle to try again."
                ]);
            }
        }
    }

    IpcHandler {
        target: "vpnRetry"
        
        function retry(): void {
            if (needsRegistration) {
                register();
            } else {
                connect();
            }
        }
        
        function cancel(): void {
            connecting = false;
            disconnecting = false;
            statusCheckTimer.stop();
            connectionTimeoutTimer.stop();
            status = "Disconnected";
        }
    }

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
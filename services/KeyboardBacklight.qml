pragma Singleton

import qs.components.misc
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property bool enabled: false
    property real brightness: 0.0 // 0.0 to 1.0
    property bool available: false

    // Detection methods
    property bool hasBrightnessctl: false
    property bool hasSysfs: false
    property bool hasDdcutil: false
    property string sysfsPath: ""

    // Persistent storage
    PersistentProperties {
        id: props

        property bool enabled: false
        property real brightness: 0.5

        reloadableId: "keyboardBacklight"
    }

    // Initialize on startup
    Component.onCompleted: {
        detectMethod();
        if (available) {
            enabled = props.enabled;
            brightness = props.brightness;
            if (enabled) {
                setBrightness(brightness);
            }
        }
    }

    // Detect available method
    function detectMethod(): void {
        // Check for brightnessctl first (most common)
        checkBrightnessctl.running = true;
    }

    Process {
        id: checkBrightnessctl
        command: ["which", "brightnessctl"]
        onExited: (exitCode, exitStatus) => {
            if (exitCode === 0) {
                root.hasBrightnessctl = true;
                root.available = true;
                initBrightness();
            } else {
                checkSysfs.running = true;
            }
        }
    }

    Process {
        id: checkSysfs
        command: ["bash", "-c", "find /sys/class/leds -name '*kbd*' -o -name '*keyboard*' | head -1"]
        stdout: StdioCollector {
            onStreamFinished: {
                if (text.trim() !== "") {
                    root.sysfsPath = text.trim();
                    root.hasSysfs = true;
                    root.available = true;
                    initBrightness();
                } else {
                    checkDdcutil.running = true;
                }
            }
        }
    }

    Process {
        id: checkDdcutil
        command: ["which", "ddcutil"]
        onExited: (exitCode, exitStatus) => {
            if (exitCode === 0) {
                root.hasDdcutil = true;
                root.available = true;
                initBrightness();
            }
        }
    }

    // Initialize brightness on startup
    function initBrightness(): void {
        if (hasBrightnessctl) {
            initBrightnessctl.running = true;
        } else if (hasSysfs) {
            initSysfs.running = true;
        } else if (hasDdcutil) {
            initDdcutil.running = true;
        }
    }

    Process {
        id: initBrightnessctl
        command: ["bash", "-c", "device=$(brightnessctl -l | grep -E '(kbd|keyboard|asus::kbd)' | head -1 | sed \"s/.*Device '//\" | sed \"s/'.*//\"); if [ -n \"$device\" ]; then if brightnessctl -d \"$device\" | grep -q 'Current brightness: 0'; then echo \"0\"; else echo \"1\"; fi; fi"]
        stdout: StdioCollector {
            onStreamFinished: {
                if (text.trim() !== "") {
                    const enabled = text.trim() === "1";
                    root.enabled = enabled;
                    root.brightness = enabled ? 1.0 : 0.0;
                }
            }
        }
    }

    Process {
        id: initSysfs
        command: ["bash", "-c", `if [ -f "${root.sysfsPath}/brightness" ] && [ -f "${root.sysfsPath}/max_brightness" ]; then current=$(cat ${root.sysfsPath}/brightness); max=$(cat ${root.sysfsPath}/max_brightness); echo "$current $max"; fi`]
        stdout: StdioCollector {
            onStreamFinished: {
                if (text.trim() !== "") {
                    const parts = text.trim().split(' ');
                    if (parts.length === 2) {
                        const current = parseInt(parts[0]);
                        const max = parseInt(parts[1]);
                        if (max > 0) {
                            root.brightness = current / max;
                            root.enabled = current > 0;
                        }
                    }
                }
            }
        }
    }

    Process {
        id: initDdcutil
        command: ["bash", "-c", "ddcutil getvcp 08 --brief 2>/dev/null || echo '0 100'"]
        stdout: StdioCollector {
            onStreamFinished: {
                const parts = text.trim().split(' ');
                if (parts.length === 2) {
                    const current = parseInt(parts[0]);
                    const max = parseInt(parts[1]);
                    if (max > 0) {
                        root.brightness = current / max;
                        root.enabled = current > 0;
                    }
                }
            }
        }
    }

    // Set brightness
    function setBrightness(value: real): void {
        if (!available) return;
        
        value = Math.max(0, Math.min(1, value));
        const rounded = Math.round(value * 100);
        
        if (Math.round(brightness * 100) === rounded) return;
        
        brightness = value;
        enabled = value > 0;
        
        if (hasBrightnessctl) {
            setBrightnessctl.running = true;
        } else if (hasSysfs) {
            setSysfs.running = true;
        } else if (hasDdcutil) {
            setDdcutil.running = true;
        }
        
        // Save to persistent storage
        props.brightness = brightness;
        props.enabled = enabled;
    }

    Process {
        id: setBrightnessctl
        command: ["bash", "-c", `device=$(brightnessctl -l | grep -E '(kbd|keyboard|asus::kbd)' | head -1 | sed "s/.*Device '//" | sed "s/'.*//"); if [ -n "$device" ]; then brightnessctl set ${Math.round(root.brightness * 100)}% -d "$device"; fi`]
    }

    Process {
        id: setSysfs
        command: ["bash", "-c", `if [ -f "${root.sysfsPath}/max_brightness" ]; then max=$(cat ${root.sysfsPath}/max_brightness); echo $((Math.round(root.brightness * max))) > ${root.sysfsPath}/brightness; fi`]
    }

    Process {
        id: setDdcutil
        command: ["ddcutil", "setvcp", "08", Math.round(root.brightness * 100)]
    }

    // Toggle on/off
    function toggle(): void {
        if (!available) return;
        
        if (enabled) {
            setBrightness(0);
        } else {
            setBrightness(brightness > 0 ? brightness : 0.5);
        }
    }

    // IPC handler for external control
    IpcHandler {
        target: "keyboardBacklight"

        function isEnabled(): bool {
            return root.enabled;
        }

        function getBrightness(): real {
            return root.brightness;
        }

        function setBrightness(value: real): void {
            root.setBrightness(value);
        }

        function toggle(): void {
            root.toggle();
        }

        function isAvailable(): bool {
            return root.available;
        }
    }
}

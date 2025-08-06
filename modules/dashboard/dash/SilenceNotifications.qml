import QtQuick 2.15
import Quickshell
import Quickshell.Io
import qs.services

Item {
    id: root
    property bool toggled: false
    property bool manualToggle: false

    // Property to track silent mode state
    property bool silent: false

    // Function to toggle silent mode
    function toggle(value) {
        console.log("SilenceNotifications toggle called with value:", value);
        
        // Prevent automatic refreshes during operation
        root.manualToggle = true;
        refreshTimer.stop();
        
        // Update UI immediately
        root.toggled = value;
        root.silent = value;
        
        if (value) {
            // Enable silent mode - prevent new notifications from showing as popups
            console.log("Enabling silent mode");
            Notifs.silent = true;
        } else {
            // Disable silent mode - allow notifications to show as popups
            console.log("Disabling silent mode");
            Notifs.silent = false;
        }
        
        // Re-enable checks after delay
        Qt.callLater(function() {
            refreshTimer.restart();
            root.manualToggle = false;
        }, 500);
    }

    // Function to check current silent mode state
    function refreshState() {
        console.log("Refreshing silence notifications state...");
        // For now, we'll use the local state since this is managed by the UI
        // In a real implementation, you might want to check system notification settings
        if (!root.manualToggle) {
            // The state is managed locally, so we don't need to check external state
            console.log("Silent mode state:", root.silent);
        }
    }

    Timer {
        id: refreshTimer
        interval: 3000  // 3 second refresh interval
        running: false
        onTriggered: refreshState()
    }

    Component.onCompleted: {
        console.log("SilenceNotifications component initialized");
        // Initialize with current state from Notifs service
        root.silent = Notifs.silent;
        root.toggled = Notifs.silent;
    }

    // Listen for changes in Notifs silent state
    Connections {
        target: Notifs
        
        function onSilentChanged() {
            if (!root.manualToggle) {
                root.silent = Notifs.silent;
                root.toggled = Notifs.silent;
            }
        }
    }
} 
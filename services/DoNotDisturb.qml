pragma Singleton

import qs.components.misc
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications
import QtQuick

Singleton {
    id: root

    property alias enabled: props.enabled
    property list<Notification> pending: []

    PersistentProperties {
        id: props

        property bool enabled: false

        reloadableId: "doNotDisturb"
    }

    // Toggle function
    function toggle(): void {
        root.enabled = !root.enabled;
    }

    // Handle notification filtering
    function shouldShowNotification(notification: Notification): bool {
        return !root.enabled;
    }

    // Process pending notifications when DND is disabled
    function processPendingNotifications(): void {
        if (!enabled && pending.length > 0) {
            for (const notif of pending) {
                if (notif && Notifs.notifComp) {
                    // Re-add to main notification list
                    const notifObj = Notifs.notifComp.createObject(null, {
                        popup: true,
                        notification: notif
                    });
                    if (notifObj) {
                        Notifs.list.push(notifObj);
                    }
                }
            }
            pending = [];
        }
    }

    // Watch for enabled changes
    onEnabledChanged: {
        if (!enabled) {
            // DND disabled - process pending notifications
            processPendingNotifications();
        } else {
            // DND enabled - hide all current popups
            if (Notifs && Notifs.list) {
                for (const notif of Notifs.list) {
                    if (notif && notif.popup) {
                        notif.popup = false;
                    }
                }
            }
        }
    }

    CustomShortcut {
        name: "toggleDnd"
        description: "Toggle Do Not Disturb"
        onPressed: root.toggle();
    }

    IpcHandler {
        target: "doNotDisturb"

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

        function getPendingCount(): int {
            return root.pending.length;
        }
    }
}

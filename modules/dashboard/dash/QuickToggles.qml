import qs.components
import qs.components.controls
import qs.services
import qs.config
import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

StyledRect {
    id: root

    anchors.fill: parent
    implicitHeight: 200
    radius: Appearance.rounding.small

    GridLayout {
        anchors.fill: parent
        anchors.margins: Appearance.padding.normal
        columns: 3

        StyledRect {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: IdleInhibitor.enabled ? 8 : height / 2 // Perfect circle when unselected, rounded square when selected
            color: IdleInhibitor.enabled ? Colours.palette.m3primary : Colours.palette.m3surfaceContainerLow
            Behavior on radius {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutCubic
                }
            }
            Behavior on color {
                ColorAnimation {
                    duration: 100
                    easing.type: Easing.OutCubic
                }
            }
            StateLayer {
                id: idleInhibitorToggle
                function onClicked(): void {
                    IdleInhibitor.enabled = !IdleInhibitor.enabled;
                }
            }
            MaterialIcon {
                anchors.centerIn: parent
                text: IdleInhibitor.enabled ? "pause_circle" : "play_circle"
                color: IdleInhibitor.enabled ? Colours.palette.m3onPrimary : Colours.palette.m3onSurfaceVariant
                font.pointSize: Appearance.font.size.extraLarge
                Behavior on color {
                    ColorAnimation {
                        duration: 100
                        easing.type: Easing.OutCubic
                    }
                }
            }
            // Plain tooltip
            ToolTip {
                visible: idleInhibitorToggle.containsMouse
                text: "Idle Inhibitor"
                delay: 500
                timeout: 3000

                background: Rectangle {
                    color: Colours.palette.m3surfaceContainerHighest
                    radius: 4 // Material 3 extra-small corner radius
                    border.width: 0 // Remove border
                }

                contentItem: Text {
                    text: "Idle Inhibitor"
                    color: Colours.palette.m3onSurface
                    font.pointSize: Appearance.font.size.small
                }
            }
        }

        // Night Mode Toggle
        StyledRect {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: NightMode.enabled ? 8 : height / 2 // Perfect circle when unselected, rounded square when selected
            color: NightMode.enabled ? Colours.palette.m3secondary : Colours.palette.m3surfaceContainerLow
            Behavior on radius {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutCubic
                }
            }
            Behavior on color {
                ColorAnimation {
                    duration: 100
                    easing.type: Easing.OutCubic
                }
            }
            StateLayer {
                id: nightModeToggle
                function onClicked(): void {
                    NightMode.toggle();
                }
            }
            MaterialIcon {
                anchors.centerIn: parent
                text: NightMode.enabled ? "dark_mode" : "light_mode"
                color: NightMode.enabled ? Colours.palette.m3onSecondary : Colours.palette.m3onSurfaceVariant
                font.pointSize: Appearance.font.size.extraLarge
                Behavior on color {
                    ColorAnimation {
                        duration: 100
                        easing.type: Easing.OutCubic
                    }
                }
            }
            // Plain tooltip
            ToolTip {
                visible: nightModeToggle.containsMouse
                text: "Night Mode"
                delay: 500
                timeout: 3000

                background: Rectangle {
                    color: Colours.palette.m3surfaceContainerHighest
                    radius: 4 // Material 3 extra-small corner radius
                    border.width: 0 // Remove border
                }

                contentItem: Text {
                    text: "Night Mode"
                    color: Colours.palette.m3onSurface
                    font.pointSize: Appearance.font.size.small
                }
            }
        }

        // Keyboard Backlight Toggle
        StyledRect {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: KeyboardBacklight.enabled ? 8 : height / 2 // Perfect circle when unselected, rounded square when selected
            color: KeyboardBacklight.enabled ? Colours.palette.m3tertiary : Colours.palette.m3surfaceContainerLow
            Behavior on radius {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutCubic
                }
            }
            Behavior on color {
                ColorAnimation {
                    duration: 100
                    easing.type: Easing.OutCubic
                }
            }
            StateLayer {
                id: kbBacklightToggle
                function onClicked(): void {
                    KeyboardBacklight.toggle();
                }
            }
            MaterialIcon {
                anchors.centerIn: parent
                text: "keyboard"
                color: KeyboardBacklight.enabled ? Colours.palette.m3onTertiary : Colours.palette.m3onSurfaceVariant
                font.pointSize: Appearance.font.size.extraLarge
                Behavior on color {
                    ColorAnimation {
                        duration: 100
                        easing.type: Easing.OutCubic
                    }
                }
            }
            // Plain tooltip
            ToolTip {
                visible: kbBacklightToggle.containsMouse
                text: "Keyboard Backlight"
                delay: 500
                timeout: 3000

                background: Rectangle {
                    color: Colours.palette.m3surfaceContainerHighest
                    radius: 4 // Material 3 extra-small corner radius
                    border.width: 0 // Remove border
                }

                contentItem: Text {
                    text: "Keyboard Backlight"
                    color: Colours.palette.m3onSurface
                    font.pointSize: Appearance.font.size.small
                }
            }
        }

        // Do Not Disturb Toggle
        StyledRect {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: DoNotDisturb.enabled ? 8 : height / 2 // Perfect circle when unselected, rounded square when selected
            color: DoNotDisturb.enabled ? Colours.palette.m3error : Colours.palette.m3surfaceContainerLow
            Behavior on radius {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutCubic
                }
            }
            Behavior on color {
                ColorAnimation {
                    duration: 100
                    easing.type: Easing.OutCubic
                }
            }
            StateLayer {
                id: dndToggle
                function onClicked(): void {
                    DoNotDisturb.toggle();
                }
            }
            MaterialIcon {
                anchors.centerIn: parent
                text: DoNotDisturb.enabled ? "notifications_off" : "notifications"
                color: DoNotDisturb.enabled ? Colours.palette.m3onError : Colours.palette.m3onSurfaceVariant
                font.pointSize: Appearance.font.size.extraLarge
                Behavior on color {
                    ColorAnimation {
                        duration: 100
                        easing.type: Easing.OutCubic
                    }
                }
            }
            // Plain tooltip
            ToolTip {
                visible: dndToggle.containsMouse
                text: "Do Not Disturb"
                delay: 500
                timeout: 3000

                background: Rectangle {
                    color: Colours.palette.m3surfaceContainerHighest
                    radius: 4 // Material 3 extra-small corner radius
                    border.width: 0 // Remove border
                }

                contentItem: Text {
                    text: "Do Not Disturb"
                    color: Colours.palette.m3onSurface
                    font.pointSize: Appearance.font.size.small
                }
            }
        }

        // VPN Toggle
        StyledRect {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: (Vpn.enabled || Vpn.connecting) ? 8 : height / 2 // Perfect circle when unselected, rounded square when selected/connecting
            color: {
                if (Vpn.connecting)
                    return Colours.palette.m3primary;
                if (Vpn.disconnecting)
                    return Colours.palette.m3error;
                return Vpn.enabled ? Colours.palette.m3primary : Colours.palette.m3surfaceContainerLow;
            }
            visible: Vpn.available
            Behavior on radius {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutCubic
                }
            }
            Behavior on color {
                ColorAnimation {
                    duration: 100
                    easing.type: Easing.OutCubic
                }
            }
            StateLayer {
                id: vpnToggle
                function onClicked(): void {
                    if (!Vpn.connecting && !Vpn.disconnecting) {
                        Vpn.toggle();
                    }
                }
            }

            // Main icon or loading indicator
            Item {
                anchors.centerIn: parent
                width: parent.width * 0.6
                height: parent.height * 0.6

                // Loading spinner for connecting/disconnecting states
                StyledBusyIndicator {
                    anchors.centerIn: parent
                    strokeWidth: Appearance.padding.small
                    bgColour: Colours.palette.m3surfaceContainerHigh
                    fgColour: Vpn.connecting ? Colours.palette.m3onTertiary : Colours.palette.m3onError
                    implicitSize: Math.min(parent.width, parent.height) * 0.8
                    running: Vpn.connecting || Vpn.disconnecting
                    visible: Vpn.connecting || Vpn.disconnecting
                }

                // Main icon when not connecting/disconnecting
                MaterialIcon {
                    anchors.centerIn: parent
                    text: Vpn.enabled ? "shield" : "shield"
                    color: {
                        if (Vpn.connecting)
                            return Colours.palette.m3onPrimary;
                        if (Vpn.disconnecting)
                            return Colours.palette.m3onError;
                        return Vpn.enabled ? Colours.palette.m3onPrimary : Colours.palette.m3onSurfaceVariant;
                    }
                    font.pointSize: Appearance.font.size.extraLarge
                    opacity: (Vpn.connecting || Vpn.disconnecting) ? 0 : (Vpn.available ? 1.0 : 0.5)
                    visible: !Vpn.connecting && !Vpn.disconnecting
                    Behavior on color {
                        ColorAnimation {
                            duration: 100
                            easing.type: Easing.OutCubic
                        }
                    }
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 100
                            easing.type: Easing.OutCubic
                        }
                    }
                }
            }

            // Tooltip
            ToolTip {
                visible: vpnToggle.containsMouse
                delay: 500
                timeout: 3000

                background: Rectangle {
                    color: Colours.palette.m3surfaceContainerHighest
                    radius: 4 // Material 3 extra-small corner radius
                    border.width: 0 // Remove border
                }

                contentItem: Text {
                    text: {
                        return Vpn.available ? "Cloudflare WARP" : "Cloudflare WARP (Not Available)";
                    }
                    color: Vpn.available ? Colours.palette.m3onSurface : Colours.palette.m3onSurfaceVariant
                }
            }
        }

        // Gamemode Toggle
        StyledRect {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: GameMode.enabled ? 8 : height / 2 // Perfect circle when unselected, rounded square when selected
            color: GameMode.enabled ? Colours.palette.m3secondary : Colours.palette.m3surfaceContainerLow
            Behavior on radius {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutCubic
                }
            }
            Behavior on color {
                ColorAnimation {
                    duration: 100
                    easing.type: Easing.OutCubic
                }
            }
            StateLayer {
                id: gamemodeToggle
                function onClicked(): void {
                    GameMode.enabled = !GameMode.enabled;
                }
            }
            MaterialIcon {
                anchors.centerIn: parent
                text: GameMode.enabled ? "rocket_launch" : "sports_esports"
                color: GameMode.enabled ? Colours.palette.m3onSecondary : Colours.palette.m3onSurfaceVariant
                font.pointSize: Appearance.font.size.extraLarge
                Behavior on color {
                    ColorAnimation {
                        duration: 100
                        easing.type: Easing.OutCubic
                    }
                }
            }
            // Plain tooltip
            ToolTip {
                visible: gamemodeToggle.containsMouse
                text: "Gamemode"
                delay: 500
                timeout: 3000

                background: Rectangle {
                    color: Colours.palette.m3surfaceContainerHighest
                    radius: 4 // Material 3 extra-small corner radius
                    border.width: 0 // Remove border
                }

                contentItem: Text {
                    text: "Gamemode"
                    color: Colours.palette.m3onSurface
                    font.pointSize: Appearance.font.size.small
                }
            }
        }
    }
}

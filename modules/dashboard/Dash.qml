import qs.components
import qs.components.controls
import qs.services
import qs.config
import "dash"
import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

GridLayout {
    id: root
    required property PersistentProperties visibilities
    required property PersistentProperties state
    rowSpacing: Appearance.spacing.normal
    columnSpacing: Appearance.spacing.normal
    Rect {
        Layout.column: 2
        Layout.columnSpan: 3
        Layout.preferredWidth: user.implicitWidth
        Layout.preferredHeight: user.implicitHeight
        User {
            id: user
            visibilities: root.visibilities
            state: root.state
        }
    }
    Rect {
        Layout.row: 0
        Layout.columnSpan: 2
        Layout.preferredWidth: Config.dashboard.sizes.weatherWidth
        Layout.fillHeight: true
        Weather {}
    }
    Rect {
        Layout.row: 1
        Layout.preferredWidth: dateTime.implicitWidth
        Layout.fillHeight: true
        DateTime {
            id: dateTime
        }
    }
    Rect {
        Layout.row: 1
        Layout.column: 1
        Layout.columnSpan: 3
        Layout.fillWidth: true
        Layout.preferredHeight: 200
        // Subtle background for quick settings
        Rectangle {
            anchors.fill: parent
            anchors.margins: Appearance.padding.normal
            color: Colours.palette.m3surfaceContainerLow
            radius: Appearance.rounding.normal
            opacity: 0.6
        }
        // Quick Settings Connected Button Group - 3x2 Grid
        GridLayout {
            anchors.fill: parent
            anchors.margins: Appearance.padding.large
            columns: 3
            rowSpacing: 2 // Connected button group inner padding
            columnSpacing: 2 // Connected button group inner padding
            // Idle Inhibitor Toggle
            StyledRect {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: height // Maintain square aspect ratio
                Layout.preferredHeight: width // Maintain square aspect ratio
                radius: IdleInhibitor.enabled ? 8 : height / 2 // Perfect circle when unselected, rounded square when selected
                color: IdleInhibitor.enabled ? Colours.palette.m3primary : Colours.palette.m3surfaceContainer
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
                    anchors.fill: parent
                    color: IdleInhibitor.enabled ? Colours.palette.m3onPrimary : Colours.palette.m3onSurfaceVariant
                    hoverEnabled: true
                    Behavior on color {
                        ColorAnimation {
                            duration: 100
                            easing.type: Easing.OutCubic
                        }
                    }
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
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
            // Night Mode Toggle
            StyledRect {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: height // Maintain square aspect ratio
                Layout.preferredHeight: width // Maintain square aspect ratio
                radius: NightMode.enabled ? 8 : height / 2 // Perfect circle when unselected, rounded square when selected
                color: NightMode.enabled ? Colours.palette.m3secondary : Colours.palette.m3surfaceContainer
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
                    anchors.fill: parent
                    color: NightMode.enabled ? Colours.palette.m3onSecondary : Colours.palette.m3onSurfaceVariant
                    hoverEnabled: true
                    Behavior on color {
                        ColorAnimation {
                            duration: 100
                            easing.type: Easing.OutCubic
                        }
                    }
                    function onClicked(): void {
                        NightMode.toggle();
                    }
                }
                MaterialIcon {
                    anchors.centerIn: parent
                    text: NightMode.enabled ? "dark_mode" : "light_mode"
                    color: NightMode.enabled ? Colours.palette.m3onSecondary : (NightMode.available ? Colours.palette.m3onSurfaceVariant : Colours.palette.m3onSurfaceVariant + "40")
                    font.pointSize: Appearance.font.size.extraLarge
                    opacity: NightMode.available ? 1.0 : 0.5
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
                // Plain tooltip
                ToolTip {
                    visible: nightModeToggle.containsMouse
                    text: NightMode.available ? "Night Mode" : "Night Mode (Not Available)"
                    delay: 500
                    timeout: 3000

                    background: Rectangle {
                        color: Colours.palette.m3surfaceContainerHighest
                        radius: 4 // Material 3 extra-small corner radius
                        border.width: 0 // Remove border
                    }

                    contentItem: Text {
                        text: NightMode.available ? "Night Mode" : "Night Mode (Not Available)"
                        color: NightMode.available ? Colours.palette.m3onSurface : Colours.palette.m3onSurfaceVariant
                        font.pointSize: Appearance.font.size.small
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
            // Keyboard Backlight Toggle
            StyledRect {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: height // Maintain square aspect ratio
                Layout.preferredHeight: width // Maintain square aspect ratio
                radius: kbBacklightToggle.checked ? 8 : height / 2 // Perfect circle when unselected, rounded square when selected
                color: kbBacklightToggle.checked ? Colours.palette.m3tertiary : Colours.palette.m3surfaceContainer
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
                    anchors.fill: parent
                    color: kbBacklightToggle.checked ? Colours.palette.m3onTertiary : Colours.palette.m3onSurfaceVariant
                    hoverEnabled: true
                    property bool checked: KeyboardBacklight.enabled
                    Behavior on color {
                        ColorAnimation {
                            duration: 100
                            easing.type: Easing.OutCubic
                        }
                    }
                    function onClicked(): void {
                        KeyboardBacklight.toggle();
                    }
                }
                MaterialIcon {
                    anchors.centerIn: parent
                    text: "keyboard"
                    color: kbBacklightToggle.checked ? Colours.palette.m3onTertiary : (KeyboardBacklight.available ? Colours.palette.m3onSurfaceVariant : Colours.palette.m3onSurfaceVariant + "40")
                    font.pointSize: Appearance.font.size.extraLarge
                    opacity: KeyboardBacklight.available ? 1.0 : 0.5
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
                // Plain tooltip
                ToolTip {
                    visible: kbBacklightToggle.containsMouse
                    text: KeyboardBacklight.available ? "Keyboard Backlight" : "Keyboard Backlight (Not Available)"
                    delay: 500
                    timeout: 3000

                    background: Rectangle {
                        color: Colours.palette.m3surfaceContainerHighest
                        radius: 4 // Material 3 extra-small corner radius
                        border.width: 0 // Remove border
                    }

                    contentItem: Text {
                        text: KeyboardBacklight.available ? "Keyboard Backlight" : "Keyboard Backlight (Not Available)"
                        color: KeyboardBacklight.available ? Colours.palette.m3onSurface : Colours.palette.m3onSurfaceVariant
                        font.pointSize: Appearance.font.size.small
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
            // Do Not Disturb Toggle
            StyledRect {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: height // Maintain square aspect ratio
                Layout.preferredHeight: width // Maintain square aspect ratio
                radius: DoNotDisturb.enabled ? 8 : height / 2 // Perfect circle when unselected, rounded square when selected
                color: DoNotDisturb.enabled ? Colours.palette.m3error : Colours.palette.m3surfaceContainer
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
                    anchors.fill: parent
                    color: DoNotDisturb.enabled ? Colours.palette.m3onError : Colours.palette.m3onSurfaceVariant
                    hoverEnabled: true
                    Behavior on color {
                        ColorAnimation {
                            duration: 100
                            easing.type: Easing.OutCubic
                        }
                    }
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
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
            // VPN Toggle
            StyledRect {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: height // Maintain square aspect ratio
                Layout.preferredHeight: width // Maintain square aspect ratio
                radius: (Vpn.enabled || Vpn.connecting) ? 8 : height / 2 // Perfect circle when unselected, rounded square when selected/connecting
                color: {
                    if (Vpn.connecting) return Colours.palette.m3primary;
                    if (Vpn.disconnecting) return Colours.palette.m3error;
                    return Vpn.enabled ? Colours.palette.m3primary : Colours.palette.m3surfaceContainer;
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
                    anchors.fill: parent
                    color: {
                        if (Vpn.connecting) return Colours.palette.m3primary;
                        if (Vpn.disconnecting) return Colours.palette.m3onError;
                        return Vpn.enabled ? Colours.palette.m3onPrimary : Colours.palette.m3onSurfaceVariant;
                    }
                    hoverEnabled: !Vpn.connecting && !Vpn.disconnecting
                    Behavior on color {
                        ColorAnimation {
                            duration: 100
                            easing.type: Easing.OutCubic
                        }
                    }
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
                            if (Vpn.connecting) return Colours.palette.m3onPrimary;
                            if (Vpn.disconnecting) return Colours.palette.m3onError;
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
                    text: {
                        if (Vpn.connecting) return "Connecting to Cloudflare WARP...";
                        if (Vpn.disconnecting) return "Disconnecting from Cloudflare WARP...";
                        if (Vpn.needsRegistration) return "Cloudflare WARP (Needs Registration)";
                        return Vpn.available ? "Cloudflare WARP" : "Cloudflare WARP (Not Available)";
                    }
                    delay: 500
                    timeout: 3000

                    background: Rectangle {
                        color: Colours.palette.m3surfaceContainerHighest
                        radius: 4 // Material 3 extra-small corner radius
                        border.width: 0 // Remove border
                    }

                    contentItem: Text {
                        text: {
                            if (Vpn.connecting) return "Connecting to Cloudflare WARP...";
                            if (Vpn.disconnecting) return "Disconnecting from Cloudflare WARP...";
                            if (Vpn.needsRegistration) return "Cloudflare WARP (Needs Registration)";
                            return Vpn.available ? "Cloudflare WARP" : "Cloudflare WARP (Not Available)";
                        }
                        color: Vpn.available ? Colours.palette.m3onSurface : Colours.palette.m3onSurfaceVariant
                        font.pointSize: Appearance.font.size.small
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
            // Gamemode Toggle
            StyledRect {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: height // Maintain square aspect ratio
                Layout.preferredHeight: width // Maintain square aspect ratio
                radius: GameMode.enabled ? 8 : height / 2 // Perfect circle when unselected, rounded square when selected
                color: GameMode.enabled ? Colours.palette.m3secondary : Colours.palette.m3surfaceContainer
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
                    anchors.fill: parent
                    color: GameMode.enabled ? Colours.palette.m3onSecondary : Colours.palette.m3onSurfaceVariant
                    hoverEnabled: true
                    Behavior on color {
                        ColorAnimation {
                            duration: 100
                            easing.type: Easing.OutCubic
                        }
                    }
                    onClicked: GameMode.enabled = !GameMode.enabled
                }
                MaterialIcon {
                    anchors.centerIn: parent
                    text: GameMode.enabled ? "rocket_launch" : "sports_esports"
                    font.pointSize: Appearance.font.size.extraLarge
                    color: gamemodeToggle.color
                }
                // Tooltip
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
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }
    }
    Rect {
        Layout.row: 1
        Layout.column: 4
        Layout.preferredWidth: resources.implicitWidth
        Layout.fillHeight: true
        Resources {
            id: resources
        }
    }
    Rect {
        Layout.row: 0
        Layout.column: 5
        Layout.rowSpan: 2
        Layout.preferredWidth: media.implicitWidth
        Layout.fillHeight: true
        Media {
            id: media
        }
    }
    component Rect: StyledRect {
        radius: Appearance.rounding.small
        color: Colours.tPalette.m3surfaceContainer
    }
}

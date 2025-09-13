import qs.components
import qs.components.controls
import qs.services
import qs.config
import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

StyledRect {
    id: root

    // Required properties
    required property var service
    required property var config
    required property string toggleId

    // Optional properties
    property bool showTooltip: true
    property bool showLoadingState: false
    property bool tooltipsEnabled: true
    property int tooltipDelay: 500
    property int tooltipTimeout: 3000
    property bool showUnavailableServices: true
    property color loadingColor: Colours.palette.m3onTertiary
    property color loadingErrorColor: Colours.palette.m3onError

    // Layout properties
    Layout.fillWidth: true
    Layout.fillHeight: true

    // Visual properties
    radius: service.enabled ? 8 : height / 2 // Perfect circle when unselected, rounded square when selected
    color: getColor()
    visible: getVisibility()

    // Behaviors
    Behavior on radius {
        NumberAnimation {
            duration: Appearance.anim.durations.small
            easing.type: Easing.OutCubic
        }
    }
    Behavior on color {
        ColorAnimation {
            duration: Appearance.anim.durations.small
            easing.type: Easing.OutCubic
        }
    }

    // State layer for interactions
    StateLayer {
        id: stateLayer
        function onClicked(): void {
            if (canToggle()) {
                // Try direct toggle first, then fallback to enabled property
                if (typeof service.toggle === 'function') {
                    service.toggle();
                } else {
                    service.enabled = !service.enabled;
                }
            }
        }
    }

    // Main content area
    Item {
        anchors.centerIn: parent
        width: parent.width * 0.6
        height: parent.height * 0.6

        // Loading indicator (for services like VPN)
        CircularIndicator {
            anchors.centerIn: parent
            strokeWidth: Appearance.padding.small
            bgColour: Colours.palette.m3surfaceContainerHigh
            fgColour: isConnecting() ? loadingColor : loadingErrorColor
            implicitSize: Math.min(parent.width, parent.height) * 0.8
            running: showLoadingState && isConnecting()
            visible: showLoadingState && isConnecting()
        }

        // Main icon
        MaterialIcon {
            anchors.centerIn: parent
            text: getIcon()
            color: getIconColor()
            font.pointSize: Appearance.font.size.extraLarge
            opacity: getIconOpacity()
            visible: !(showLoadingState && isConnecting())
            
            Behavior on color {
                ColorAnimation {
                    duration: Appearance.anim.durations.small
                    easing.type: Easing.OutCubic
                }
            }
            Behavior on opacity {
                NumberAnimation {
                    duration: Appearance.anim.durations.small
                    easing.type: Easing.OutCubic
                }
            }
        }
    }

    // Tooltip
    ToolTip {
        visible: showTooltip && stateLayer.containsMouse && tooltipsEnabled
        text: getTooltipText()
        delay: tooltipDelay
        timeout: tooltipTimeout

        background: Rectangle {
            color: Colours.palette.m3surfaceContainerHighest
            radius: Appearance.rounding.small
            border.width: 0
        }

        contentItem: Text {
            text: getTooltipText()
            color: Colours.palette.m3onSurface
            font.pointSize: Appearance.font.size.small
        }
    }

    // Helper functions
    function getColor(): color {
        if (isConnecting()) {
            return Colours.palette.m3primary;
        }
        if (isDisconnecting()) {
            return Colours.palette.m3error;
        }
        
        const colorScheme = config.colorScheme;
        const enabled = service.enabled;
        
        switch (colorScheme) {
            case "primary":
                return enabled ? Colours.palette.m3primary : Colours.palette.m3surfaceContainerLow;
            case "secondary":
                return enabled ? Colours.palette.m3secondary : Colours.palette.m3surfaceContainerLow;
            case "tertiary":
                return enabled ? Colours.palette.m3tertiary : Colours.palette.m3surfaceContainerLow;
            case "error":
                return enabled ? Colours.palette.m3error : Colours.palette.m3surfaceContainerLow;
            default:
                return enabled ? Colours.palette.m3primary : Colours.palette.m3surfaceContainerLow;
        }
    }

    function getIcon(): string {
        if (isConnecting() || isDisconnecting()) {
            return config.iconEnabled; // Use enabled icon during loading states
        }
        return service.enabled ? config.iconEnabled : config.iconDisabled;
    }

    function getIconColor(): color {
        if (isConnecting()) {
            return Colours.palette.m3onPrimary;
        }
        if (isDisconnecting()) {
            return Colours.palette.m3onError;
        }
        
        const colorScheme = config.colorScheme;
        const enabled = service.enabled;
        
        switch (colorScheme) {
            case "primary":
                return enabled ? Colours.palette.m3onPrimary : Colours.palette.m3onSurfaceVariant;
            case "secondary":
                return enabled ? Colours.palette.m3onSecondary : Colours.palette.m3onSurfaceVariant;
            case "tertiary":
                return enabled ? Colours.palette.m3onTertiary : Colours.palette.m3onSurfaceVariant;
            case "error":
                return enabled ? Colours.palette.m3onError : Colours.palette.m3onSurfaceVariant;
            default:
                return enabled ? Colours.palette.m3onPrimary : Colours.palette.m3onSurfaceVariant;
        }
    }

    function getIconOpacity(): real {
        if (isConnecting() || isDisconnecting()) {
            return 0;
        }
        return isAvailable() ? 1.0 : 0.5;
    }

    function getTooltipText(): string {
        if (!isAvailable() && showUnavailableServices) {
            return `${config.name} (Not Available)`;
        }
        return config.name;
    }

    function getVisibility(): bool {
        // Check if service has availability property and if it's available
        if (service.hasOwnProperty("available")) {
            return service.available;
        }
        return true;
    }

    function canToggle(): bool {
        // Check for connecting/disconnecting states
        if (service.hasOwnProperty("connecting") && service.connecting) {
            return false;
        }
        if (service.hasOwnProperty("disconnecting") && service.disconnecting) {
            return false;
        }
        return true;
    }

    function isConnecting(): bool {
        return service.hasOwnProperty("connecting") && service.connecting;
    }

    function isDisconnecting(): bool {
        return service.hasOwnProperty("disconnecting") && service.disconnecting;
    }

    function isAvailable(): bool {
        if (service.hasOwnProperty("available")) {
            return service.available;
        }
        return true;
    }
}
